# Troubleshooting: API Berhasil di Aplikasi tapi Error di Postman

## Tanggal: 21 Januari 2026

---

## 🔴 Masalah

API check-out berhasil dipanggil dari **aplikasi Flutter** tapi **error di Postman**.

**URL yang Ditest**:
```
https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-out-v2?user-access=AGHRIS_MOBILE&key=270F672B-3CEF-4C6C-A362-359B8B0CAEA1&nik-sap-target=8006045&tanggal=2026-01-19&check-out-time=17:45&checkout-long=106.833859&checkout-lat=-6.229090&user=8006045&mood=SENANG
```

**Error di Postman/Browser**: `403 Forbidden`

---

## 🔍 Analisis Penyebab

### 1. **User-Agent Filtering** ⭐ (Paling Mungkin)

Server kemungkinan besar melakukan **filtering berdasarkan User-Agent header**.

#### Dari Aplikasi Flutter:
```dart
// http package secara default mengirim User-Agent seperti:
User-Agent: Dart/2.19 (dart:io)
// atau
User-Agent: Flutter/3.x
```

#### Dari Postman:
```
User-Agent: PostmanRuntime/7.x.x
```

#### Dari Browser:
```
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) ...
```

**Server mungkin hanya menerima request dari aplikasi mobile** dan memblokir request dari Postman/Browser.

---

### 2. **IP Whitelisting**

Server mungkin membatasi akses berdasarkan IP address:
- ✅ IP dari perangkat mobile diizinkan
- ❌ IP dari komputer/server Postman diblokir

---

### 3. **CORS (Cross-Origin Resource Sharing)**

Jika diakses dari browser, server mungkin memblokir karena CORS policy:
- Browser melakukan preflight request (OPTIONS)
- Server tidak mengizinkan origin dari browser

**Catatan**: Ini tidak berlaku untuk Postman karena Postman tidak enforce CORS.

---

### 4. **SSL/TLS Certificate Pinning**

Aplikasi mungkin menggunakan certificate pinning, tapi ini biasanya membuat aplikasi yang error, bukan Postman.

---

### 5. **Custom Headers**

Aplikasi mungkin mengirim custom headers yang tidak terlihat di kode:
- Device ID
- App Version
- Platform Info

---

## ✅ Solusi untuk Testing di Postman

### **Solusi 1: Ubah User-Agent Header**

Di Postman, tambahkan header:

```
Key: User-Agent
Value: Dart/2.19 (dart:io)
```

Atau coba:
```
Value: Flutter/3.0
```

**Langkah-langkah di Postman**:
1. Buka tab **Headers**
2. Klik **Add Header**
3. Key: `User-Agent`
4. Value: `Dart/2.19 (dart:io)`
5. Send request

---

### **Solusi 2: Gunakan cURL dengan Custom User-Agent**

```bash
curl -X GET "https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-out-v2?user-access=AGHRIS_MOBILE&key=270F672B-3CEF-4C6C-A362-359B8B0CAEA1&nik-sap-target=8006045&tanggal=2026-01-19&check-out-time=17:45&checkout-long=106.833859&checkout-lat=-6.229090&user=8006045&mood=SENANG" \
-H "User-Agent: Dart/2.19 (dart:io)"
```

---

### **Solusi 3: Intercept Request dari Aplikasi**

Gunakan tools seperti **Charles Proxy** atau **Fiddler** untuk melihat exact headers yang dikirim aplikasi:

1. Install Charles Proxy
2. Setup proxy di perangkat mobile
3. Jalankan aplikasi dan lakukan check-out
4. Lihat exact request headers yang dikirim
5. Copy semua headers ke Postman

---

### **Solusi 4: Tambahkan Logging di Aplikasi**

Modifikasi `absen_service.dart` untuk mencetak semua headers:

```dart
static Future<Map<String, dynamic>> checkOut({
  required String nik,
  required double lat,
  required double long,
  required String tanggal,
  required String jam,
  required String mood,
}) async {
  try {
    final url = Uri.parse(
      '$checkOutUrl'
      '?user-access=$userAccess'
      '&key=$apiKey'
      '&nik-sap-target=$nik'
      '&tanggal=$tanggal'
      '&check-out-time=$jam'
      '&checkout-long=$long'
      '&checkout-lat=$lat'
      '&user=$nik'
      '&mood=$mood',
    );

    print('🌐 Request URL: $url');
    
    final response = await http.get(url);
    
    // Print request headers
    print('📤 Request Headers:');
    response.request?.headers.forEach((key, value) {
      print('  $key: $value');
    });
    
    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    // ... rest of code
  } catch (e) {
    // ...
  }
}
```

---

## 🧪 Testing Checklist

Coba satu per satu:

- [ ] **Test 1**: Tambahkan header `User-Agent: Dart/2.19 (dart:io)` di Postman
- [ ] **Test 2**: Tambahkan header `User-Agent: Flutter/3.0` di Postman
- [ ] **Test 3**: Test dari IP yang sama dengan perangkat mobile
- [ ] **Test 4**: Gunakan cURL dengan custom User-Agent
- [ ] **Test 5**: Intercept request dari aplikasi dengan Charles Proxy
- [ ] **Test 6**: Tambahkan logging di aplikasi untuk melihat exact headers

---

## 📊 Perbandingan Request

| Aspek | Aplikasi Flutter | Postman | Browser |
|-------|------------------|---------|---------|
| **User-Agent** | `Dart/2.19 (dart:io)` | `PostmanRuntime/7.x` | `Mozilla/5.0 ...` |
| **CORS** | Tidak ada | Tidak ada | Ada (preflight) |
| **SSL Verification** | Bisa di-bypass | Bisa di-bypass | Strict |
| **Custom Headers** | Bisa ada | Manual | Manual |

---

## 💡 Rekomendasi

### **Untuk Development**:
1. Gunakan **User-Agent** yang sama dengan aplikasi di Postman
2. Dokumentasikan semua headers yang diperlukan
3. Buat collection Postman dengan headers yang sudah dikonfigurasi

### **Untuk Production**:
1. Pastikan API documentation mencantumkan required headers
2. Implementasikan proper error messages (bukan hanya 403)
3. Pertimbangkan untuk mengizinkan testing dari Postman dengan API key khusus

---

## 🔧 Quick Fix untuk Postman

**Tambahkan header ini di Postman**:

```
User-Agent: Dart/2.19 (dart:io)
Accept: */*
Accept-Encoding: gzip, deflate, br
```

Kemungkinan besar ini akan menyelesaikan masalah 403 Forbidden.

---

## 📝 Catatan Tambahan

- Error 403 menunjukkan server **menolak akses**, bukan masalah dengan URL atau parameters
- Jika masih error setelah menambahkan User-Agent, kemungkinan ada IP whitelisting
- Hubungi backend team untuk konfirmasi kebijakan akses API

---

## 🆘 Jika Masih Error

Jika setelah mencoba semua solusi di atas masih error, kemungkinan:

1. **IP Whitelisting**: Server hanya menerima request dari IP tertentu
2. **Device Fingerprinting**: Server melakukan validasi lebih kompleks
3. **Rate Limiting**: Terlalu banyak request dari IP yang sama
4. **Maintenance Mode**: API sedang dalam maintenance

**Solusi**: Hubungi backend team untuk whitelist IP atau mendapatkan API key khusus untuk testing.
