import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'websocket_config.dart';
import 'websocket_topics.dart';

typedef OnMessageReceived = void Function(Map<String, dynamic> message);
typedef OnConnectionChange = void Function(bool isConnected);

class WebSocketService {
  late StompClient stompClient;
  final String jwtToken;
  final String userId;
   OnMessageReceived onMessageReceived;
   OnConnectionChange onConnectionChange;

  bool _isConnected = false;

  WebSocketService({
    required this.jwtToken,
    required this.userId,
    required this.onMessageReceived,
    required this.onConnectionChange,
  });

  void connect() {
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
    _setConnectionStatus(true);
    subscribeToPrivateChat(userId);
  }

  void _onDisconnect(StompFrame frame) {
    print('🔴 WebSocket đã ngắt kết nối.');
    _setConnectionStatus(false);
  }

  void _onStompError(StompFrame frame) {
    print('❌ Lỗi STOMP: ${frame.body}');
    _setConnectionStatus(false);
  }

  void _onWebSocketError(dynamic error) {
    print('❌ Lỗi WebSocket: $error');
    _setConnectionStatus(false);
  }

  void disconnect() {
    stompClient.deactivate();
    _setConnectionStatus(false);
  }

  void _setConnectionStatus(bool status) {
    if (_isConnected != status) {
      _isConnected = status;
      onConnectionChange(status);
    }
  }

  void subscribeToClinicChat(String clinicId) {
    final topic = WebSocketTopics.clinicTopic(clinicId);
    print('📥 Subscribing to clinic topic: $topic');

    stompClient.subscribe(
      destination: topic,
      callback: (frame) {
        if (frame.body != null) {
          try {
            final message = jsonDecode(frame.body!);
            print('📨 Nhận từ clinic [$clinicId]: $message');
            onMessageReceived(message);
          } catch (e) {
            print('❌ Lỗi JSON clinic chat: $e');
          }
        }
      },
    );
  }

  void subscribeToPrivateChat(String userId) {
    final topic = WebSocketTopics.userTopic(userId);
    print('📥 Subscribing to user topic: $topic');

    stompClient.subscribe(
      destination: topic,
      callback: (frame) {
        if (frame.body != null) {
          try {
            final message = jsonDecode(frame.body!);
            print('📥 Nhận tin nhắn riêng: $message');
            onMessageReceived(message);
          } catch (e) {
            print('❌ Lỗi JSON private chat: $e');
          }
        }
      },
    );
  }

  void sendChatMessage({
    required String senderId,
    required String clinicId,
    required String content,
  }) {
    final message = {
      'senderId': senderId,
      'recipientId': 'clinic_$clinicId',
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    };

    stompClient.send(
      destination: WebSocketTopics.sendChatMessage,
      body: jsonEncode(message),
    );

    print('📤 Đã gửi tin nhắn đến clinic [$clinicId]: $message');
  }

  void sendTestMessage() {
    stompClient.send(
      destination: WebSocketTopics.testNotification,
      body: jsonEncode({'message': 'Ping test từ Flutter'}),
    );
  }
}
