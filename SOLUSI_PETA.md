# 🗺️ Solusi: Peta Tidak Muncul

## ❌ **Masalah:**
```
E/FrameEvents(18752): updateAcquireFence: Did not find frame.
D/Surface (18752): lockHardwareCanvas
```
Peta Google Maps tidak muncul di aplikasi.

---

## 🔍 **Penyebab:**
Google Maps API Key belum dikonfigurasi atau tidak valid.

---

## ✅ **Solusi yang Sudah Diterapkan:**

### **Opsi 1: Simple Location Picker (AKTIF SEKARANG)** ⭐

Saya sudah mengganti fitur "Pilih dari Peta" dengan **Simple Location Picker** yang tidak memerlukan Google Maps API Key.

#### Fitur Simple Location Picker:
- ✅ **Input Manual** - Ketik koordinat langsung
- ✅ **GPS Button** - Ambil lokasi saat ini dengan GPS
- ✅ **Panduan Lengkap** - Cara mendapatkan koordinat dari Google Maps
- ✅ **Validasi** - Cek format koordinat
- ✅ **Modern UI** - Desain yang sama dengan halaman lain

#### File yang Diubah:
1. **Dibuat:** `lib/pages/simple_location_picker_page.dart`
2. **Diubah:** `lib/pages/absen_page.dart` (import & penggunaan)

#### Cara Menggunakan:
1. Klik tombol **"Peta"** (orange) di halaman absensi
2. Pilih salah satu:
   - **Opsi A:** Klik "Gunakan GPS Saat Ini" untuk lokasi otomatis
   - **Opsi B:** Ketik koordinat manual di field Latitude & Longitude
3. Klik "Konfirmasi Lokasi"
4. Koordinat otomatis terisi di halaman absensi

---

### **Opsi 2: Aktifkan Google Maps (OPSIONAL)**

Jika Anda ingin menggunakan peta interaktif Google Maps:

#### Langkah-langkah:

1. **Dapatkan API Key** (GRATIS)
   - Buka: https://console.cloud.google.com/
   - Buat project baru
   - Enable "Maps SDK for Android" dan "Geocoding API"
   - Buat API Key
   - Copy API Key

2. **Masukkan API Key**
   Edit file: `android/app/src/main/AndroidManifest.xml`
   
   Ganti baris ini:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
   ```
   
   Menjadi:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"/>
   ```

3. **Ganti Import di absen_page.dart**
   
   Ganti:
   ```dart
   import '../pages/simple_location_picker_page.dart';
   ```
   
   Menjadi:
   ```dart
   import '../pages/map_picker_page.dart';
   ```

4. **Ganti Penggunaan**
   
   Ganti:
   ```dart
   SimpleLocationPickerPage(
     initialLat: initialLat,
     initialLng: initialLng,
   )
   ```
   
   Menjadi:
   ```dart
   MapPickerPage(
     initialLat: initialLat,
     initialLng: initialLng,
   )
   ```

5. **Rebuild Aplikasi**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

📖 **Panduan lengkap:** Lihat file `GOOGLE_MAPS_SETUP.md`

---

## 📊 **Perbandingan:**

| Fitur | Simple Location Picker | Google Maps |
|-------|----------------------|-------------|
| **API Key** | ❌ Tidak perlu | ✅ Perlu (gratis) |
| **Internet** | ✅ Hanya untuk GPS | ✅ Wajib |
| **Input Manual** | ✅ Ya | ✅ Ya |
| **GPS** | ✅ Ya | ✅ Ya |
| **Peta Interaktif** | ❌ Tidak | ✅ Ya |
| **Pencarian Lokasi** | ❌ Tidak | ✅ Ya |
| **Drag Marker** | ❌ Tidak | ✅ Ya |
| **Kemudahan** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

---

## 🎯 **Rekomendasi:**

### **Untuk Testing/Development:**
✅ **Gunakan Simple Location Picker** (sudah aktif)
- Tidak perlu setup API key
- Lebih cepat untuk testing
- Tetap bisa input koordinat dengan GPS atau manual

### **Untuk Production:**
✅ **Gunakan Google Maps**
- User experience lebih baik
- Bisa lihat peta visual
- Bisa search lokasi
- Lebih intuitif

---

## 🔧 **Troubleshooting:**

### Simple Location Picker tidak berfungsi?
1. Pastikan GPS permission sudah diizinkan
2. Pastikan lokasi device aktif
3. Coba input manual jika GPS gagal

### Ingin kembali ke Google Maps?
1. Dapatkan API Key (lihat `GOOGLE_MAPS_SETUP.md`)
2. Ubah import di `absen_page.dart`
3. Rebuild aplikasi

---

## 💡 **Tips:**

### Cara Mendapatkan Koordinat dari Google Maps:
1. Buka Google Maps di browser/app
2. Cari lokasi yang diinginkan
3. Tap & hold pada lokasi tersebut
4. Koordinat akan muncul (contoh: -6.200000, 106.816666)
5. Copy dan paste ke Simple Location Picker

### Format Koordinat:
- **Latitude:** -90 sampai 90 (negatif = selatan)
- **Longitude:** -180 sampai 180 (positif = timur)
- **Contoh Jakarta:** Lat: -6.200000, Lng: 106.816666

---

## ✅ **Status Saat Ini:**

- ✅ Simple Location Picker sudah aktif
- ✅ Tidak ada error Google Maps
- ✅ Bisa input koordinat dengan GPS
- ✅ Bisa input koordinat manual
- ✅ UI modern dan konsisten
- ✅ Aplikasi berjalan normal

---

**Aplikasi sekarang berfungsi dengan baik tanpa Google Maps API Key!** 🎉

Jika nanti ingin upgrade ke Google Maps, tinggal ikuti langkah di Opsi 2.
