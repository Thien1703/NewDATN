import 'websocket_service.dart';

class WebSocketManager {
  static WebSocketService? _instance;

  static WebSocketService getInstance({
    required String jwtToken,
    required String userId,
  }) {
    if (_instance == null) {
      _instance = WebSocketService(
        jwtToken: jwtToken,
        userId: userId,
        onMessageReceived: (_) {}, // mặc định rỗng
        onConnectionChange: (_) {}, // mặc định rỗng
      );
      _instance!.connect();
    }
    return _instance!;
  }

  static WebSocketService? get instance => _instance;

  static void dispose() {
    _instance?.disconnect();
    _instance = null;
  }
}
