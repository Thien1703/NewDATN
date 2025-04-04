import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/services/local_storage_service.dart';

class CustomerApi {
  static Future<Customer?> getCustomerProfile() async {
    final url = Uri.parse('${AppConfig.baseUrl}/customer/get-my-info');
    String? token = await LocalStorageService.getToken();
    if (token == null) {
      return null;
    }
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Giá trị status của API: ${response.statusCode}');
    print('Giá trị API trả về body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0 && data['data'] != null) {
        return Customer.fromJson(data['data']);
      } else {
        print(' Lỗi từ API: ${data['message']}');
      }
    } else {
      print(' API lỗi: ${response.statusCode}');
    }
    return null;
  }
}
