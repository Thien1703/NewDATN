import 'dart:convert';
import 'package:http/http.dart' as http;
import 'payos_config.dart';

Future<String?> createPaymentLink({
  required int amount,
  required String description,
  required String orderCode,
  required String returnUrl,
  required String cancelUrl,
}) async {
  final url = Uri.parse('${PayOSConfig.baseUrl}/v2/payment-requests');

  final headers = {
    'x-client-id': PayOSConfig.clientId,
    'x-api-key': PayOSConfig.apiKey,
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    "orderCode": orderCode,
    "amount": amount,
    "description": description,
    "returnUrl": returnUrl,
    "cancelUrl": cancelUrl,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['checkoutUrl'];
  } else {
    print('Lỗi tạo thanh toán: ${response.body}');
    return null;
  }
}
