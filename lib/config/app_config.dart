import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_care/env.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/views/screens/auth/Login/otp_screen.dart';
import 'package:http/http.dart' as http;

class AppConfig {
  static const String baseUrl = AppEnv.baseUrl;

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
      return "Mật khẩu không đúng!";
    } else if (response.statusCode == 404) {
      return "Tài khoản không tồn tại!";
    } else {
      return "Lỗi máy chủ: ${response.statusCode}";
    }
  }

  // ========================= ĐĂNG KÝ =========================
  static Future<String?> register(
    BuildContext context,
    String fullName,
    String phoneNumber,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['status'] == 0) {
        String? otp;
        String? verifyResult;
        String? errorMessage;

        do {
          otp = await showOtpDialog(context, errorMessage: errorMessage);

          if (otp == null) {
            return "Bạn đã hủy xác thực OTP.";
          }

          if (otp.isEmpty) {
            errorMessage = "Bạn chưa nhập OTP.";
            continue;
          }

          verifyResult =
              await verifyOtp(fullName, phoneNumber, email, password, otp);

          if (verifyResult != null) {
            errorMessage = "Bạn nhập sai OTP. Vui lòng nhập đúng.";
          }
        } while (verifyResult != null);

        return null; // ✅ Thành công
      } else {
        return data['message'] ?? "Lỗi không xác định từ server.";
      }
    } else if (response.statusCode == 409) {
      return "Tài khoản đã tồn tại.";
    } else {
      return "Lỗi máy chủ: ${response.statusCode}";
    }
  }

  static Future<String?> verifyOtp(String fullName, String phoneNumber,
      String email, String password, String otp) async {
    final url = Uri.parse('$baseUrl/auth/register/verify-otp?otp=$otp');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['status'] == 0 && data['data']['authenticated'] == true) {
        final token = data['data']['token'];
        await LocalStorageService.saveToken(token);

        // Lưu userId sau khi xác thực OTP thành công
        final userId = await getMyUserId();
        if (userId != null) {
          await LocalStorageService.saveUserId(userId);
          print("✅ Xác thực OTP xong, lưu userId: $userId");
        }

        return null;
      } else {
        return data['message'] ?? "OTP không hợp lệ.";
      }
    } else {
      return "Lỗi xác thực OTP: ${response.statusCode}";
    }
  }

  static Future<String?> showOtpDialog(BuildContext context,
      {String? errorMessage}) async {
    String otp = "";
    String? localError = errorMessage;

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Nhập mã OTP"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      otp = value;
                      if (localError != null) {
                        setState(() => localError = null);
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Nhập mã OTP nhận được",
                    ),
                  ),
                  if (localError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        localError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                TextButton(
                  onPressed: () {
                    if (otp.isEmpty) {
                      setState(() {
                        localError = "Bạn chưa nhập OTP.";
                      });
                    } else {
                      Navigator.pop(context, otp);
                    }
                  },
                  child: const Text("Xác nhận"),
                ),
              ],
            );
          },
        );
      },
    );
  }
// =================== QUÊN MẬT KHẨU ===================

  /// Bước 1: Gửi OTP tới email
  static Future<String?> forgotPassword(
      BuildContext context, String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password/send-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['status'] == 0) {
        print("✅Gửi OTP tới cho email: $email");

        final otp = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              email: email,
              onOtpSubmit: (otp) async {
                return await verifyForgotPasswordOtp(email: email, otp: otp);
              },
            ),
          ),
        );

        // if (otp == null) {
        //   print("🛑 Người dùng đã thoát màn hình OTP.");
        //   return null;
        // }
          if (otp == null) return "cancelled";
          // if (otp.isEmpty) {
          //   errorMessage = "Bạn chưa nhập OTP.";
          //   continue;
          // }

        return otp; // ✅ OTP hợp lệ
      } else {
        return data['message'] ?? 'Gửi OTP thất bại.';
      }
    } catch (e) {
      print("❌ Lỗi gửi OTP: $e");
      return 'Đã xảy ra lỗi khi gửi OTP.';
    }
  }

  /// Bước 2: Xác thực mã OTP
  static Future<String?> verifyForgotPasswordOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password/verify-otp?otp=$otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print("📥 Response: ${response.statusCode} - ${data}");

      if (response.statusCode == 200 && data['status'] == 0) {
        print("✅ OTP xác thực thành công cho $email");
        return null; // ✅ OTP hợp lệ
      } else {
        return data['message'] ?? 'Xác thực OTP thất bại.';
      }
    } catch (e) {
      print("❌ Lỗi xác thực OTP: $e");
      return 'Đã xảy ra lỗi khi xác thực OTP.';
    }
  }

  /// Bước 3: Đặt lại mật khẩu mới
  static Future<String?> resetPassword(
      {required String email,
      required String otp,
      required String newPassword,
      required String confirmPassword}) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password/reset');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
          'confirmNewPassword': confirmPassword,
        }),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['status'] == 0) {
        return null; // ✅ Đặt lại mật khẩu thành công
      } else {
        return data['message'] ?? 'Không thể đặt lại mật khẩu.';
      }
    } catch (e) {
      print("❌ Lỗi đặt lại mật khẩu: $e");
      return 'Đã xảy ra lỗi khi đặt lại mật khẩu.';
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

  /// Đổi avatar
  static Future<String?> uploadAvatar(File imageFile, int userId) async {
    final url = Uri.parse('$baseUrl/customer/avatar/$userId');
    String? token = await LocalStorageService.getToken();

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 0) {
          return data['message']; // Trả về URL ảnh đã upload
        } else {
          return data['message'] ?? "Lỗi không xác định từ server.";
        }
      } else {
        return "Lỗi máy chủ: ${response.statusCode}";
      }
    } catch (e) {
      return "Lỗi khi upload ảnh: $e";
    }
  }

  // Lấy thông tin người dùng
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

  // Đổi mật khẩu
  static Future<String?> changePassword(int customerId, String oldPassword,
      String newPassword, String confirmNewPassword) async {
    final url = Uri.parse('$baseUrl/customer/change-password');
    String? token = await LocalStorageService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "customerId": customerId,
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmNewPassword": confirmNewPassword,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        return null; // ✅ Đổi mật khẩu thành công
      } else {
        return data['message'] ?? "Lỗi không xác định từ server.";
      }
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      if (data['status'] == 4001) {
        return "Mật khẩu cũ không chính xác";
      }
      if (data['status'] == 4002) {
        return "Mật khẩu xác nhận không trùng khớp";
      }
      if (data['status'] == 1008) {
        return "Mật khẩu mới không trùng được trùng mật khẩu cũ";
      }
    } else {
      return "Lỗi máy chủ: ${response.statusCode}";
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
}
