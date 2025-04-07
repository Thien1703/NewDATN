import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/screens/auth/Login/login_screen.dart';
import 'package:health_care/views/screens/welcome/splash_screen.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/screens/examination/paidDetail_screen.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/services/websocket/websocket_manager.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Yêu cầu quyền thông báo nếu chưa được cấp (Android 13+)
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  await VietnamProvinces.initialize();

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
                status: "CONFIRMED", // hoặc truyền từ local nếu có
              ),
            ),
          );
        }
      }
    },
  );

  final jwtToken = await LocalStorageService.getToken();
  final userId = (await LocalStorageService.getUserId())?.toString();

  if (jwtToken != null && userId != null) {
    WebSocketManager.getInstance(
      jwtToken: jwtToken,
      userId: userId,
      onMessageReceived: (message) async {
        final notificationMessage = message['message'];
        final notificationType = message['type'];
        final appointment = message['appointment'];
        final appointmentId = appointment?['id'];

        print("📥 Đã nhận thông báo mới: $notificationMessage");

        final savedNotifications =
            await LocalStorageService.getSavedNotifications();
        final newNotification = {
          "type": notificationType,
          "message": notificationMessage,
          "appointment": appointment,
          "time": DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now()),
        };
        savedNotifications.insert(0, newNotification);
        await LocalStorageService.saveNotifications(savedNotifications);

        // ✅ Gửi notification với payload chứa ID
        await _showLocalNotification(
          notificationType,
          notificationMessage,
          appointmentId?.toString(),
        );
      },
      onConnectionChange: (isConnected) {
        print(isConnected
            ? "🟢 WebSocket đã kết nối thành công."
            : "🔴 WebSocket đã ngắt kết nối.");
      },
    ).connect();
  } else {
    print("⚠️ Không thể kết nối WebSocket: thiếu thông tin xác thực.");
  }

  runApp(const MyApp());
}

Future<void> _showLocalNotification(
    String type, String message, String? appointmentId) async {
  final isConfirmed = type == 'CONFIRMED_APPOINTMENT';

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
    isConfirmed ? '✅ Xác nhận lịch hẹn' : '❌ Hủy lịch hẹn',
    message,
    notificationDetails,
    payload: appointmentId != null ? "appointmentId:$appointmentId" : null,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomeScreens(),
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi', 'VN'),
        ],
      ),
    );
  }
}
