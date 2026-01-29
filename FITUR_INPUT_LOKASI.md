# Fitur Input Lokasi - Flutter Absensi

## 📍 Tiga Cara Mengisi Koordinat Lokasi

Aplikasi absensi sekarang mendukung **3 metode** untuk mengisi koordinat latitude dan longitude:

---

### 1️⃣ **Otomatis (GPS)**
- **Cara:** Klik tombol **"GPS"** (biru)
- **Fungsi:** Otomatis membaca lokasi GPS saat ini dari perangkat
- **Kegunaan:** Cepat dan akurat untuk lokasi saat ini
- **Icon:** 📍 My Location

```
Tombol: [GPS] (Biru)
Aksi: Mendapatkan koordinat dari GPS perangkat
```

---

### 2️⃣ **Manual Input**
- **Cara:** Ketik langsung di field **Latitude** dan **Longitude**
- **Fungsi:** Input koordinat secara manual dengan keyboard
- **Kegunaan:** Untuk lokasi spesifik yang sudah diketahui koordinatnya
- **Format:** 
  - Latitude: -6.200000 (contoh)
  - Longitude: 106.816666 (contoh)

```
Field Input:
┌─────────────────────────┐
│ Latitude: -6.200000     │
└─────────────────────────┘
┌─────────────────────────┐
│ Longitude: 106.816666   │
└─────────────────────────┘
```

---

### 3️⃣ **Pilih dari Peta** ⭐ BARU!
- **Cara:** Klik tombol **"Peta"** (orange)
- **Fungsi:** Membuka halaman peta interaktif
- **Fitur:**
  - 🔍 **Pencarian Lokasi** - Cari tempat dengan nama
  - 🗺️ **Klik pada Peta** - Pilih lokasi dengan tap
  - 📌 **Drag Marker** - Geser marker untuk penyesuaian
  - ✅ **Konfirmasi** - Simpan koordinat yang dipilih

```
Tombol: [Peta] (Orange)
Aksi: Buka halaman Map Picker
      ↓
┌─────────────────────────────────┐
│  🔍 [Cari lokasi...]            │
├─────────────────────────────────┤
│                                 │
│         🗺️ GOOGLE MAPS          │
│                                 │
│            📍 Marker            │
│         (dapat di-drag)         │
│                                 │
├─────────────────────────────────┤
│ 📍 Lokasi Terpilih              │
│ Jl. Sudirman, Jakarta           │
│ Lat: -6.200000, Lng: 106.816666 │
│                                 │
│ [✅ Konfirmasi Lokasi]          │
└─────────────────────────────────┘
```

---

## 🎯 Kapan Menggunakan Metode Mana?

| Metode | Situasi | Kelebihan |
|--------|---------|-----------|
| **GPS** | Absen di lokasi saat ini | ⚡ Cepat, akurat, otomatis |
| **Manual** | Koordinat sudah diketahui | ✏️ Presisi, tidak perlu GPS |
| **Peta** | Pilih lokasi tertentu | 🎯 Visual, mudah, fleksibel |

---

## 🚀 Cara Penggunaan

### Menggunakan GPS:
1. Buka halaman absensi
2. Klik tombol **"GPS"**
3. Koordinat otomatis terisi
4. Klik **"ABSEN"**

### Menggunakan Manual Input:
1. Buka halaman absensi
2. Ketik koordinat di field **Latitude**
3. Ketik koordinat di field **Longitude**
4. Klik **"ABSEN"**

### Menggunakan Peta:
1. Buka halaman absensi
2. Klik tombol **"Peta"**
3. Di halaman peta:
   - **Opsi A:** Ketik nama tempat di search bar, tekan Enter
   - **Opsi B:** Klik langsung pada peta
   - **Opsi C:** Drag marker merah ke posisi yang diinginkan
4. Klik **"Konfirmasi Lokasi"**
5. Kembali ke halaman absensi (koordinat sudah terisi)
6. Klik **"ABSEN"**

---

## 📋 Layout Tombol

```
┌─────────────────────────────────────┐
│  [GPS] 📍      [Peta] 🗺️            │
│  (Biru)        (Orange)             │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│      [✅ ABSEN]                      │
│      (Hijau)                        │
└─────────────────────────────────────┘
```

---

## ⚙️ Setup Diperlukan

Untuk menggunakan fitur **Pilih dari Peta**, Anda perlu:
1. Google Maps API Key
2. Aktifkan Maps SDK for Android
3. Aktifkan Geocoding API

📖 Lihat file `GOOGLE_MAPS_SETUP.md` untuk panduan lengkap.

---

## 🎨 Screenshot Fitur

### Halaman Absensi
- Tombol GPS (Biru) - Kiri
- Tombol Peta (Orange) - Kanan
- Tombol Absen (Hijau) - Bawah

### Halaman Map Picker
- Search bar di atas
- Google Maps di tengah
- Marker merah yang bisa di-drag
- Info card di bawah dengan tombol konfirmasi

---

## 🔧 Technical Details

### Dependencies:
- `google_maps_flutter: ^2.5.0` - Menampilkan peta
- `geocoding: ^3.0.0` - Konversi alamat ↔ koordinat
- `geolocator: ^11.0.0` - Mendapatkan lokasi GPS

### Files Modified/Created:
- ✅ `lib/pages/map_picker_page.dart` - Halaman peta baru
- ✅ `lib/pages/absen_page.dart` - Tambah tombol & method
- ✅ `pubspec.yaml` - Tambah dependencies
- ✅ `android/app/src/main/AndroidManifest.xml` - API key config

---

**Selamat menggunakan! 🎉**
