# 🗺️ Cara Mendapatkan Google Maps API Key

## Langkah-langkah Lengkap:

### 1. Buka Google Cloud Console
- Kunjungi: https://console.cloud.google.com/
- Login dengan akun Google Anda

### 2. Buat Project Baru (atau pilih yang sudah ada)
- Klik dropdown project di pojok kiri atas
- Klik "New Project"
- Beri nama: "Flutter Absensi" (atau nama lain)
- Klik "Create"

### 3. Aktifkan Maps SDK for Android
- Di menu sebelah kiri, pilih "APIs & Services" > "Library"
- Cari "Maps SDK for Android"
- Klik dan tekan "ENABLE"

### 4. Aktifkan Geocoding API
- Masih di "Library"
- Cari "Geocoding API"
- Klik dan tekan "ENABLE"

### 5. Buat API Key
- Di menu sebelah kiri, pilih "APIs & Services" > "Credentials"
- Klik "CREATE CREDENTIALS" > "API Key"
- API Key akan dibuat (contoh: AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
- **COPY API KEY INI!**

### 6. (Opsional) Batasi API Key untuk Keamanan
- Klik API Key yang baru dibuat
- Di "Application restrictions":
  - Pilih "Android apps"
  - Klik "Add an item"
  - Package name: `com.example.flutter_absensi`
  - SHA-1: (dapatkan dengan cara di bawah)
- Di "API restrictions":
  - Pilih "Restrict key"
  - Centang: "Maps SDK for Android" dan "Geocoding API"
- Klik "Save"

### 7. Dapatkan SHA-1 Certificate Fingerprint (untuk pembatasan)
Buka terminal di folder project dan jalankan:

**Windows:**
```bash
cd android
./gradlew signingReport
```

**Mac/Linux:**
```bash
cd android
./gradlew signingReport
```

Cari baris yang berisi `SHA1:` di bagian `Task :app:signingReport`

### 8. Masukkan API Key ke Aplikasi
Edit file: `android/app/src/main/AndroidManifest.xml`

Ganti baris ini:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
```

Menjadi (ganti dengan API Key Anda):
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"/>
```

### 9. Rebuild Aplikasi
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🆓 **Biaya Google Maps API**

Google memberikan **$200 kredit gratis per bulan** untuk semua pengguna.

Untuk aplikasi kecil/testing, ini sudah lebih dari cukup!

**Estimasi penggunaan:**
- Maps SDK for Android: $7 per 1,000 loads
- Geocoding API: $5 per 1,000 requests
- Dengan $200 kredit = ~28,000 map loads gratis per bulan

---

## ⚠️ **Troubleshooting**

### Peta masih tidak muncul?

1. **Pastikan API Key sudah benar**
   - Tidak ada spasi di awal/akhir
   - Copy paste dengan benar

2. **Pastikan API sudah diaktifkan**
   - Maps SDK for Android ✓
   - Geocoding API ✓

3. **Rebuild aplikasi**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

4. **Cek log error**
   - Buka Logcat di Android Studio
   - Filter: "Google Maps"
   - Lihat error message

5. **Pastikan internet tersedia**
   - Google Maps butuh koneksi internet

6. **Cek permission**
   - Location permission sudah diizinkan?

---

## 📝 **Catatan Penting**

- **JANGAN** commit API Key ke Git/GitHub (gunakan .gitignore)
- **BATASI** API Key untuk keamanan (restrict by package name & SHA-1)
- **MONITOR** penggunaan di Google Cloud Console
- **AKTIFKAN** billing alert untuk menghindari tagihan tak terduga

---

## 🎯 **Quick Start (5 Menit)**

1. Buka: https://console.cloud.google.com/
2. Buat project baru
3. Enable "Maps SDK for Android" dan "Geocoding API"
4. Buat API Key
5. Copy API Key
6. Paste ke AndroidManifest.xml
7. `flutter clean && flutter run`
8. ✅ Peta muncul!

---

**Selamat mencoba! 🗺️**
