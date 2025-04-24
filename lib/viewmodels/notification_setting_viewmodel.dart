import 'package:flutter/material.dart';
import 'package:health_care/services/notification_setting_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationSettingService _settingsService;
  bool _isNotificationEnabled = true;

  NotificationViewModel(this._settingsService) {
    loadSetting();
  }

  bool get isNotificationEnabled => _isNotificationEnabled;

  Future<void> toggleNotification(bool value) async {
    _isNotificationEnabled = value;
    await _settingsService.saveNotificationSetting(value);
    notifyListeners();
  }

  Future<void> loadSetting() async {
    _isNotificationEnabled = await _settingsService.getNotificationSetting();
    notifyListeners();
  }
}
