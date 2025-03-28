import 'dart:convert'; // ✅ Quan trọng để dùng jsonDecode / jsonEncode
import 'package:flutter/material.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/services/websocket_service.dart';
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
    _initializeWebSocket();
  }

  // 🧠 Tải thông báo đã lưu từ local
  Future<void> _loadSavedNotifications() async {
    final saved = await LocalStorageService.getSavedNotifications();
    setState(() {
      notifications = saved;
    });
    print("📦 Đã tải ${saved.length} thông báo từ local.");
  }

  Future<void> _initializeWebSocket() async {
    String? jwtToken = await LocalStorageService.getToken();
    int? userIdInt = await LocalStorageService.getUserId();
    String? userId = userIdInt?.toString();

    print("🔍 Bắt đầu khởi tạo WebSocket...");
    print("🔐 Token: $jwtToken");
    print("🧑‍💼 userId: $userId");

    if (jwtToken != null && userId != null) {
      _webSocketService = WebSocketService(
        jwtToken: jwtToken,
        userId: userId,
        onMessageReceived: (message) async {
          print("📥 Nhận được thông báo: $message");

          final newNotification = {
            "type": message['type'],
            "message": message['message'],
            "appointment": message['appointment'],
            "time": DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now()),
          };

          setState(() {
            notifications.insert(0, newNotification);
          });

          // 💾 Lưu lại danh sách mới
          await LocalStorageService.saveNotifications(notifications);

          _showSnackBar(message['message']);
        },
        onConnectionChange: (bool isConnected) {
          print(isConnected
              ? "🟢 WebSocket kết nối!"
              : "🔴 WebSocket ngắt kết nối.");
          setState(() {
            _isConnected = isConnected;
          });
        },
      );

      _webSocketService.connect();
    } else {
      print("⚠️ Không thể lấy được token hoặc userId");
      _showSnackBar("Không thể kết nối WebSocket do thiếu thông tin.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
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
            onPressed: _initializeWebSocket,
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
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isNew ? Colors.orange : Colors.green,
                      child: Icon(
                        isNew ? Icons.event_available : Icons.check_circle,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      item["message"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item["appointment"] != null)
                          Text(_formatAppointment(item["appointment"])),
                        Text("🕒 ${item["time"]}", style: const TextStyle(fontSize: 12)),
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
      final date = appointment["date"] ?? "";
      final time = appointment["time"] ?? "";
      return "$clinic - $time ngày $date";
    } catch (e) {
      print("⚠️ Lỗi khi định dạng lịch hẹn: $e");
      return "";
    }
  }

  void _showDetails(Map<String, dynamic> notification) {
    final appointment = notification["appointment"];
    if (appointment == null) return;

    final customerName = appointment["customer"]?["fullName"] ?? "Khách hàng";
    final clinicName = appointment["clinic"]?["name"] ?? "Phòng khám";
    final date = appointment["date"];
    final time = appointment["time"];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification["message"] ?? "Chi tiết thông báo"),
        content: Text("""
👤 Khách: $customerName
🏥 Phòng khám: $clinicName
🗓 Ngày khám: $date
⏰ Giờ: $time
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
