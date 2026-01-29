import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../services/absen_service.dart';
import '../pages/login_page.dart';
import '../pages/leaflet_map_picker_page.dart';

class CheckoutPage extends StatefulWidget {
  final String nik;

  const CheckoutPage({super.key, required this.nik});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController nikCtrl;
  late TextEditingController tanggalCtrl;
  late TextEditingController jamCtrl;
  late TextEditingController latCtrl;
  late TextEditingController longCtrl;

  String selectedMood = 'SENANG';
  final List<String> moodOptions = ['SENANG', 'BAHAGIA', 'GALAU', 'MARAH'];
  final Map<String, IconData> moodIcons = {
    'SENANG': Icons.sentiment_satisfied,
    'BAHAGIA': Icons.sentiment_very_satisfied,
    'GALAU': Icons.sentiment_neutral,
    'MARAH': Icons.sentiment_dissatisfied,
  };

  bool loading = false;
  String message = '';
  bool isSuccess = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    nikCtrl = TextEditingController(text: widget.nik);
    tanggalCtrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    jamCtrl = TextEditingController(
      text: DateFormat('HH:mm').format(DateTime.now()),
    );
    latCtrl = TextEditingController();
    longCtrl = TextEditingController();
    selectedMood = 'SENANG';

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();

    _getCurrentLocation();
  }

  @override
  void dispose() {
    nikCtrl.dispose();
    tanggalCtrl.dispose();
    jamCtrl.dispose();
    latCtrl.dispose();
    longCtrl.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latCtrl.text = position.latitude.toStringAsFixed(6);
        longCtrl.text = position.longitude.toStringAsFixed(6);
      });
    } catch (e) {
      _showSnackBar('Gagal mendapatkan lokasi: ${e.toString()}', isError: true);
    }
  }

  Future<void> _pickLocationFromMap() async {
    double? initialLat;
    double? initialLng;

    if (latCtrl.text.isNotEmpty && longCtrl.text.isNotEmpty) {
      try {
        initialLat = double.parse(latCtrl.text);
        initialLng = double.parse(longCtrl.text);
      } catch (e) {
        // Invalid coordinates
      }
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeafletMapPickerPage(
          initialLat: initialLat,
          initialLng: initialLng,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        latCtrl.text = result['latitude'].toStringAsFixed(6);
        longCtrl.text = result['longitude'].toStringAsFixed(6);
      });
      _showSnackBar('Lokasi berhasil dipilih dari peta');
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(tanggalCtrl.text),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFE53935)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      tanggalCtrl.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFE53935)),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      jamCtrl.text =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> doCheckOut() async {
    if (nikCtrl.text.isEmpty ||
        tanggalCtrl.text.isEmpty ||
        jamCtrl.text.isEmpty ||
        latCtrl.text.isEmpty ||
        longCtrl.text.isEmpty) {
      _showSnackBar('Semua field harus diisi', isError: true);
      return;
    }

    setState(() => loading = true);

    try {
      final result = await AbsenService.checkOut(
        nik: nikCtrl.text,
        tanggal: tanggalCtrl.text,
        jam: jamCtrl.text,
        lat: double.parse(latCtrl.text),
        long: double.parse(longCtrl.text),
        mood: selectedMood,
      );

      setState(() {
        loading = false;
        isSuccess = result['success'] as bool;
        message = result['message'] as String;
      });

      _showSnackBar(message, isError: !isSuccess);
    } catch (e) {
      setState(() {
        loading = false;
        isSuccess = false;
        message = 'Error: ${e.toString()}';
      });
      _showSnackBar(message, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? const Color(0xFFE53935)
            : const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7F1D1D), Color(0xFFE53935), Color(0xFFEF5350)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildInfoCard(),
                        const SizedBox(height: 20),
                        _buildFormCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Check-Out',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Akhiri kehadiran Anda',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Color(0xFFE53935), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NIK',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.nik,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Check-Out',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 24),
            _buildDateTimeSection(),
            const SizedBox(height: 24),
            _buildLocationSection(),
            const SizedBox(height: 24),
            _buildMoodSelector(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Row(
      children: [
        Expanded(
          child: _buildEditableFieldWithPicker(
            controller: tanggalCtrl,
            label: 'Tanggal',
            icon: Icons.calendar_today,
            onPickerTap: _selectDate,
            keyboardType: TextInputType.datetime,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildEditableFieldWithPicker(
            controller: jamCtrl,
            label: 'Jam',
            icon: Icons.access_time,
            onPickerTap: _selectTime,
            keyboardType: TextInputType.datetime,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lokasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: latCtrl,
                label: 'Latitude',
                icon: Icons.location_on,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: longCtrl,
                label: 'Longitude',
                icon: Icons.location_on,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildIconButton(
                label: 'GPS',
                icon: Icons.my_location,
                color: const Color(0xFFE53935),
                onPressed: loading ? null : _getCurrentLocation,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildIconButton(
                label: 'Peta',
                icon: Icons.map,
                color: const Color(0xFFF59E0B),
                onPressed: loading ? null : _pickLocationFromMap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mood Hari Ini',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: moodOptions.map((mood) {
            final isSelected = selectedMood == mood;
            return InkWell(
              onTap: () => setState(() => selectedMood = mood),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE53935)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFE53935)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      moodIcons[mood],
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mood,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFC62828)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : doCheckOut,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: loading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'SUBMIT CHECK-OUT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFFE53935), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildEditableFieldWithPicker({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onPickerTap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(icon, size: 20),
                color: const Color(0xFFE53935),
                onPressed: onPickerTap,
                tooltip: 'Pilih dari picker',
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
