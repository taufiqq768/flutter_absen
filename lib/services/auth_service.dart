import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';

class AuthService {
  static const String baseUrl = 'http://hcis.holding-perkebunan.com';
  static const String loginEndpoint = '/api/generate_token_api';
  
  static const storage = FlutterSecureStorage();
  final Dio _dio = Dio();

  /// Login dengan NIK dan password
  /// Return: {success: bool, message: String, token: String?}
  Future<Map<String, dynamic>> login({
    required String nik,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl$loginEndpoint',
        data: {
          'username': nik,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timeout');
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        
        // Debug: print response structure
        print('Response data: $data');
        
        // Check if response contains token (regardless of success field)
        // Backend might return token in different field names
        final token = data['token'] ?? data['access_token'] ?? data['jwt'];
        
        if (token != null && token.toString().isNotEmpty) {
          final tokenStr = token.toString();
          
          // Simpan token ke secure storage
          await storage.write(key: 'jwt_token', value: tokenStr);
          
          // Optional: simpan user info
          if (data['user'] != null) {
            await storage.write(
              key: 'user_data',
              value: data['user'].toString(),
            );
          }
          
          return {
            'success': true,
            'message': data['message'] ?? 'Login berhasil',
            'token': tokenStr,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Login gagal',
            'token': null,
          };
        }
      } else if (response.statusCode == 422) {
        // Extract validation errors from 422 response
        final responseData = response.data as Map<String, dynamic>?;
        final errors = responseData?['errors'] ?? responseData?['message'] ?? 'Validation error';
        return {
          'success': false,
          'message': 'Validation error 422: ${errors.toString()}',
          'token': null,
        };
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'token': null,
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.message}',
        'token': null,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
        'token': null,
      };
    }
  }

  /// Dapatkan JWT token yang tersimpan
  Future<String?> getToken() async {
    try {
      return await storage.read(key: 'jwt_token');
    } catch (e) {
      return null;
    }
  }

  /// Cek apakah token masih valid
  Future<bool> isTokenValid() async {
    try {
      final token = await getToken();
      if (token == null) return false;
      
      // Cek apakah token sudah expired
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }

  /// Decode JWT token untuk mendapatkan claims
  Future<Map<String, dynamic>?> getTokenClaims() async {
    try {
      final token = await getToken();
      if (token == null) return null;
      
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  /// Logout dan hapus token
  Future<void> logout() async {
    try {
      await storage.delete(key: 'jwt_token');
      await storage.delete(key: 'user_data');
    } catch (e) {
      // Handle error jika diperlukan
    }
  }

  /// Get user NIK dari token
  Future<String?> getUserNik() async {
    try {
      final claims = await getTokenClaims();
      return claims?['nik'] as String?;
    } catch (e) {
      return null;
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}
