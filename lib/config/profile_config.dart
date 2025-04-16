import 'dart:convert';
import 'package:health_care/env.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:http/http.dart' as http;

class ProfileConfig {
  static const String baseUrl = AppEnv.baseUrl;
  // =================== Profile =====================
  // Thêm hồ sơ đặt khám
  static Future<String?> createProfile({
    required int customerId,
    required String fullName,
    required String phoneNumber,
    required String birthDate,
    required String gender,
    required String address,
    String? avatar,
  }) async {
    final url = Uri.parse('$baseUrl/profile/create');
    final token = await LocalStorageService.getToken();

    final Map<String, dynamic> profileData = {
      'customerId': customerId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
      'address': address,
      if (avatar != null) 'avatar': avatar,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['status'] == 0) {
        return null; // Tạo hồ sơ thành công
      } else {
        return data['message'] ?? 'Tạo hồ sơ thất bại.';
      }
    } catch (e) {
      print('❌ Lỗi khi tạo hồ sơ: $e');
      return 'Đã xảy ra lỗi khi tạo hồ sơ.';
    }
  }

  // Cập nhật hồ sơ đặt khám
  static Future<String?> updateProfileById({
    required int id,
    required int customerId,
    required String fullName,
    required String phoneNumber,
    required String birthDate,
    required String gender,
    required String cccd,
    required String address,
    String? avatar,
  }) async {
    final url = Uri.parse('$baseUrl/profile/update-by-id');
    final token = await LocalStorageService.getToken();

    final Map<String, dynamic> profileData = {
      'id': id,
      'customerId': customerId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
      'cccd': cccd,
      'address': address,
      if (avatar != null) 'avatar': avatar,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['status'] == 0) {
        return null; // Cập nhật thành công
      } else {
        return data['message'] ?? 'Cập nhật hồ sơ thất bại.';
      }
    } catch (e) {
      print('❌ Lỗi khi cập nhật hồ sơ: $e');
      return 'Đã xảy ra lỗi khi cập nhật hồ sơ.';
    }
  }

  // Hiển thị danh sách hồ sơ đặt khám
  static Future<List<Map<String, dynamic>>?> getAllProfiles() async {
    final url = Uri.parse('$baseUrl/profile/get-all');
    final token = await LocalStorageService.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['status'] == 0) {
        final List<dynamic> profiles = data['data'];
        return profiles.cast<Map<String, dynamic>>();
      } else {
        print('⚠️ Lỗi khi lấy danh sách hồ sơ: ${data['message']}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi khi gọi API get-all: $e');
      return null;
    }
  }

// Lấy hồ sơ theo ID
  static Future<Map<String, dynamic>?> getProfileById(int id) async {
    final url = Uri.parse('$baseUrl/profile/get-by-id');
    final token = await LocalStorageService.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['status'] == 0) {
        return data['data']; // Trả về thông tin hồ sơ
      } else {
        print('⚠️ Lỗi khi lấy hồ sơ theo ID: ${data['message']}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi khi gọi API get-by-id: $e');
      return null;
    }
  }

  // Lấy danh sách hồ sơ theo customerId
  static Future<List<Map<String, dynamic>>?> getProfilesByCustomerId(
      int customerId) async {
    final url = Uri.parse('$baseUrl/profile/get-by-customer-id');
    final token = await LocalStorageService.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'customerId': customerId}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['status'] == 0) {
        final List<dynamic> profiles = data['data'];
        return profiles.cast<Map<String, dynamic>>();
      } else {
        print('⚠️ Lỗi khi lấy hồ sơ theo customerId: ${data['message']}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi khi gọi API get-by-customer-id: $e');
      return null;
    }
  }
}
