import 'package:http/http.dart' as http;
import 'dart:convert';

class AbsenService {
  static const String checkInUrl =
      'https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-in-v2';
  static const String checkOutUrl =
      'https://apis.holding-perkebunan.com/aghris/pb-03-5-2-check-out-v2';
  static const String userAccess = 'AGHRIS_MOBILE';
  static const String apiKey = '270F672B-3CEF-4C6C-A362-359B8B0CAEA1';

  static Future<Map<String, dynamic>> checkIn({
    required String nik,
    required double lat,
    required double long,
    required String tanggal,
    required String jam,
    required String shift,
    required String mood,
    required String jenisAbsen,
  }) async {
    try {
      final url = Uri.parse(
        '$checkInUrl'
        '?user-access=$userAccess'
        '&key=$apiKey'
        '&nik-sap-target=$nik'
        '&jenis-absen=$jenisAbsen'
        '&shift=$shift'
        '&tanggal=$tanggal'
        '&check-in-time=$jam'
        '&checkin-long=$long'
        '&checkin-lat=$lat'
        '&user=$nik'
        '&mood=$mood',
      );

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          return {
            'success': true,
            'message': 'Absensi berhasil',
            'data': jsonResponse,
          };
        } catch (e) {
          return {
            'success': true,
            'message': 'Absensi berhasil (Response: ${response.body})',
            'data': response.body,
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Absensi gagal (${response.statusCode})',
          'data': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> checkOut({
    required String nik,
    required double lat,
    required double long,
    required String tanggal,
    required String jam,
    required String mood,
  }) async {
    try {
      final url = Uri.parse(
        '$checkOutUrl'
        '?user-access=$userAccess'
        '&key=$apiKey'
        '&nik-sap-target=$nik'
        '&tanggal=$tanggal'
        '&check-out-time=$jam'
        '&checkout-long=$long'
        '&checkout-lat=$lat'
        '&user=$nik'
        '&mood=$mood',
      );

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          return {
            'success': true,
            'message': 'Check-out berhasil',
            'data': jsonResponse,
          };
        } catch (e) {
          return {
            'success': true,
            'message': 'Check-out berhasil (Response: ${response.body})',
            'data': response.body,
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Check-out gagal (${response.statusCode})',
          'data': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> deleteAbsen({
    required String nikSap,
    required String tanggal,
  }) async {
    try {
      final url = Uri.parse('https://amanah.ptpn1.co.id/api/del_api_log');

      final response = await http
          .post(url, body: {'tanggal': tanggal, 'nik_sap': nikSap})
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          return {
            'success': true,
            'message': 'Absensi berhasil dihapus',
            'data': jsonResponse,
          };
        } catch (e) {
          return {
            'success': true,
            'message': 'Absensi berhasil dihapus (Response: ${response.body})',
            'data': response.body,
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Gagal menghapus absensi (${response.statusCode})',
          'data': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
        'data': null,
      };
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}
