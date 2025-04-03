import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/services/websocket/websocket_manager.dart';
import 'package:health_care/services/websocket/websocket_service.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late WebSocketService _webSocketService;
  List<Map<String, dynamic>> notifications = [];
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadSavedNotifications();

    // Lấy instance WebSocketService global
    _webSocketService = WebSocketManager.instance!;
    _isConnected = true; // Đã kết nối global ở main.dart

    // Gắn callback nhận thông báo mới vào WebSocket global
    _webSocketService.onMessageReceived = (message) async {
      print("📥 JSON nhận được: ${jsonEncode(message)}");

      final newNotification = {
        "type": message['type'],
        "message": message['message'],
        "appointment": message['appointment'],
        "time": DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now()),
      };

      setState(() {
        notifications.insert(0, newNotification);
      });

      print(
          "🟢 Thông báo mới đã được thêm. Tổng số hiện tại: ${notifications.length}");

      await LocalStorageService.saveNotifications(notifications);

      _showSnackBar(message['message']);
    };

    // Theo dõi trạng thái kết nối global
    _webSocketService.onConnectionChange = (bool isConnected) {
      print(
          isConnected ? "🟢 WebSocket kết nối!" : "🔴 WebSocket ngắt kết nối.");
      setState(() {
        _isConnected = isConnected;
      });
    };
  }

  Future<void> _loadSavedNotifications() async {
    final saved = await LocalStorageService.getSavedNotifications();
    setState(() {
      notifications = saved;
    });
    print("📦 Đã tải ${saved.length} thông báo từ local.");
  }

  void _showSnackBar(String message) {
    print("🍫 SnackBar: $message");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  @override
  void dispose() {
    // KHÔNG disconnect ở đây vì WebSocket global
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          IconButton(
            icon: Icon(_isConnected ? Icons.wifi : Icons.wifi_off),
            color: _isConnected ? Colors.green : Colors.red,
            onPressed: () {},
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("📭 Hiện tại không có thông báo mới."))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                final isNew = item["type"] == "NEW_APPOINTMENT";

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isNew ? Colors.orange : Colors.green,
                      child: Icon(
                        isNew ? Icons.event_available : Icons.check_circle,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'fsdfsfsdf ${item["message"] ?? ""}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item["appointment"] != null)
                          Text(
                              'fdfsdfs${_formatAppointment(item["appointment"])}'),
                        Text("🕒itee ${item["time"]}",
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    onTap: () => _showDetails(item),
                  ),
                );
              },
            ),
    );
  }

  String _formatAppointment(Map<String, dynamic> appointment) {
    try {
      final clinic = appointment["clinic"]?["name"] ?? "Phòng khám";
      final date =
          DateFormat('dd/MM/yyyy').format(DateTime.parse(appointment["date"]));
      final time = DateFormat('HH:mm')
          .format(DateTime.parse("1970-01-01 ${appointment["time"]}"));
      return "$clinic - $time ngày $date";
    } catch (e) {
      print("⚠️ Lỗi định dạng lịch hẹn: $e");
      return "";
    }
  }

  void _showDetails(Map<String, dynamic> notification) {
    final appointment = notification["appointment"];
    if (appointment == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification["message"] ?? "Chi tiết thông báo"),
        content: Text("""
👤 Khách: ${appointment["customer"]?["fullName"] ?? "Khách hàng"}
🏥 Phòng khám: ${appointment["clinic"]?["name"] ?? "Phòng khám"}
🗓 Ngày khám: ${appointment["date"]}
⏰ Giờ: ${appointment["time"]}
        """),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          )
        ],
      ),
    );
  }
}
