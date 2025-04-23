import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _keyAvatar = 'userAvatar';
  static const String _keyFullName = 'userFullName';
  static const String _keyPhoneNumber = 'userPhoneNumber';

  // Lưu thông tin user vào local
  static Future<void> saveUserProfile({
    required String avatar,
    required String fullName,
    required String phoneNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAvatar, avatar);
    await prefs.setString(_keyFullName, fullName);
    await prefs.setString(_keyPhoneNumber, phoneNumber);
  }

  // Lấy thông tin user từ local
  static Future<Map<String, String>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'avtar': prefs.getString(_keyAvatar) ?? '',
      'fullName': prefs.getString(_keyFullName) ?? 'Người dùng',
      'phoneNumber': prefs.getString(_keyPhoneNumber) ?? 'Số điện thoại',
    };
  }

  // Xóa thông tin user (nếu cần khi logout)
  static Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAvatar);
    await prefs.remove(_keyFullName);
    await prefs.remove(_keyPhoneNumber);
  }
}
