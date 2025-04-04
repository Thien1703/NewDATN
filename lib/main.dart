import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/screens/auth/Login/newLogin.dart';
import 'package:health_care/views/screens/welcome/splash_screen.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/services/websocket/websocket_manager.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await VietnamProvinces.initialize();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCqzgAi64GAYpZZ_pkEwriIV4-RFuYEgWM",
      appId: "1:357055052387:android:3ca405edbbe269ed929656",
      messagingSenderId: "357055052387",
      projectId: "health-care-a85f5",
      storageBucket: "health-care-a85f5.firebasestorage.app",
    ),
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

        print("📥 Global notification: $notificationMessage");

        final saved = await LocalStorageService.getSavedNotifications();
        final newNotification = {
          "type": notificationType,
          "message": notificationMessage,
          "appointment": message['appointment'],
          "time": DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now()),
        };
        saved.insert(0, newNotification);
        await LocalStorageService.saveNotifications(saved);

        final isConfirmed = notificationType == 'CONFIRMED_APPOINTMENT';

        showSimpleNotification(
          Text(
            notificationMessage,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              isConfirmed ? Icons.check_circle : Icons.cancel,
              color: isConfirmed ? Colors.green : Colors.red,
            ),
          ),
          background: isConfirmed ? Colors.green.shade700 : Colors.redAccent.shade700,
          elevation: 10,
          autoDismiss: true,
          slideDismissDirection: DismissDirection.horizontal,
          duration: const Duration(seconds: 4),
          position: NotificationPosition.top,
        );
      },
      onConnectionChange: (isConnected) {
        print(isConnected
            ? "🟢 WebSocket đã kết nối (global)."
            : "🔴 WebSocket đã ngắt kết nối (global).");
      },
    ).connect();
  } else {
    print("⚠️ Không thể khởi tạo WebSocket: thiếu token hoặc userId.");
  }

  runApp(
    OverlaySupport.global(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
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
