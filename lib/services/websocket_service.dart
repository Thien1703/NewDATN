import 'dart:async';
import 'dart:convert';
import 'package:health_care/env.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

typedef OnMessageReceived = void Function(Map<String, dynamic> message);
typedef OnConnectionChange = void Function(bool isConnected);

class WebSocketService {
  late StompClient stompClient;
  final String jwtToken;
  final String userId;
  final OnMessageReceived onMessageReceived;
  final OnConnectionChange onConnectionChange;

  bool _isConnected = false;

  WebSocketService({
    required this.jwtToken,
    required this.userId,
    required this.onMessageReceived,
    required this.onConnectionChange,
  });

  void connect() {
    final wsUrl = '${AppEnv.baseUrl.replaceFirst("http", "ws")}/notifications/websocket';

    stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: _onConnect,
        beforeConnect: () async {
          print('🕒 Đang chờ kết nối WebSocket...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('🔌 Đang kết nối tới $wsUrl');
        },
        stompConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        onWebSocketError: (dynamic error) {
          print('❌ Lỗi WebSocket: $error');
          _setConnectionStatus(false);
        },
        onStompError: (StompFrame frame) {
          print('❌ Lỗi STOMP: ${frame.body}');
          _setConnectionStatus(false);
        },
        onDisconnect: (StompFrame frame) {
          print('🔴 WebSocket đã ngắt kết nối.');
          _setConnectionStatus(false);
        },
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    print('🟢 WebSocket đã kết nối!');
    _setConnectionStatus(true);

    // ✅ Sub kênh nhận phản hồi từ clinic
    subscribeToPrivateChat(userId);
  }

  void _setConnectionStatus(bool status) {
    if (_isConnected != status) {
      _isConnected = status;
      onConnectionChange(status);
    }
  }

  void disconnect() {
    stompClient.deactivate();
    _setConnectionStatus(false);
  }

  /// 🔔 Lắng nghe tin nhắn từ clinic gửi cho phòng khám (broadcast)
  void subscribeToClinicChat(String clinicId) {
    final topic = '/topic/clinic/clinic_$clinicId';
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

  /// 📩 Lắng nghe phản hồi riêng từ nhân viên gửi về
  void subscribeToPrivateChat(String userId) {
    final topic = '/topic/user/$userId';
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

  /// 📤 Gửi tin nhắn đến phòng khám
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
      destination: '/app/chat.send',
      body: jsonEncode(message),
    );

    print('📤 Đã gửi tin nhắn đến clinic [$clinicId]: $message');
  }

  /// 🧪 Tùy chọn: gửi tin test
  void sendTestMessage() {
    stompClient.send(
      destination: '/app/notify',
      body: jsonEncode({'message': 'Ping test từ Flutter'}),
    );
  }
}