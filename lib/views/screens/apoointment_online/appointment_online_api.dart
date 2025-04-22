import 'dart:convert';
import 'package:health_care/env.dart';
import 'package:http/http.dart' as http;
import 'package:health_care/services/local_storage_service.dart';

class AppointmentOnlineApi {
  static Future<Map<String, dynamic>?> createOnlineAppointment({
    required int employeeId,
    required int customerId,
    required String date,
    required String time,
  }) async {
    final url = Uri.parse('${AppEnv.baseUrl}/appointment/create-online-and-pay');
    String? token = await LocalStorageService.getToken();

    if (token == null) {
      print("❌ Token không tồn tại.");
      return null;
    }

    final body = {
      "employeeId": employeeId,
      "customerId": customerId,
      "date": date,
      "time": time,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('📡 Appointment API Status: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 0) {
          final data = json['data'];
          if (data != null && data is Map<String, dynamic>) {
            return data; // 👈 Trả về dữ liệu QR, checkoutUrl, orderCode, ...
          }
        } else {
          print('❌ API trả lỗi: ${json['message']}');
        }
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API đặt lịch: $e");
    }

    return null;
  }
}
