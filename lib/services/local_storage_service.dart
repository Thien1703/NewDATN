import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class LocalStorageService {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyFirstTime = 'first_time';

  /// 🔄 Kiểm tra mở app lần đầu
  static Future<bool> isFirstTime() async {
    try {
      String? firstTimeFlag = await _storage.read(key: _keyFirstTime);
      print("🟡 Trạng thái mở lần đầu: $firstTimeFlag");

      if (firstTimeFlag == null) {
        await _storage.write(key: _keyFirstTime, value: 'false');
        print("🆕 Đây là lần đầu tiên mở ứng dụng.");
        return true;
      }

      return false;
    } catch (e) {
      print("❌ Lỗi khi kiểm tra lần mở đầu tiên: $e");
      return false;
    }
  }

  /// 🔐 Lưu token đăng nhập
  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _keyToken, value: token);
      print("✅ Đã lưu token thành công: $token");
    } catch (e) {
      print("❌ Lỗi khi lưu token: $e");
    }
  }

  /// 🔓 Lấy token đăng nhập
  static Future<String?> getToken() async {
    try {
      String? token = await _storage.read(key: _keyToken);
      if (token != null) {
        print("✅ Token lấy được: $token");
      } else {
        print("⚠️ Không tìm thấy token.");
      }
      return token;
    } catch (e) {
      print("❌ Lỗi khi lấy token: $e");
      return null;
    }
  }

  /// 💾 Lưu user ID
  static Future<void> saveUserId(int userId) async {
    try {
      await _storage.write(key: _keyUserId, value: userId.toString());
      print("✅ Đã lưu userId: $userId");
    } catch (e) {
      print("❌ Lỗi khi lưu userId: $e");
    }
  }

  /// 🔓 Lấy user ID
  static Future<int?> getUserId() async {
    try {
      String? userIdStr = await _storage.read(key: _keyUserId);
      if (userIdStr == null) {
        print("⚠️ Không tìm thấy userId.");
        return null;
      }

      final userId = int.tryParse(userIdStr);
      print("✅ userId lấy được: $userId");
      return userId;
    } catch (e) {
      print("❌ Lỗi khi lấy userId: $e");
      return null;
    }
  }

  /// ✅ Kiểm tra trạng thái đăng nhập
  static Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      final isLogged = token != null;
      print("🔍 Đã đăng nhập chưa? $isLogged");
      return isLogged;

    } catch (e) {
      print("❌ Lỗi khi kiểm tra đăng nhập: $e");
      return false;
    }
  }

  /// 🚪 Đăng xuất
  static Future<void> logOut() async {
    try {
      await _storage.delete(key: _keyToken);
      await _storage.delete(key: _keyUserId);
      print("✅ Đã xoá token và userId khi đăng xuất.");
    } catch (e) {
      print("❌ Lỗi khi đăng xuất: $e");
    }
  }

  ///Thông báo
  static const _keyNotificationList = 'user_notifications';

  static Future<void> saveNotifications(List<Map<String, dynamic>> list) async {
    try {
      final encoded = jsonEncode(list);
      await _storage.write(key: _keyNotificationList, value: encoded);
      print("📦 Đã lưu ${list.length} thông báo vào local.");
    } catch (e) {
      print("❌ Lỗi khi lưu notifications vào local: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getSavedNotifications() async {
    final raw = await _storage.read(key: _keyNotificationList);
    if (raw == null) {
      print("📦 Không có dữ liệu thông báo lưu trữ.");
      return [];
    }

    try {
      final decoded = jsonDecode(raw);

      // Kiểm tra kiểu dữ liệu sau khi giải mã
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        print("❌ Dữ liệu giải mã không phải là List. Đã nhận: $decoded");
        return [];
      }
    } catch (e) {
      print("❌ Lỗi khi đọc notifications từ local: $e");
      return [];
    }
  }
}
