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
    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    String? jwtToken = await LocalStorageService.getToken();
    int? userIdInt = await LocalStorageService.getUserId();
    String? userId = userIdInt?.toString(); // Chuyển đổi an toàn

    if (jwtToken != null && userId != null) {
      _webSocketService = WebSocketService(
        jwtToken: jwtToken,
        userId: userId,
        onMessageReceived: (message) {
          setState(() {
            notifications.insert(0, {
              "type": message['type'],
              "message": message['message'],
              "appointment": message['appointment'],
              "time": DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now()),
            });
          });
          _showSnackBar(message['message']);
        },
        onConnectionChange: (bool isConnected) {
          setState(() {
            _isConnected = isConnected;
          });
        },
      );

      _webSocketService.connect();
    } else {
      debugPrint('⚠️ Không thể lấy JWT Token hoặc User ID');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
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
            onPressed: () => _initializeWebSocket(),
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _webSocketService.sendMessage('Ping from Flutter');
            },
            child: const Text('Gửi notify'),
          ),
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text("Không có thông báo nào"))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: const Icon(Icons.notifications_active,
                              color: Colors.blue),
                          title: Text(notification["message"]),
                          subtitle: Text("🕒 ${notification["time"]}"),
                          onTap: () {
                            _showDetails(notification);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDetails(Map<String, dynamic> notification) {
    final appointment = notification["appointment"];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notification["message"]),
          content: Text("Chi tiết lịch hẹn:\n$appointment"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }
}
