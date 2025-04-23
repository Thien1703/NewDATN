import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/services/websocket/websocket_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/screens/examination/paidDetail_screen.dart';

class AppInitializer {
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ⚙️ Yêu cầu quyền
    await _requestPermissions();

    // 🗺️ Local dữ liệu tỉnh/thành
    // await VietnamProvinces.initialize(); (chuyển vào Splash nếu cần)

    // 🔔 Cấu hình local notification
    await _setupLocalNotification();

    // 🔌 Kết nối WebSocket nếu đã đăng nhập
    await _connectWebSocketIfNeeded();
  }

  static Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.notification,
    ].request();
  }

  static Future<void> _setupLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("🔔 Người dùng đã nhấn thông báo: ${response.payload}");
        if (response.payload != null &&
            response.payload!.startsWith("appointmentId:")) {
          final id = int.tryParse(response.payload!.split(":")[1]);
          if (id != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => PaidDetailScreen(
                  appointmentId: id,
                  status: "CONFIRMED",
                ),
              ),
            );
          }
        }
      },
    );
  }

  static Future<void> _connectWebSocketIfNeeded() async {
    final jwtToken = await LocalStorageService.getToken();
    final userId = (await LocalStorageService.getUserId())?.toString();

    if (jwtToken != null && userId != null) {
      WebSocketManager.getInstance(
        jwtToken: jwtToken,
        userId: userId,
        onMessageReceived: (message) async {
          final messageText = message['message'];
          final type = message['type'];
          final appointment = message['appointment'];
          final appointmentId = appointment?['id'];

          print("📥 [WS] Thông báo mới: $messageText");

          final saved = await LocalStorageService.getSavedNotifications();
          saved.insert(0, {
            "type": type,
            "message": messageText,
            "appointment": appointment,
            "time": DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now()),
          });
          await LocalStorageService.saveNotifications(saved);

          await _showLocalNotification(type, messageText, appointmentId?.toString());
        },
        onConnectionChange: (isConnected) {
          print(isConnected
              ? "🟢 WebSocket đã kết nối từ AppInitializer"
              : "🔴 WebSocket đã mất kết nối.");
        },
      ).connect();
    } else {
      print("⚠️ Không thể khởi tạo WebSocket (thiếu token/userId)");
    }
  }

  static Future<void> _showLocalNotification(
      String type, String message, String? appointmentId) async {
    final isConfirmed = type == 'CANCELED_APPOINTMENT';

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'appointment_channel_id',
      'Thông báo lịch hẹn',
      channelDescription: 'Thông báo xác nhận hoặc hủy lịch hẹn.',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      isConfirmed ? '❌ Hủy lịch hẹn' : '✅ Xác nhận lịch hẹn',
      message,
      notificationDetails,
      payload: appointmentId != null ? "appointmentId:$appointmentId" : null,
    );
  }
}
