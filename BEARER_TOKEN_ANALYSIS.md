# Analisis Penggunaan Bearer Token dalam Aplikasi Absensi

## Tanggal: 21 Januari 2026

---

## ❌ **JAWABAN: TIDAK, Bearer Token TIDAK Digunakan**

Saat ini, API check-in dan check-out **TIDAK menggunakan Bearer Token** untuk autentikasi.

---

## 📋 Detail Implementasi Saat Ini

### 1. **API Check-In** (`AbsenService.checkIn()`)
**Endpoint**: `https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-in-v2`

**Metode Autentikasi**: Query Parameters
- `user-access=AGHRIS_MOBILE`
- `key=270F672B-3CEF-4C6C-A362-359B8B0CAEA1`

**HTTP Method**: `GET`

**Headers**: Tidak ada header Authorization

```dart
final response = await http.get(url); // Tidak ada header bearer token
```

---

### 2. **API Check-Out** (`AbsenService.checkOut()`)
**Endpoint**: `https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-out-v2`

**Metode Autentikasi**: Query Parameters
- `user-access=AGHRIS_MOBILE`
- `key=270F672B-3CEF-4C6C-A362-359B8B0CAEA1`

**HTTP Method**: `GET`

**Headers**: Tidak ada header Authorization

```dart
final response = await http.get(url); // Tidak ada header bearer token
```

---

## 🔐 Sistem Autentikasi yang Ada

### **AuthService** (Login)
File: `lib/services/auth_service.dart`

**Endpoint**: `http://hcis.holding-perkebunan.com/api/generate_token_api`

**Fungsi**:
- ✅ Melakukan login dengan NIK dan password
- ✅ Menerima JWT token dari server
- ✅ Menyimpan token ke secure storage
- ✅ Validasi token (cek expired)
- ✅ Decode token untuk mendapatkan claims

**Penyimpanan Token**:
```dart
await storage.write(key: 'jwt_token', value: tokenStr);
```

**NAMUN**: Token ini **TIDAK digunakan** untuk API check-in/check-out!

---

## ⚠️ Masalah Keamanan

### Kelemahan Implementasi Saat Ini:

1. **API Key Hardcoded**: API key tersimpan langsung di kode
   ```dart
   static const String apiKey = '270F672B-3CEF-4C6C-A362-359B8B0CAEA1';
   ```

2. **Tidak Ada Autentikasi User**: API hanya menggunakan API key global, bukan token per-user

3. **Token JWT Tidak Dimanfaatkan**: Meskipun login menghasilkan JWT token, token ini tidak digunakan untuk API check-in/check-out

4. **HTTP GET untuk Mutasi Data**: Check-in/check-out menggunakan GET method (seharusnya POST)

---

## 💡 Rekomendasi Perbaikan

### Opsi 1: Menggunakan Bearer Token (Recommended)

Ubah `AbsenService` untuk menggunakan JWT token dari login:

```dart
static Future<Map<String, dynamic>> checkIn({
  required String nik,
  required double lat,
  required double long,
  required String tanggal,
  required String jam,
  required String shift,
  required String mood,
  required String jenisAbsen,
}) async {
  try {
    // Ambil token dari secure storage
    final authService = AuthService();
    final token = await authService.getToken();
    
    if (token == null) {
      return {
        'success': false,
        'message': 'Token tidak ditemukan. Silakan login kembali.',
        'data': null,
      };
    }

    final url = Uri.parse(checkInUrl);
    
    final response = await http.post(  // Ubah ke POST
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // Tambahkan bearer token
      },
      body: jsonEncode({
        'nik': nik,
        'jenis_absen': jenisAbsen,
        'shift': shift,
        'tanggal': tanggal,
        'check_in_time': jam,
        'checkin_long': long,
        'checkin_lat': lat,
        'mood': mood,
      }),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException('Request timeout');
      },
    );

    // ... handle response
  } catch (e) {
    // ... handle error
  }
}
```

### Opsi 2: Tetap Menggunakan API Key (Jika Backend Tidak Mendukung Bearer)

Jika backend tidak mendukung bearer token untuk endpoint check-in/check-out, maka implementasi saat ini sudah benar. Namun pertimbangkan:

1. **Pindahkan API Key ke Environment Variable**
2. **Gunakan POST method** untuk keamanan
3. **Enkripsi sensitive data** dalam transit

---

## 📝 Kesimpulan

| Aspek | Status | Keterangan |
|-------|--------|------------|
| **Bearer Token di Check-In** | ❌ Tidak | Menggunakan API key di query params |
| **Bearer Token di Check-Out** | ❌ Tidak | Menggunakan API key di query params |
| **JWT Token dari Login** | ✅ Ada | Disimpan tapi tidak digunakan |
| **Secure Storage** | ✅ Ada | Menggunakan flutter_secure_storage |
| **Token Validation** | ✅ Ada | Cek expired dengan jwt_decoder |

---

## 🔧 Action Items

1. **Konfirmasi dengan Backend Team**: Apakah API check-in/check-out mendukung bearer token?
2. **Jika Ya**: Implementasikan bearer token seperti rekomendasi di atas
3. **Jika Tidak**: Pertahankan implementasi saat ini tapi perbaiki keamanan API key
4. **Testing**: Pastikan semua flow autentikasi berfungsi dengan baik

---

## 📞 Kontak Backend Team

Pertanyaan untuk Backend Developer:
- Apakah endpoint check-in/check-out mendukung Authorization header dengan Bearer token?
- Apakah JWT token dari `/api/generate_token_api` bisa digunakan untuk endpoint AGHRIS?
- Apakah ada rencana untuk migrasi dari API key ke bearer token?
