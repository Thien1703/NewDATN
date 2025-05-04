import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'websocket_config.dart';

typedef OnMessageReceived = void Function(Map<String, dynamic> message);
typedef OnConnectionChange = void Function(bool isConnected);

class WebSocketService {
  StompClient? stompClient;
  final String jwtToken;
  final String userId;

  final List<OnMessageReceived> _messageListeners = [];
  final List<OnConnectionChange> _connectionListeners = [];

  bool _isConnected = false;
  bool _isReconnecting = false;
  int _retryCount = 0;
  final int _maxRetries = 5;

  static const String USER_TOPIC_PREFIX = '/topic/user/';

  WebSocketService({
    required this.jwtToken,
    required this.userId,
    required OnMessageReceived onMessageReceived,
    required OnConnectionChange onConnectionChange,
  }) {
    addMessageListener(onMessageReceived);
    addConnectionListener(onConnectionChange);
  }

  void connect() {
    if (_isConnected) {
      print("🔴 WebSocket đã được kết nối.");
      return;
    }

    print("⚡ Đang kết nối WebSocket...");

    stompClient?.deactivate();

    stompClient = StompClient(
      config: WebSocketConfig.createConfig(
        jwtToken: jwtToken,
        onConnect: _onConnect,
        onDisconnect: _onDisconnect,
        onStompError: _onStompError,
        onWebSocketError: _onWebSocketError,
      ),
    );

    stompClient!.activate();
  }

  void disconnect() {
    if (!_isConnected) {
      print("🟡 WebSocket chưa được kết nối.");
      return;
    }

    stompClient?.deactivate();
    _setConnectionStatus(false);
  }

  bool get isConnected => _isConnected;

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

  void _retryConnection() async {
    if (_isReconnecting || _retryCount >= _maxRetries) {
      print("⛔ Vượt quá số lần thử lại kết nối WebSocket ($_maxRetries lần). Dừng thử lại.");
      return;
    }

    _isReconnecting = true;
    _retryCount++;

    print("🔁 Đang thử kết nối lại WebSocket lần $_retryCount sau 5 giây...");
    await Future.delayed(Duration(seconds: 5));

    connect();
  }

  void _setConnectionStatus(bool status) {
    if (_isConnected != status) {
      _isConnected = status;
      for (var listener in _connectionListeners) {
        listener(status);
      }
    }
  }

  void _subscribeToUserNotifications(String userId) {
    final topic = '$USER_TOPIC_PREFIX$userId';
    print('📥 Đăng ký lắng nghe thông báo người dùng: $topic');

    stompClient?.subscribe(
      destination: topic,
      callback: (frame) {
        if (frame.body != null) {
          try {
            final message = jsonDecode(frame.body!);
            print('📨 Đã nhận thông báo: $message');

            for (var listener in _messageListeners) {
              listener(message);
            }
          } catch (e) {
            print('❌ Lỗi khi parse JSON: $e');
          }
        }
      },
    );
  }

  // ---------- Public listener APIs ----------

  void addMessageListener(OnMessageReceived listener) {
    if (!_messageListeners.contains(listener)) {
      _messageListeners.add(listener);
    }
  }

  void removeMessageListener(OnMessageReceived listener) {
    _messageListeners.remove(listener);
  }

  void addConnectionListener(OnConnectionChange listener) {
    if (!_connectionListeners.contains(listener)) {
      _connectionListeners.add(listener);
    }
  }

  void removeConnectionListener(OnConnectionChange listener) {
    _connectionListeners.remove(listener);
  }
}
