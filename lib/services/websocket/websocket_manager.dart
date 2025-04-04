import 'websocket_service.dart';

class WebSocketManager {
  static WebSocketService? _instance;

  /// Hàm khởi tạo Singleton
  static WebSocketService getInstance({
    required String jwtToken,
    required String userId,
    required OnMessageReceived onMessageReceived,
    required OnConnectionChange onConnectionChange,
  }) {
    _instance ??= WebSocketService(
      jwtToken: jwtToken,
      userId: userId,
      onMessageReceived: onMessageReceived,
      onConnectionChange: onConnectionChange,
    );

    return _instance!;
  }

  /// Lấy instance hiện tại
  static WebSocketService? get instance => _instance;

  /// Hủy kết nối và xóa instance
  static void dispose() {
    _instance?.disconnect();
    _instance = null;
  }
}
