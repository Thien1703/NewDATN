  import 'dart:async';
  import 'dart:convert';
  import 'package:stomp_dart_client/stomp_dart_client.dart';

  // Định nghĩa kiểu callback cho các sự kiện nhận tin nhắn và thay đổi trạng thái kết nối
  typedef OnMessageReceived = void Function(Map<String, dynamic> message);
  typedef OnConnectionChange = void Function(bool isConnected);

  class WebSocketService {
    late StompClient stompClient; // Đối tượng quản lý kết nối WebSocket
    final String jwtToken; // JWT Token để xác thực người dùng
    final String userId; // ID của user đang đăng nhập
    final OnMessageReceived onMessageReceived; // Callback khi nhận tin nhắn
    final OnConnectionChange onConnectionChange; // Callback khi trạng thái kết nối thay đổi
    bool _isConnected = false; // Trạng thái kết nối WebSocket

    // Constructor của class, yêu cầu truyền vào token, userId, và các callback
    WebSocketService({
      required this.jwtToken,
      required this.userId,
      required this.onMessageReceived,
      required this.onConnectionChange,
    });

    // Hàm khởi tạo kết nối WebSocket
    void connect() {
      stompClient = StompClient(
        config: StompConfig(
          url: 'ws://https://backend-healthcare-up0d.onrender.com/notifications/websocket', // URL WebSocket của server
          onConnect: _onConnect, // Gọi khi kết nối thành công
          beforeConnect: () async {
            print('Waiting to connect...');
            await Future.delayed(const Duration(milliseconds: 200));
            print('Connecting...');
          },
          stompConnectHeaders: {
            'Authorization': 'Bearer $jwtToken', // Gửi token trong header để xác thực
          },
          webSocketConnectHeaders: {
            'Authorization': 'Bearer $jwtToken', // Header xác thực cho WebSocket
          },
          onWebSocketError: (dynamic error) {
            print('🔴 WebSocket Error: $error'); // Xử lý lỗi khi kết nối thất bại
            _setConnectionStatus(false);
          },
          onStompError: (StompFrame frame) {
            print('🔴 Stomp Error: ${frame.body}'); // Xử lý lỗi khi có lỗi từ STOMP server
            _setConnectionStatus(false);
          },
          onDisconnect: (StompFrame frame) {
            print('🔴 WebSocket Disconnected'); // Xử lý khi WebSocket bị ngắt kết nối
            _setConnectionStatus(false);
          },
          reconnectDelay: const Duration(seconds: 5), // Thử kết nối lại sau 5 giây nếu bị mất kết nối
        ),
      );

      stompClient.activate(); // Kích hoạt kết nối WebSocket
    }

    // Hàm xử lý khi kết nối WebSocket thành công
    void _onConnect(StompFrame frame) {
      print('🟢 WebSocket Connected!');
      _setConnectionStatus(true);

      // Đăng ký (subscribe) vào kênh nhận thông báo của user
      stompClient.subscribe(
        destination: '/user/$userId/notifications/websocket', // Kênh nhận thông báo của user
        callback: (StompFrame frame) {
          if (frame.body != null) {
            try {
              final Map<String, dynamic> data = jsonDecode(frame.body!); // Chuyển đổi JSON thành Map
              print('📩 Nhận thông báo: $data');
              onMessageReceived(data); // Gọi callback khi nhận được tin nhắn
            } catch (e) {
              print('⚠️ Lỗi giải mã JSON: $e'); // Bắt lỗi nếu JSON không hợp lệ
            }
          }
        },
      );
      print("✅ Đã subscribe vào kênh: /user/$userId/notifications/websocket");

      // Gửi một tin nhắn test để kiểm tra kết nối thành công
      stompClient.send(
        destination: '/app/notify', // Kênh gửi tin nhắn
        body: jsonEncode({'message': 'Hello from Flutter'}), // Dữ liệu gửi đi
      );
    }

    // Hàm gửi tin nhắn qua WebSocket
    void sendMessage(String message) {
      stompClient.send(
        destination: '/app/notify', // Kênh gửi tin nhắn
        body: jsonEncode({'message': message}), // Dữ liệu gửi đi dưới dạng JSON
      );
    }

    // Hàm đóng kết nối WebSocket
    void disconnect() {
      stompClient.deactivate(); // Hủy kích hoạt WebSocket
      _setConnectionStatus(false);
    }

    // Hàm cập nhật trạng thái kết nối và gọi callback nếu có sự thay đổi
    void _setConnectionStatus(bool status) {
      if (_isConnected != status) {
        _isConnected = status;
        onConnectionChange(status); // Gọi callback để cập nhật UI hoặc xử lý logic
      }
    }
  }
