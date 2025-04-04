import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:health_care/env.dart';

class WebSocketConfig {
  static StompConfig createConfig({
    required String jwtToken,
    required void Function(StompFrame) onConnect,
    required void Function(StompFrame) onDisconnect,
    required void Function(StompFrame) onStompError,
    required void Function(dynamic error) onWebSocketError,
  }) {
    final wsUrl =
        '${AppEnv.baseUrl.replaceFirst("http", "ws").replaceFirst("https", "wss")}/notifications/websocket';

    return StompConfig(
      url: wsUrl,
      onConnect: onConnect,
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
      onWebSocketError: onWebSocketError,
      onStompError: onStompError,
      onDisconnect: onDisconnect,
      reconnectDelay: const Duration(seconds: 5),
    );
  }
}
