# Flutter Absensi - Quick Start Guide

## 🚀 Instalasi

1. **Clone atau buka project**
   ```bash
   cd c:\flutterku\flutter_absensi
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run aplikasi**
   ```bash
   flutter run
   ```

## 📱 Fitur Utama

### ✅ Check-In (Absensi Masuk)
- Catat waktu masuk kerja
- Pilih jenis absen: WFO, WFH, Izin, Dinas
- Tentukan shift kerja
- Rekam lokasi dengan GPS atau peta
- Pilih mood hari ini

### ✅ Check-Out (Absensi Pulang)
- Catat waktu pulang kerja
- Rekam lokasi dengan GPS atau peta
- Pilih mood hari ini

### 🗺️ Leaflet Map Integration
- **OpenStreetMap** - Gratis, tanpa API key
- Tap untuk pilih lokasi
- Search lokasi by address
- Auto GPS location
- Geocoding (koordinat → alamat)

## 🎨 UI/UX Features

- ✨ **Modern Design** - Gradient backgrounds, glassmorphism
- 🎭 **Smooth Animations** - Fade, slide, bounce effects
- 📱 **Responsive** - Adaptive untuk berbagai ukuran layar
- 🎯 **Intuitive** - User-friendly interface
- 🌈 **Color Coded** - Blue untuk check-in, Red untuk check-out

## 🔧 Teknologi

- **Flutter** - Cross-platform framework
- **flutter_map** - Leaflet maps untuk Flutter
- **geolocator** - GPS location services
- **geocoding** - Reverse geocoding
- **http** - REST API calls
- **intl** - Date/time formatting

## 📋 Flow Aplikasi

```
Login Page
    ↓
Home Page (Menu)
    ├── Check-In Page → Map Picker → Submit
    └── Check-Out Page → Map Picker → Submit
```

## 🔐 API Configuration

API sudah dikonfigurasi di `lib/services/absen_service.dart`:

- **Base URL**: `https://apis.holding-perkebunan.com/aghris/`
- **User Access**: `AGHRIS_MOBILE`
- **API Key**: `270F672B-3CEF-4C6C-A362-359B8B0CAEA1`

## 📝 Catatan Penting

1. **NIK** dari login akan otomatis digunakan untuk `nik-sap-target` dan `user`
2. **Format Tanggal**: YYYY-MM-DD (contoh: 2025-08-26)
3. **Format Jam**: HH:mm (contoh: 21:45)
4. **Koordinat**: 6 digit desimal (contoh: -7.323278)
5. **Internet Required**: Untuk API calls dan map tiles

## 🐛 Troubleshooting

### GPS tidak berfungsi?
- Pastikan location permission sudah granted
- Aktifkan GPS di device settings
- Restart aplikasi

### Map tidak muncul?
- Cek koneksi internet
- OpenStreetMap memerlukan internet untuk load tiles

### API error?
- Cek koneksi internet
- Pastikan NIK valid
- Cek format parameter (tanggal, jam)

## 📞 Support

Jika ada masalah, cek:
1. Console log untuk error details
2. Network tab untuk API response
3. Device permissions untuk GPS

---

**Happy Coding! 🎉**
