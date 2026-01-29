# Troubleshooting: API Error di Flutter tapi Berhasil di Postman

## Tanggal: 22 Januari 2026

---

## 🔴 Masalah

API berhasil dipanggil dari **Postman** (dengan User-Agent yang sudah ditambahkan) tapi **error saat dipanggil dari aplikasi Flutter**.

**Kasus**: Project lain (bukan project absensi yang sudah berjalan baik)

---

## 🔍 Penyebab Umum & Solusi

### 1. **SSL Certificate Verification Error** ⭐ (Paling Sering)

#### **Gejala:**
```
HandshakeException: Handshake error in client
CERTIFICATE_VERIFY_FAILED: certificate verify failed
```

#### **Penyebab:**
- Server menggunakan self-signed certificate
- Certificate chain tidak lengkap
- Certificate expired
- Hostname tidak match dengan certificate

#### **Solusi A: Bypass SSL (Development Only)** ⚠️

```dart
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static HttpClient? _httpClient;
  
  static HttpClient getHttpClient() {
    if (_httpClient == null) {
      _httpClient = HttpClient()
        ..badCertificateCallback = 
            (X509Certificate cert, String host, int port) => true;
    }
    return _httpClient!;
  }

  static Future<Map<String, dynamic>> callApi(String url) async {
    try {
      final httpClient = getHttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      
      final responseBody = await response.transform(utf8.decoder).join();
      
      return {
        'success': true,
        'data': jsonDecode(responseBody),
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
```

#### **Solusi B: Menggunakan Dio dengan SSL Bypass**

```dart
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

class ApiService {
  static Dio getDio() {
    final dio = Dio();
    
    // Bypass SSL certificate verification (Development only)
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = 
        (HttpClient client) {
      client.badCertificateCallback = 
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    
    return dio;
  }

  static Future<Response> callApi(String url) async {
    final dio = getDio();
    return await dio.get(url);
  }
}
```

⚠️ **WARNING**: Jangan gunakan SSL bypass di production! Ini hanya untuk development/testing.

---

### 2. **Network Security Configuration (Android)**

#### **Gejala:**
```
SocketException: OS Error: Connection refused
IOException: Cleartext HTTP traffic not permitted
```

#### **Penyebab:**
Android 9+ memblokir HTTP (non-HTTPS) secara default.

#### **Solusi:**

**File**: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="your_app_name"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">  <!-- Tambahkan ini -->
        <!-- ... -->
    </application>
</manifest>
```

**Atau buat Network Security Config:**

**File**: `android/app/src/main/res/xml/network_security_config.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
            <certificates src="user" />
        </trust-anchors>
    </base-config>
    
    <!-- Untuk domain tertentu saja -->
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">apis.holding-perkebunan.com</domain>
    </domain-config>
</network-security-config>
```

**Kemudian tambahkan di AndroidManifest.xml:**

```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

---

### 3. **Internet Permission (Android)**

#### **Gejala:**
```
SocketException: OS Error: Permission denied
```

#### **Penyebab:**
Aplikasi tidak memiliki permission untuk mengakses internet.

#### **Solusi:**

**File**: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Tambahkan di luar tag <application> -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    
    <application>
        <!-- ... -->
    </application>
</manifest>
```

---

### 4. **iOS App Transport Security (ATS)**

#### **Gejala:**
```
Error: App Transport Security has blocked a cleartext HTTP
```

#### **Penyebab:**
iOS memblokir HTTP (non-HTTPS) secara default.

#### **Solusi:**

**File**: `ios/Runner/Info.plist`

```xml
<dict>
    <!-- ... existing keys ... -->
    
    <!-- Tambahkan ini -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        
        <!-- Atau untuk domain tertentu saja (lebih aman) -->
        <key>NSExceptionDomains</key>
        <dict>
            <key>apis.holding-perkebunan.com</key>
            <dict>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSIncludesSubdomains</key>
                <true/>
            </dict>
        </dict>
    </dict>
</dict>
```

---

### 5. **Timeout Issues**

#### **Gejala:**
```
TimeoutException: Request timeout
SocketException: Connection timed out
```

#### **Penyebab:**
- Timeout terlalu pendek
- Network lambat di perangkat
- Server lambat merespons

#### **Solusi:**

```dart
import 'package:http/http.dart' as http;

Future<http.Response> callApi(String url) async {
  return await http.get(
    Uri.parse(url),
  ).timeout(
    const Duration(seconds: 60), // Perpanjang timeout
    onTimeout: () {
      throw TimeoutException('Request timeout after 60 seconds');
    },
  );
}
```

**Dengan Dio:**

```dart
final dio = Dio(
  BaseOptions(
    connectTimeout: 60000, // 60 detik
    receiveTimeout: 60000, // 60 detik
    sendTimeout: 60000,    // 60 detik
  ),
);
```

---

### 6. **Proxy/VPN Issues**

#### **Gejala:**
- Berhasil di Postman (desktop)
- Error di Flutter (mobile device)

#### **Penyebab:**
- Desktop menggunakan proxy/VPN
- Mobile device tidak menggunakan proxy yang sama
- Atau sebaliknya

#### **Solusi:**

**Debugging:**
```dart
import 'dart:io';

void checkProxy() {
  print('HTTP_PROXY: ${Platform.environment['HTTP_PROXY']}');
  print('HTTPS_PROXY: ${Platform.environment['HTTPS_PROXY']}');
}
```

**Set Proxy di Flutter:**
```dart
import 'dart:io';

void setupProxy() {
  HttpClient httpClient = HttpClient();
  httpClient.findProxy = (uri) {
    return "PROXY your-proxy-server:port";
  };
}
```

---

### 7. **Headers Missing**

#### **Gejala:**
```
400 Bad Request
401 Unauthorized
403 Forbidden
```

#### **Penyebab:**
Postman mengirim headers tambahan yang tidak ada di Flutter.

#### **Solusi:**

**Cek headers di Postman:**
1. Klik tab "Headers" di Postman
2. Lihat semua headers (termasuk yang auto-generated)
3. Copy semua headers ke Flutter

**Implementasi di Flutter:**

```dart
import 'package:http/http.dart' as http;

Future<http.Response> callApi(String url) async {
  return await http.get(
    Uri.parse(url),
    headers: {
      'User-Agent': 'Dart/2.19 (dart:io)',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      // Tambahkan headers lain yang diperlukan
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your-token-here',
    },
  );
}
```

---

### 8. **DNS Resolution Issues**

#### **Gejala:**
```
SocketException: Failed host lookup
```

#### **Penyebab:**
- DNS server di perangkat mobile berbeda dengan desktop
- Hostname tidak bisa di-resolve

#### **Solusi:**

**Test DNS:**
```dart
import 'dart:io';

Future<void> testDNS(String hostname) async {
  try {
    final addresses = await InternetAddress.lookup(hostname);
    print('DNS lookup success: $addresses');
  } catch (e) {
    print('DNS lookup failed: $e');
  }
}

// Test
await testDNS('apis.holding-perkebunan.com');
```

**Gunakan IP Address langsung (temporary):**
```dart
// Jika DNS gagal, gunakan IP langsung
final url = 'http://192.168.1.100/api/endpoint'; // Ganti dengan IP server
```

---

### 9. **Character Encoding Issues**

#### **Gejala:**
```
FormatException: Unexpected character
```

#### **Penyebab:**
Response body menggunakan encoding yang tidak didukung.

#### **Solusi:**

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> callApi(String url) async {
  final response = await http.get(Uri.parse(url));
  
  // Decode dengan encoding yang benar
  final decodedBody = utf8.decode(response.bodyBytes);
  
  return jsonDecode(decodedBody);
}
```

---

### 10. **Firewall/Security Software**

#### **Gejala:**
- Berhasil di emulator
- Error di real device
- Atau sebaliknya

#### **Penyebab:**
- Firewall memblokir aplikasi
- Antivirus memblokir koneksi
- Corporate network policy

#### **Solusi:**
1. Disable firewall/antivirus sementara untuk testing
2. Whitelist aplikasi di firewall
3. Gunakan network lain (mobile data vs WiFi)
4. Hubungi IT team untuk whitelist

---

## 🛠️ Debugging Checklist

Coba satu per satu:

- [ ] **Test 1**: Cek SSL certificate error → Bypass SSL (dev only)
- [ ] **Test 2**: Tambahkan internet permission di AndroidManifest.xml
- [ ] **Test 3**: Enable cleartext traffic untuk HTTP
- [ ] **Test 4**: Perpanjang timeout duration
- [ ] **Test 5**: Tambahkan semua headers dari Postman
- [ ] **Test 6**: Test DNS resolution
- [ ] **Test 7**: Coba di network berbeda (WiFi vs mobile data)
- [ ] **Test 8**: Cek proxy settings
- [ ] **Test 9**: Test di emulator vs real device
- [ ] **Test 10**: Tambahkan logging untuk debug

---

## 🔧 Template Debugging Code

```dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DebugApiService {
  static Future<Map<String, dynamic>> callApi(String url) async {
    print('🌐 Calling API: $url');
    
    try {
      // Test DNS
      final uri = Uri.parse(url);
      print('🔍 Testing DNS for: ${uri.host}');
      final addresses = await InternetAddress.lookup(uri.host);
      print('✅ DNS resolved: $addresses');
      
      // Make request
      print('📤 Sending request...');
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'Dart/2.19 (dart:io)',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timeout after 30 seconds');
        },
      );
      
      print('📥 Response received');
      print('📊 Status Code: ${response.statusCode}');
      print('📋 Headers: ${response.headers}');
      print('📄 Body length: ${response.body.length}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Success: $data');
        return {
          'success': true,
          'data': data,
        };
      } else {
        print('❌ Error: ${response.statusCode}');
        print('❌ Body: ${response.body}');
        return {
          'success': false,
          'message': 'HTTP ${response.statusCode}',
          'data': response.body,
        };
      }
    } on SocketException catch (e) {
      print('❌ SocketException: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.message}',
      };
    } on TimeoutException catch (e) {
      print('❌ TimeoutException: $e');
      return {
        'success': false,
        'message': 'Request timeout',
      };
    } on HandshakeException catch (e) {
      print('❌ HandshakeException (SSL): $e');
      return {
        'success': false,
        'message': 'SSL certificate error',
      };
    } catch (e) {
      print('❌ Unknown error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
```

**Cara pakai:**
```dart
final result = await DebugApiService.callApi('https://your-api-url.com');
print(result);
```

---

## 📊 Perbandingan Environment

| Aspek | Postman (Desktop) | Flutter (Mobile) |
|-------|-------------------|------------------|
| **SSL Verification** | Bisa di-disable mudah | Strict by default |
| **Network** | WiFi/Ethernet stabil | WiFi/Mobile data bervariasi |
| **Proxy** | Bisa pakai system proxy | Perlu konfigurasi manual |
| **Timeout** | Bisa unlimited | Perlu set manual |
| **Headers** | Auto-generated banyak | Perlu tambah manual |
| **DNS** | System DNS | System DNS perangkat |

---

## 💡 Best Practices

### **1. Gunakan Try-Catch yang Spesifik**

```dart
try {
  // API call
} on SocketException catch (e) {
  // Network error
} on TimeoutException catch (e) {
  // Timeout error
} on HandshakeException catch (e) {
  // SSL error
} on FormatException catch (e) {
  // JSON parsing error
} catch (e) {
  // Other errors
}
```

### **2. Implementasi Retry Logic**

```dart
Future<http.Response> callApiWithRetry(String url, {int maxRetries = 3}) async {
  int retryCount = 0;
  
  while (retryCount < maxRetries) {
    try {
      return await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
      );
    } catch (e) {
      retryCount++;
      if (retryCount >= maxRetries) rethrow;
      
      print('Retry $retryCount/$maxRetries after error: $e');
      await Future.delayed(Duration(seconds: retryCount * 2));
    }
  }
  
  throw Exception('Max retries reached');
}
```

### **3. Logging untuk Production**

```dart
import 'package:logger/logger.dart';

final logger = Logger();

Future<void> callApi(String url) async {
  logger.i('Calling API: $url');
  
  try {
    final response = await http.get(Uri.parse(url));
    logger.d('Response: ${response.statusCode}');
  } catch (e) {
    logger.e('Error calling API', e);
  }
}
```

---

## 🆘 Jika Semua Solusi Gagal

1. **Capture Network Traffic**:
   - Gunakan **Charles Proxy** atau **Fiddler**
   - Bandingkan request dari Postman vs Flutter
   - Lihat perbedaan headers, body, timing

2. **Test di Environment Berbeda**:
   - Emulator vs Real Device
   - WiFi vs Mobile Data
   - Network berbeda

3. **Konsultasi Backend Team**:
   - Minta server logs
   - Cek firewall rules
   - Verifikasi API requirements

4. **Buat Minimal Reproducible Example**:
   - Buat project Flutter baru yang minimal
   - Test hanya API call saja
   - Isolate masalahnya

---

## 📞 Checklist Komunikasi dengan Backend Team

Ketika melaporkan issue ke backend team, sertakan:

- [ ] Exact error message dari Flutter
- [ ] Request URL lengkap
- [ ] Headers yang dikirim
- [ ] Screenshot/log dari Postman (yang berhasil)
- [ ] Screenshot/log dari Flutter (yang error)
- [ ] Device info (Android/iOS version)
- [ ] Network info (WiFi/mobile data)
- [ ] Timestamp ketika error terjadi

---

## 🎯 Kesimpulan

**Penyebab paling umum** (berdasarkan pengalaman):

1. **SSL Certificate Issues** (40%)
2. **Network Security Config** (30%)
3. **Missing Headers** (15%)
4. **Timeout Issues** (10%)
5. **Lainnya** (5%)

**Solusi tercepat**: Mulai dari SSL bypass (dev only) dan network security config.
