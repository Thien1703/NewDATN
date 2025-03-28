import 'dart:convert';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/models/clinic.dart';
import 'package:http/http.dart' as http;

class AppConfig {
  static const String baseUrl = 'https://backend-healthcare-up0d.onrender.com';
  // Đăng nhập
  static Future<String?> login(String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'password': password}),
    );

    final utf8Body = utf8.decode(response.bodyBytes);
    final data = jsonDecode(utf8Body);

    if (response.statusCode == 200) {
      if (data['status'] == 0 && data['data']['authenticated'] == true) {
        final String token = data['data']['token'];
        await LocalStorageService.saveToken(token);
        print("✅ Đã lưu token");

        // Gọi API lấy userId
        final userId = await getMyUserId();
        if (userId != null) {
          await LocalStorageService.saveUserId(userId);
          print("✅ Đã lưu userId: $userId");
          return null;
        } else {
          print("❌ Không lấy được userId");
          return "Không thể lấy thông tin tài khoản.";
        }
      } else {
        return data['message'] ?? "Đăng nhập thất bại.";
      }
    } else if (response.statusCode == 401) {
      return "Mật khẩu không đúng.";
    } else if (response.statusCode == 404) {
      return "Tài khoản không tồn tại.";
    } else {
      return "Lỗi máy chủ: ${response.statusCode}";
    }
  }

  // ========================= ĐĂNG KÝ =========================
  static Future<String?> register(
    String fullName,
    String phoneNumber,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['status'] == 0 && data['data']['authenticated'] == true) {
        final token = data['data']['token'];
        await LocalStorageService.saveToken(token);

        // Lưu userId sau khi đăng ký
        final userId = await getMyUserId();
        if (userId != null) {
          await LocalStorageService.saveUserId(userId);
          print("✅ Đăng ký xong, lưu userId: $userId");
        }

        return null;
      } else {
        return data['message'] ?? "Lỗi không xác định từ server.";
      }
    } else if (response.statusCode == 409) {
      return "Tài khoản đã tồn tại.";
    } else {
      return "Lỗi máy chủ: ${response.statusCode}";
    }
  }

  // ===================== LẤY USER ID =========================
  static Future<int?> getMyUserId() async {
    final url = Uri.parse('$baseUrl/customer/get-my-info');
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
        final userId = data['data']['id'];
        print("✅ Lấy userId thành công: $userId");
        return userId;
      } else {
        print("⚠️ Không lấy được userId: ${data['message']}");
        return null;
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API lấy userId: $e");
      return null;
    }
  }

  // ======================= CẬP NHẬT HỒ SƠ =====================
  static Future<String?> updateProfile(Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/customer/update-by-id');
    final token = await LocalStorageService.getToken();
    int? userId = await LocalStorageService.getUserId();

    if (userId == null) {
      userId = await getMyUserId();
      if (userId != null) await LocalStorageService.saveUserId(userId);
    }

    if (userId == null) {
      return "❌ Không xác định được ID người dùng.";
    }

    profileData['id'] = userId;

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
        print("✅ Cập nhật hồ sơ thành công");
        return null;
      } else {
        return data['message'] ?? "Cập nhật thất bại.";
      }
    } catch (e) {
      print("❌ Lỗi cập nhật hồ sơ: $e");
      return "Lỗi kết nối.";
    }
  }

  // ====================== LẤY HỒ SƠ NGƯỜI DÙNG ====================
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final url = Uri.parse('$baseUrl/customer/get-my-info');
    final token = await LocalStorageService.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['status'] == 0) {
        final userId = data['data']['id'];
        await LocalStorageService.saveUserId(userId);
        print("✅ Hồ sơ người dùng đã được lưu: $userId");
        return data['data'];
      }
    } catch (e) {
      print("❌ Lỗi lấy hồ sơ: $e");
    }
    return null;
  }

  // ========================== ĐĂNG XUẤT ==========================
  static Future<String?> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout');
    final token = await LocalStorageService.getToken();

    if (token == null) return "Không tìm thấy token.";

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 0) {
        await LocalStorageService.logOut();
        print("✅ Đăng xuất thành công");
        return null;
      } else {
        return data['message'];
      }
    } catch (e) {
      print("❌ Lỗi khi đăng xuất: $e");
      return "Đăng xuất thất bại.";
    }
  }

  //Lấy api của phòng khám
  static Future<List<Clinic>> getAllClinic() async {
    final url = Uri.parse('${baseUrl}/clinic/get-all');
    String? token = await LocalStorageService.getToken();
    if (token == null) {
      return [];
    }
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print('Giá trị status của API: ${response.statusCode}');
    print('Giá trị API trả về body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        List<Clinic> clinices = (data['data'] as List)
            .map((item) => Clinic.fromJson(item))
            .toList();
        return clinices;
      } else {
        print(' Lỗi từ API: ${data['message']}');
      }
    } else {
      print(' API lỗi: ${response.statusCode}');
    }
    return [];
  }

  //Lấy api của phòng khám theo id
  static Future<Clinic?> getClinicById(int clinicId) async {
    final url = Uri.parse('$baseUrl/clinic/get-by-id');
    String? token = await LocalStorageService.getToken();

    if (token == null) return null;

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"id": clinicId}),
    );

    print('Giá trị status của API: ${response.statusCode}');
    print('Giá trị API trả về body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 0 && data['data'] != null) {
        return Clinic.fromJson(data['data']); // Trả về một đối tượng Clinic
      } else {
        print('Lỗi từ API: ${data['message']}');
      }
    } else {
      print('API lỗi: ${response.statusCode}');
    }

    return null;
  }
}
