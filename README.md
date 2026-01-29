# Flutter Absensi - Dokumentasi

## Fitur Aplikasi

### 1. **Halaman Login**
- Input NIK dan Password
- Validasi login melalui API
- Animasi smooth transition
- UI modern dengan gradient background

### 2. **Halaman Home**
- Menu utama dengan 2 pilihan:
  - **Check-In**: Untuk absensi masuk
  - **Check-Out**: Untuk absensi pulang
- Menampilkan NIK user yang login
- Animasi slide untuk menu cards

### 3. **Halaman Check-In**
- Form absensi masuk dengan field:
  - NIK (otomatis dari login)
  - Tanggal (date picker)
  - Jam (time picker)
  - Latitude & Longitude (GPS/Map)
  - Shift
  - Jenis Absen (WFO/WFH/Izin/Dinas)
  - Mood (Senang/Bahagia/Galau/Marah)
- Integrasi dengan Leaflet Map untuk pilih lokasi
- GPS auto-detect location
- API: `pb-03-5-2-check-in-v2`

### 4. **Halaman Check-Out**
- Form absensi pulang dengan field:
  - NIK (otomatis dari login)
  - Tanggal (date picker)
  - Jam (time picker)
  - Latitude & Longitude (GPS/Map)
  - Mood (Senang/Bahagia/Galau/Marah)
- Integrasi dengan Leaflet Map untuk pilih lokasi
- GPS auto-detect location
- API: `pb-03-5-2-check-out-v2`

### 5. **Leaflet Map Picker**
- OpenStreetMap (gratis)
- Search lokasi
- Tap untuk pilih lokasi
- GPS current location
- Geocoding (alamat dari koordinat)
- UI modern dengan animasi

## API Endpoints

### Check-In API
```
GET https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-in-v2
```

**Parameters:**
- `user-access`: AGHRIS_MOBILE
- `key`: 270F672B-3CEF-4C6C-A362-359B8B0CAEA1
- `nik-sap-target`: NIK user
- `jenis-absen`: N/H/I/D (WFO/WFH/Izin/Dinas)
- `shift`: Shift number
- `tanggal`: YYYY-MM-DD
- `check-in-time`: HH:mm
- `checkin-long`: Longitude
- `checkin-lat`: Latitude
- `user`: NIK user
- `mood`: SENANG/BAHAGIA/GALAU/MARAH

### Check-Out API
```
GET https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-out-v2
```

**Parameters:**
- `user-access`: AGHRIS_MOBILE
- `key`: 270F672B-3CEF-4C6C-A362-359B8B0CAEA1
- `nik-sap-target`: NIK user
- `tanggal`: YYYY-MM-DD
- `check-out-time`: HH:mm
- `checkout-long`: Longitude
- `checkout-lat`: Latitude
- `user`: NIK user
- `mood`: SENANG/BAHAGIA/GALAU/MARAH

## Struktur File

```
lib/
├── main.dart
├── pages/
│   ├── login_page.dart         # Halaman login
│   ├── home_page.dart          # Menu utama (Check-In/Check-Out)
│   ├── absen_page.dart         # Form check-in
│   ├── checkout_page.dart      # Form check-out
│   └── leaflet_map_picker_page.dart  # Map picker
└── services/
    ├── auth_service.dart       # Service untuk login
    └── absen_service.dart      # Service untuk check-in & check-out
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  geolocator: ^11.0.0
  intl: ^0.19.0
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  jwt_decoder: ^2.0.1
  dio: ^5.3.1
  google_maps_flutter: ^2.5.0
  geocoding: ^3.0.0
  flutter_map: ^7.0.2        # Leaflet untuk Flutter
  latlong2: ^0.9.1           # Koordinat untuk flutter_map
  cupertino_icons: ^1.0.8
```

## Cara Menggunakan

### 1. Login
- Masukkan NIK dan Password
- Klik tombol LOGIN
- Jika berhasil, akan diarahkan ke halaman Home

### 2. Check-In
- Di halaman Home, pilih menu "Check-In"
- Isi semua field yang diperlukan
- Pilih lokasi dengan GPS atau Map
- Pilih jenis absen dan mood
- Klik "SUBMIT ABSEN"

### 3. Check-Out
- Di halaman Home, pilih menu "Check-Out"
- Isi semua field yang diperlukan
- Pilih lokasi dengan GPS atau Map
- Pilih mood
- Klik "SUBMIT CHECK-OUT"

### 4. Pilih Lokasi dari Map
- Klik tombol "Peta" di form
- Akan terbuka halaman map
- Tap di peta untuk pilih lokasi
- Atau gunakan search untuk cari lokasi
- Atau klik tombol GPS untuk lokasi saat ini
- Klik "Konfirmasi Lokasi"

## Fitur UI/UX

### Design System
- **Color Palette**:
  - Check-In: Blue gradient (#1E3A8A → #3B82F6 → #06B6D4)
  - Check-Out: Red gradient (#7F1D1D → #E53935 → #EF5350)
  - Success: Green (#10B981)
  - Error: Red (#E53935)

- **Typography**:
  - Headers: Bold, 20-32px
  - Body: Regular, 14-16px
  - Labels: Semi-bold, 14px

- **Components**:
  - Rounded corners (12-24px)
  - Glassmorphism effects
  - Smooth animations
  - Floating snackbars
  - Gradient buttons with shadows

### Animations
- Fade in/out transitions
- Slide animations
- Bounce physics for scrolling
- Loading indicators

## Permissions Required

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS (ios/Runner/Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi memerlukan akses lokasi untuk absensi</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Aplikasi memerlukan akses lokasi untuk absensi</string>
```

## Testing

### Test Check-In
1. Login dengan NIK valid
2. Pilih menu Check-In
3. Pastikan GPS aktif
4. Pilih jenis absen dan mood
5. Submit dan cek response

### Test Check-Out
1. Login dengan NIK valid
2. Pilih menu Check-Out
3. Pastikan GPS aktif
4. Pilih mood
5. Submit dan cek response

### Test Map Picker
1. Klik tombol "Peta"
2. Test tap di map
3. Test search lokasi
4. Test GPS button
5. Test konfirmasi lokasi

## Troubleshooting

### GPS tidak berfungsi
- Pastikan permission location sudah granted
- Aktifkan GPS di device
- Cek koneksi internet untuk geocoding

### Map tidak muncul
- Cek koneksi internet
- OpenStreetMap tiles memerlukan internet
- Pastikan flutter_map sudah terinstall

### API error
- Cek koneksi internet
- Pastikan parameter API sudah benar
- Cek NIK valid
- Cek format tanggal dan jam

## Notes

- NIK-SAP-TARGET dan USER menggunakan NIK yang sama dari login
- Tanggal format: YYYY-MM-DD (contoh: 2025-08-26)
- Jam format: HH:mm (contoh: 21:45)
- Koordinat menggunakan 6 digit desimal
- OpenStreetMap gratis dan tidak perlu API key
