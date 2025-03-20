import 'dart:convert';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/service.dart';
import 'package:http/http.dart' as http;

class AppConfig {
  static const String baseUrl = 'http://192.168.1.2:8080';

  // Đăng nhập
  static Future<String?> login(String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0 && data['data']['authenticated'] == true) {
        String token = data['data']['token'];
        await LocalStorageService.saveToken(token); // Lưu token
        return null; // Đăng nhập thành công
      } else {
        return data['message'] ?? "Lỗi không xác định từ server.";
      }
    } else if (response.statusCode == 401) {
      return "Mật khẩu hiện tại không đúng.";
    } else if (response.statusCode == 404) {
      return "Tài khoản không tồn tại.";
    } else {
      return "Lỗi máy chủ, vui lòng thử lại!";
    }
  }

  // Đăng ký tài khoản mới
  static Future<String?> register(
      String fullName, String phoneNumber, String password) async {
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
        String token = data['data']['token'];
        await LocalStorageService.saveToken(token); // Lưu token
        return null; // Đăng ký thành công
      } else {
        return data['message']; // Lỗi từ server
      }
    } else if (response.statusCode == 409) {
      return "Tài khoản đã tồn tại";
    } else {
      return "Lỗi máy chủ, vui lòng thử lại!";
    }
  }

  // Lấy id hồ sơ người dùng
  static Future<int?> getMyUserId() async {
    final url = Uri.parse('$baseUrl/customer/get-my-info');
    String? token = await LocalStorageService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        int userId = data['data']['id'];
        return userId;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  // Cập nhật hồ sơ
  static Future<String?> updateProfile(Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/customer/update-by-id');
    String? token = await LocalStorageService.getToken();
    int? userId =
        await LocalStorageService.getUserId(); // 🔹 Lấy userId từ local storage

    // 🔹 Kiểm tra nếu chưa có userId, lấy từ API
    if (userId == null) {
      userId = await getMyUserId();
      if (userId != null) {
        await LocalStorageService.saveUserId(userId); // Lưu lại userId
      }
    }

    // 🔹 Nếu vẫn không có ID, báo lỗi
    if (userId == null) {
      return "Lỗi: Không thể xác định ID người dùng.";
    }

    // 🔹 Đảm bảo `profileData` có chứa `id`
    profileData['id'] = userId;

    print("📌 Gửi dữ liệu cập nhật: ${jsonEncode(profileData)}");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(profileData),
      );

      print("📌 Phản hồi từ server: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 0) {
          return null; // ✅ Cập nhật thành công
        } else {
          return data['message'] ?? "Lỗi không xác định từ server.";
        }
      } else {
        return "Lỗi máy chủ: ${response.body}";
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API: $e");
      return "Lỗi kết nối, vui lòng thử lại!";
    }
  }

  // Lấy thông tin người dùng
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final url = Uri.parse('$baseUrl/customer/get-my-info');
    String? token = await LocalStorageService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        int userId = data['data']['id']; // Lấy ID từ API
        await LocalStorageService.saveUserId(
            userId); // Lưu ID vào Local Storage
        await LocalStorageService.saveUserId(
            userId); // Lưu ID vào Local Storage
        return data['data']; // Trả về dữ liệu hồ sơ
      }
    }
    return null; // Lỗi hoặc không lấy được dữ liệu
  }

  // Đăng xuất
  static Future<String?> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout');

    // Lấy token từ local storage
    String? token = await LocalStorageService.getToken();
    if (token == null) {
      return "Không tìm thấy token, vui lòng đăng nhập lại!";
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        await LocalStorageService
            .logOut(); // Xóa token sau khi logout thành công
        return null; // Logout thành công
      } else {
        return data['message'];
      }
    } else {
      return "Lỗi máy chủ, vui lòng thử lại!";
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
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      body: jsonEncode({
        "id": clinicId,
      }),
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
