import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingService {
  static const String _notificationKey = 'notification_enabled';

  Future<void> saveNotificationSetting(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, isEnabled);
  }

  Future<bool> getNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationKey) ?? true; // default: true
  }
}
