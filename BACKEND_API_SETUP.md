## Backend Laravel API Requirements

Aplikasi Flutter ini membutuhkan 2 endpoint API:

### 1. Login Endpoint (untuk mendapatkan JWT Token)

**URL:** `POST /api/login`

**Request Body:**
```json
{
  "nik": "string",
  "password": "string"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login berhasil",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "nik": "123456",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

**Failed Response (401/422):**
```json
{
  "success": false,
  "message": "Kredensial tidak sesuai"
}
```

**Implementation Guide:**
1. Generate JWT token dengan package `tymondesigns/jwt-auth` atau `firebase/php-jwt`
2. Token harus contain claim `nik` untuk digunakan di frontend
3. Set token expiration (misal: 7 hari)
4. Response harus berisi `success`, `message`, `token`, dan `user` fields

---

### 2. Absensi Endpoint (Existing - no change needed)

Endpoint untuk check-in tetap berjalan seperti sebelumnya:
- URL: `https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-in-v2`
- Menggunakan API key statis yang sudah ada
- Flutter app akan tetap menggunakan key yang hardcoded

---

## Flutter Configuration

Di file `lib/services/auth_service.dart`, ganti:
```dart
static const String baseUrl = 'YOUR_LARAVEL_API_URL'; 
```

Dengan URL backend Laravel Anda, misal:
```dart
static const String baseUrl = 'https://api.yourdomain.com';
```

---

## JWT Token Storage & Usage

- **Disimpan di:** Flutter Secure Storage
- **Key name:** `jwt_token`
- **Digunakan untuk:** Verifikasi login (future feature)
- **Untuk Absensi:** Tidak digunakan, tetap pakai API key statis

---

## Laravel Setup Example (Optional)

Jika menggunakan `tymondesigns/jwt-auth`:

```php
// routes/api.php
Route::post('/login', [AuthController::class, 'login']);

// AuthController.php
public function login(Request $request)
{
    $validated = $request->validate([
        'nik' => 'required|string',
        'password' => 'required|string',
    ]);

    $user = User::where('nik', $validated['nik'])->first();

    if (!$user || !Hash::check($validated['password'], $user->password)) {
        return response()->json([
            'success' => false,
            'message' => 'Kredensial tidak sesuai'
        ], 401);
    }

    $token = auth('api')->login($user);

    return response()->json([
        'success' => true,
        'message' => 'Login berhasil',
        'token' => $token,
        'user' => [
            'nik' => $user->nik,
            'name' => $user->name,
            'email' => $user->email,
        ]
    ]);
}
```
