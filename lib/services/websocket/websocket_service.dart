import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'websocket_config.dart';

typedef OnMessageReceived = void Function(Map<String, dynamic> message);
typedef OnConnectionChange = void Function(bool isConnected);

class WebSocketService {
  late StompClient stompClient;
  final String jwtToken;
  final String userId;
  late OnMessageReceived onMessageReceived;
  late OnConnectionChange onConnectionChange;

  bool _isConnected = false;
  bool _isReconnecting = false;
  int _retryCount = 0;
  final int _maxRetries = 5;

  static const String USER_TOPIC_PREFIX = '/topic/user/';

  WebSocketService({
    required this.jwtToken,
    required this.userId,
    required this.onMessageReceived,
    required this.onConnectionChange,
  });

  void connect() {
    if (_isConnected) {
      print("🔴 WebSocket đã được kết nối.");
      return;
    }

    print("⚡ Đang kết nối WebSocket...");
    stompClient = StompClient(
      config: WebSocketConfig.createConfig(
        jwtToken: jwtToken,
        onConnect: _onConnect,
        onDisconnect: _onDisconnect,
        onStompError: _onStompError,
        onWebSocketError: _onWebSocketError,
      ),
    );

    stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    print('🟢 WebSocket đã kết nối!');
    _retryCount = 0;
    _isReconnecting = false;
    _setConnectionStatus(true);
    _subscribeToUserNotifications(userId);
  }

  void _onDisconnect(StompFrame frame) {
    print('🔴 WebSocket đã ngắt kết nối.');
    _setConnectionStatus(false);
    _retryConnection();
  }

  void _onStompError(StompFrame frame) {
    print('❌ STOMP Error: ${frame.body}');
    _setConnectionStatus(false);
    _retryConnection();
  }

  void _onWebSocketError(dynamic error) {
    print('❌ WebSocket Error: $error');
    _setConnectionStatus(false);
    _retryConnection();
  }

  void disconnect() {
    if (!_isConnected) {
      print("🟡 WebSocket chưa được kết nối.");
      return;
    }

    stompClient.deactivate();
    _setConnectionStatus(false);
  }

  bool get isConnected => _isConnected;

  void _setConnectionStatus(bool status) {
    if (_isConnected != status) {
      _isConnected = status;
      onConnectionChange(status);
    }
  }

  void _retryConnection() async {
    if (_isReconnecting || _retryCount >= _maxRetries) {
      print("⛔ Vượt quá số lần thử lại kết nối WebSocket ($_maxRetries lần). Dừng thử lại.");
      return;
    }

    _isReconnecting = true;
    _retryCount++;

    print("🔁 Đang thử kết nối lại WebSocket lần $_retryCount sau 5 giây...");
    await Future.delayed(Duration(seconds: 5));

    connect(); // gọi lại connect
  }

  void _subscribeToUserNotifications(String userId) {
    final topic = '$USER_TOPIC_PREFIX$userId';
    print('📥 Đăng ký lắng nghe thông báo người dùng: $topic');

    stompClient.subscribe(
      destination: topic,
      callback: (frame) {
        if (frame.body != null) {
          try {
            final message = jsonDecode(frame.body!);
            print('📨 Đã nhận thông báo: $message');
            onMessageReceived(message);
          } catch (e) {
            print('❌ Lỗi khi parse JSON: $e');
          }
        }
      },
    );
  }
}
