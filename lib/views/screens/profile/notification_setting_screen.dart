import 'package:flutter/material.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  final Map<String, bool> _settings = {
    'notifications': true,
    'camera': true,
    'microphone': false,
    'location': true,
    'biometric': true,
    'protect_results': false,
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    for (String key in _settings.keys) {
      bool? value = await LocalStorageService.getSwitchSetting(key);
      if (value != null) {
        setState(() {
          _settings[key] = value;
        });
      }
    }
  }

  Future<void> _updateSetting(String key, bool value) async {
    setState(() {
      _settings[key] = value;
    });
    await LocalStorageService.saveSwitchSetting(key, value);
  }

  Widget _buildTile(String title, String subtitle, IconData icon, String key,
      {Color iconColor = Colors.black}) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      secondary: Icon(icon, color: iconColor),
      value: _settings[key]!,
      onChanged: (val) => _updateSetting(key, val),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: "Cài đặt thông báo",
      iconShare: false,
      color: Colors.white,
      body: ListView(
        children: [
          _buildTile(
              "Thông báo",
              "Nhận thông tin kết quả khám, cuộc gọi đến từ bác sĩ...",
              Icons.notifications,
              'notifications',
              iconColor: Colors.pink),
          _buildTile("Máy ảnh / Camera",
              "Thực hiện gọi video, quét mã QR, BHYT", Icons.videocam, 'camera',
              iconColor: Colors.green),
          _buildTile("Micro", "Thực hiện gọi video với bác sĩ", Icons.mic,
              'microphone',
              iconColor: Colors.green),
          _buildTile("Quyền truy cập vị trí", "Tìm kiếm, gợi ý dịch vụ gần bạn",
              Icons.location_on, 'location',
              iconColor: Colors.blue),
          _buildTile(
              "Sinh trắc học",
              "Dùng đăng nhập thay thế mật khẩu nếu có sinh trắc học",
              Icons.fingerprint,
              'biometric',
              iconColor: Colors.purple),
          _buildTile("Bảo vệ kết quả khám", "Nhập mật khẩu để xem kết quả khám",
              Icons.shield, 'protect_results',
              iconColor: Colors.indigo),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.orange),
            title: Text("Thay đổi mật khẩu"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to change password
            },
          ),
          ListTile(
            leading: Icon(Icons.person_remove, color: Colors.red),
            title: Text("Yêu cầu huỷ tài khoản"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to delete account
            },
          ),
        ],
      ),
    );
  }
}
