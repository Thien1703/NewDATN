import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/services/websocket/websocket_manager.dart';
import 'package:health_care/services/websocket/websocket_service.dart';
import 'package:health_care/views/screens/examination/paidDetail_screen.dart';
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
    if (WebSocketManager.instance != null) {
      _webSocketService = WebSocketManager.instance!;
    } else {
      print("❌ Lỗi: WebSocketManager chưa được khởi tạo!");
      return;
    }

    // Gắn callback nhận thông báo mới vào WebSocket global
    _webSocketService.onMessageReceived = (message) async {
      print("📥 JSON nhận được: ${jsonEncode(message)}");

      final newNotification = {
        "type": message['type'],
        "message": message['message'],
        "appointment": message['appointment'],
        "time": DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now()),
      };

      if (mounted) {
        setState(() {
          notifications.insert(0, newNotification);
        });
      }

      print(
          "🟢 Thông báo mới đã được thêm. Tổng số hiện tại: ${notifications.length}");

      await LocalStorageService.saveNotifications(notifications);

      _showSnackBar(message['message']);
      await _loadSavedNotifications();
    };

    // Theo dõi trạng thái kết nối global
    _webSocketService.onConnectionChange = (bool isConnected) {
      print(
          isConnected ? "🟢 WebSocket kết nối!" : "🔴 WebSocket ngắt kết nối.");
      setState(() {
        _isConnected = isConnected;
      });
    };

    // Kiểm tra kết nối ban đầu
    _isConnected = _webSocketService.isConnected;
  }

  Future<void> _loadSavedNotifications() async {
    final saved = await LocalStorageService.getSavedNotifications();
    print("📦 Đã tải ${saved.length} thông báo từ local.");
    setState(() {
      notifications = saved;
    });
  }

  void _showSnackBar(String message) {
    if (mounted) {
      print("🍫 SnackBar: $message");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
    }
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
                      item["message"] ?? "Thông báo không rõ",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item["appointment"] != null)
                          Text(_formatAppointment(item["appointment"])),
                        Text("🕒 ${item["time"]}",
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    onTap: () {
                      final appointment = item['appointment'];

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaidDetailScreen(
                              appointmentId: appointment['id'],
                              status: appointment['status'],
                            ),
                          ));
                    },
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
}
