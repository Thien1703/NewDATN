import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/services/websocket/websocket_manager.dart';
import 'package:health_care/views/screens/tools/callvideo/video_call_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/screens/examination/paidDetail_screen.dart';

class AppInitializer {
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ⚙️ Yêu cầu quyền
    await _requestPermissions();

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
        print("🔔 Người dùng nhấn thông báo: ${response.payload}");
        if (response.payload != null) {
          if (response.payload!.startsWith("appointmentId:")) {
            final id = int.tryParse(response.payload!.split(":")[1]);
            if (id != null) {
              navigatorKey.currentState?.push(MaterialPageRoute(
                builder: (_) => PaidDetailScreen(
                  appointmentId: id,
                  status: "CONFIRMED",
                ),
              ));
            }
          } else if (response.payload!.startsWith("roomCode:")) {
            final roomCode = response.payload!.split(":")[1];
            navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (_) => VideoCallScreen(channelName: roomCode),
            ));
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
          final roomCode =
              message['roomCode']; // 🔥 lấy roomCode từ WebSocket nếu có

          print("📥 [WS] Thông báo mới: $messageText");

          final saved = await LocalStorageService.getSavedNotifications();
          saved.insert(0, {
            "type": type,
            "message": messageText,
            "roomCode": message['roomCode'], // ⚡ phải lưu thêm dòng này
            "appointment": appointment,
            "time": DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now()),
          });

          await LocalStorageService.saveNotifications(saved);

          // 🔥 Nếu là cuộc gọi video thì ưu tiên truyền roomCode
          if (type == "CALL_VIDEO") {
            await _showLocalNotification(type, messageText, roomCode);
          } else {
            await _showLocalNotification(
                type, messageText, appointmentId?.toString());
          }
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
      String type, String message, String? idOrRoomCode) async {
    final isCallVideo = type == 'CALL_VIDEO';
    final isCanceled = type == 'CANCELED_APPOINTMENT';

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'appointment_channel_id',
      'Thông báo lịch hẹn',
      channelDescription: 'Thông báo xác nhận, hủy lịch hẹn hoặc gọi video.',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      isCallVideo
          ? '📞 Cuộc gọi Video'
          : isCanceled
              ? '❌ Hủy lịch hẹn'
              : '✅ Xác nhận lịch hẹn',
      message,
      notificationDetails,
      payload: isCallVideo
          ? "roomCode:$idOrRoomCode"
          : (idOrRoomCode != null ? "appointmentId:$idOrRoomCode" : null),
    );
  }
}
