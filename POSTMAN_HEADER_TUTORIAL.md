# Cara Menambahkan User-Agent Header di Postman

## 📋 Langkah-Langkah Detail

### **Langkah 1: Buka Postman dan Buat Request Baru**

1. Buka aplikasi **Postman**
2. Klik tombol **"New"** atau **"+"** untuk membuat request baru
3. Pilih method **GET**

---

### **Langkah 2: Masukkan URL API**

Copy-paste URL berikut ke address bar:

```
https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-out-v2?user-access=AGHRIS_MOBILE&key=270F672B-3CEF-4C6C-A362-359B8B0CAEA1&nik-sap-target=8006045&tanggal=2026-01-19&check-out-time=17:45&checkout-long=106.833859&checkout-lat=-6.229090&user=8006045&mood=SENANG
```

---

### **Langkah 3: Klik Tab "Headers"** ⭐

Di bawah URL bar, Anda akan melihat beberapa tab:
- Params
- Authorization
- **Headers** ← Klik tab ini
- Body
- Pre-request Script
- Tests
- Settings

**Klik tab "Headers"**

---

### **Langkah 4: Tambahkan Header Baru**

Di bagian Headers, Anda akan melihat tabel dengan kolom:
- **KEY** (kolom kiri)
- **VALUE** (kolom tengah)
- **DESCRIPTION** (kolom kanan)

**Isi baris pertama:**

1. **Kolom KEY**: Ketik `User-Agent`
2. **Kolom VALUE**: Ketik `Dart/2.19 (dart:io)`
3. **Centang checkbox** di sebelah kiri (pastikan header aktif)

---

### **Langkah 5: Kirim Request**

Klik tombol biru **"Send"** di kanan atas.

---

## 🎯 Tampilan Akhir di Postman

Setelah selesai, tab Headers Anda akan terlihat seperti ini:

```
Headers (1)
┌─────────────┬──────────────────────┬─────────────┐
│ ☑ KEY       │ VALUE                │ DESCRIPTION │
├─────────────┼──────────────────────┼─────────────┤
│ ☑ User-Agent│ Dart/2.19 (dart:io)  │             │
└─────────────┴──────────────────────┴─────────────┘
```

---

## 📸 Screenshot Tutorial

Lihat gambar tutorial yang sudah saya buat di atas untuk panduan visual.

**Nomor di gambar menunjukkan urutan:**
1. ① Klik tab **Headers**
2. ② Isi **User-Agent** dan **Dart/2.19 (dart:io)**
3. ③ Klik tombol **Send**

---

## ✅ Verifikasi

Setelah menambahkan header dan klik Send, Anda seharusnya mendapat:

### **Response Berhasil (200 OK)**
```json
{
  "success": true,
  "message": "Check-out berhasil",
  "data": { ... }
}
```

### **Jika Masih Error 403**

Coba User-Agent alternatif:

**Opsi 2:**
```
KEY: User-Agent
VALUE: Flutter/3.0
```

**Opsi 3:**
```
KEY: User-Agent
VALUE: Dart/3.0 (dart:io)
```

---

## 🔧 Tips Tambahan

### **Menyimpan Header untuk Request Berikutnya**

1. Setelah menambahkan header, klik **"Save"** di kanan atas
2. Beri nama request, misalnya: "AGHRIS Check-Out API"
3. Pilih atau buat Collection baru
4. Klik **"Save"**

Sekarang header akan tersimpan dan tidak perlu diketik ulang!

---

### **Menggunakan Environment Variable (Advanced)**

Untuk lebih efisien, Anda bisa membuat environment variable:

1. Klik icon ⚙️ (gear) di kanan atas
2. Pilih **"Manage Environments"**
3. Klik **"Add"**
4. Buat variable:
   - **Variable**: `user_agent`
   - **Initial Value**: `Dart/2.19 (dart:io)`
   - **Current Value**: `Dart/2.19 (dart:io)`
5. Klik **"Add"** lalu **"Close"**

Kemudian di Headers, gunakan:
```
KEY: User-Agent
VALUE: {{user_agent}}
```

---

## 📝 Checklist

Pastikan Anda sudah:

- [ ] Membuka Postman
- [ ] Membuat request baru dengan method GET
- [ ] Memasukkan URL lengkap dengan query parameters
- [ ] Klik tab **Headers**
- [ ] Menambahkan header `User-Agent` dengan value `Dart/2.19 (dart:io)`
- [ ] Centang checkbox untuk mengaktifkan header
- [ ] Klik tombol **Send**
- [ ] Mendapat response 200 OK

---

## ❓ Troubleshooting

### **Q: Masih dapat error 403 setelah menambahkan User-Agent**
**A:** Coba:
1. Periksa apakah checkbox header sudah dicentang (aktif)
2. Pastikan tidak ada spasi ekstra di KEY atau VALUE
3. Coba User-Agent alternatif: `Flutter/3.0`
4. Kemungkinan ada IP whitelisting - hubungi backend team

### **Q: Tidak menemukan tab Headers**
**A:** Tab Headers ada di bawah URL bar, sejajar dengan tab Params, Authorization, dll.

### **Q: Header hilang setelah restart Postman**
**A:** Klik **Save** untuk menyimpan request ke Collection.

---

## 🎓 Video Tutorial (Alternatif)

Jika masih bingung, Anda bisa:
1. Search di YouTube: "How to add headers in Postman"
2. Atau lihat dokumentasi resmi: https://learning.postman.com/docs/sending-requests/requests/#configuring-request-headers

---

## 📞 Butuh Bantuan?

Jika masih mengalami kesulitan, screenshot tampilan Postman Anda dan tanyakan lagi!
