# Fitur Hapus Absensi - Dokumentasi

## Ringkasan
Telah ditambahkan fitur baru untuk menghapus data absensi dengan menggunakan API endpoint yang telah ditentukan.

## File yang Dibuat/Dimodifikasi

### 1. **lib/services/absen_service.dart** (Dimodifikasi)
- Ditambahkan method `deleteAbsen()` yang memanggil API endpoint `https://amanah.ptpn1.co.id/api/del_api_log`
- Method ini mengirim POST request dengan body:
  - `tanggal`: Tanggal absensi yang akan dihapus (format: yyyy-MM-dd)
  - `nik_sap`: NIK karyawan yang diambil dari NIK login

### 2. **lib/pages/delete_absen_page.dart** (Baru)
Halaman baru untuk menghapus absensi dengan fitur:
- **Date Picker**: Pengguna dapat memilih tanggal absensi yang ingin dihapus
- **Auto-fill NIK**: NIK otomatis terisi dari data login
- **Konfirmasi Dialog**: Dialog konfirmasi sebelum menghapus data untuk mencegah penghapusan tidak sengaja
- **Warning Message**: Peringatan bahwa data yang dihapus tidak dapat dikembalikan
- **Loading State**: Indikator loading saat proses penghapusan berlangsung
- **Success/Error Feedback**: Notifikasi sukses atau error setelah proses selesai

### 3. **lib/pages/home_page.dart** (Dimodifikasi)
- Ditambahkan import untuk `delete_absen_page.dart`
- Ditambahkan menu card ketiga "Hapus Absensi" dengan:
  - Icon: `delete_forever`
  - Gradient: Orange (Color(0xFFF59E0B) → Color(0xFFD97706))
  - Animasi slide dari bawah

## Cara Penggunaan

1. **Login** ke aplikasi dengan NIK dan password
2. Di **Home Page**, pilih menu **"Hapus Absensi"**
3. Di halaman Hapus Absensi:
   - NIK sudah otomatis terisi dari login
   - Pilih **tanggal** absensi yang ingin dihapus menggunakan date picker
   - Klik tombol **"HAPUS ABSENSI"**
4. **Konfirmasi** penghapusan di dialog yang muncul
5. Tunggu proses penghapusan selesai
6. Notifikasi sukses/error akan ditampilkan

## Desain UI

Halaman Hapus Absensi menggunakan:
- **Gradient Background**: Merah-Orange (Color(0xFF7C2D12) → Color(0xFFE53935) → Color(0xFFF59E0B))
- **Warning Colors**: Menggunakan warna merah dan orange untuk menunjukkan tindakan berbahaya
- **Confirmation Dialog**: Dialog konfirmasi dengan detail data yang akan dihapus
- **Consistent Design**: Mengikuti pola desain yang sama dengan halaman Check-In dan Check-Out

## API Endpoint

**URL**: `https://amanah.ptpn1.co.id/api/del_api_log`

**Method**: POST

**Body Parameters**:
```
tanggal: yyyy-MM-dd (contoh: 2026-01-28)
nik_sap: NIK karyawan
```

**Response Handling**:
- Status 200: Berhasil menghapus
- Status lainnya: Gagal menghapus
- Timeout: 30 detik

## Keamanan

1. **Confirmation Dialog**: Mencegah penghapusan tidak sengaja
2. **Warning Message**: Mengingatkan pengguna bahwa data tidak dapat dikembalikan
3. **NIK Validation**: NIK diambil dari session login, tidak dapat diubah manual
4. **Date Validation**: Hanya dapat memilih tanggal dari masa lalu hingga hari ini

## Testing

Untuk menguji fitur ini:
1. Pastikan API endpoint dapat diakses
2. Login dengan NIK yang valid
3. Pilih tanggal yang memiliki data absensi
4. Lakukan penghapusan dan verifikasi hasilnya
