import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../services/absen_service.dart';
import '../pages/login_page.dart';


class AbsenPage extends StatefulWidget {
  final String nik;

  const AbsenPage({super.key, required this.nik});

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}


class _AbsenPageState extends State<AbsenPage> {
  late TextEditingController nikCtrl;
  late TextEditingController tanggalCtrl;
  late TextEditingController jamCtrl;
  late TextEditingController latCtrl;
  late TextEditingController longCtrl;
  late TextEditingController shiftCtrl;

  String selectedMood = 'SENANG';
  final List<String> moodOptions = ['SENANG', 'BAHAGIA', 'GALAU', 'MARAH'];

  String selectedAbsenType = 'N'; // N: WFO, H: WFH, I: Izin, D: Dinas
  final List<String> absenTypeOptions = ['N', 'H', 'I', 'D'];

  bool loading = false;
  String message = '';
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    nikCtrl = TextEditingController(text: widget.nik);
    
    // Initialize with current date
    tanggalCtrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    
    // Initialize with current time
    jamCtrl = TextEditingController(
      text: DateFormat('HH:mm').format(DateTime.now()),
    );
    
    latCtrl = TextEditingController();
    longCtrl = TextEditingController();
    shiftCtrl = TextEditingController(text: '0');
    selectedMood = 'SENANG';

    // Auto-fill location on load
    _getCurrentLocation();
  }

  @override
  void dispose() {
    nikCtrl.dispose();
    tanggalCtrl.dispose();
    jamCtrl.dispose();
    latCtrl.dispose();
    longCtrl.dispose();
    shiftCtrl.dispose();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendapatkan lokasi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(tanggalCtrl.text),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      tanggalCtrl.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      jamCtrl.text =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> doCheckIn() async {
    // Validate inputs
    if (nikCtrl.text.isEmpty ||
        tanggalCtrl.text.isEmpty ||
        jamCtrl.text.isEmpty ||
        latCtrl.text.isEmpty ||
        longCtrl.text.isEmpty ||
        shiftCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final result = await AbsenService.checkIn(
        nik: nikCtrl.text,
        tanggal: tanggalCtrl.text,
        jam: jamCtrl.text,
        lat: double.parse(latCtrl.text),
        long: double.parse(longCtrl.text),
        shift: shiftCtrl.text,
        mood: selectedMood,
        jenisAbsen: selectedAbsenType,
      );

      setState(() {
        loading = false;
        isSuccess = result['success'] as bool;
        message = result['message'] as String;
      });

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
        isSuccess = false;
        message = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Absensi'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade400, Colors.green.shade800],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Absensi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // NIK Field
                      TextField(
                        controller: nikCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'NIK',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tanggal Field
                      TextField(
                        controller: tanggalCtrl,
                        readOnly: true,
                        onTap: _selectDate,
                        decoration: InputDecoration(
                          labelText: 'Tanggal',
                          hintText: 'yyyy-MM-dd',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Jam Field
                      TextField(
                        controller: jamCtrl,
                        readOnly: true,
                        onTap: _selectTime,
                        decoration: InputDecoration(
                          labelText: 'Jam',
                          hintText: 'HH:mm',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Latitude Field
                      TextField(
                        controller: latCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Longitude Field
                      TextField(
                        controller: longCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Shift Field
                      TextField(
                        controller: shiftCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Shift (0, 1, 2, dll)',
                          prefixIcon: const Icon(Icons.schedule),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Absen Type Field - Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: selectedAbsenType,
                        decoration: InputDecoration(
                          labelText: 'Jenis Absen',
                          prefixIcon: const Icon(Icons.work),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                        items: absenTypeOptions.map((String jenisAbsen) {
                          return DropdownMenuItem<String>(
                            value: jenisAbsen,
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Text(jenisAbsen == 'N'
                                    ? 'WFO (Kantor)'
                                    : jenisAbsen == 'H'
                                        ? 'WFH (Rumah)'
                                        : jenisAbsen == 'I'
                                            ? 'Izin'
                                            : jenisAbsen == 'D'
                                                ? 'Dinas'
                                            : ''),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              selectedAbsenType = newValue;
                            }
                          });
                        },
                      ),



                      const SizedBox(height: 16),
                      // Mood Field - Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: selectedMood,
                        decoration: InputDecoration(
                          labelText: 'Mood',
                          prefixIcon: const Icon(Icons.emoji_emotions),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                        items: moodOptions.map((String mood) {
                          return DropdownMenuItem<String>(
                            value: mood,
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Text(mood),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              selectedMood = newValue;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      // Button Container
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: loading ? null : _getCurrentLocation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.my_location),
                              label: const Text('Update Lokasi'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: loading ? null : doCheckIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.check_circle),
                              label: Text(
                                loading ? 'LOADING...' : 'ABSEN',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (message.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSuccess
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSuccess
                                  ? Colors.green.shade300
                                  : Colors.red.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSuccess ? Icons.check_circle : Icons.error,
                                color: isSuccess
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: isSuccess
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}