import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/services/local_storage_service.dart';

class ServiceApi {
  //Lấy api của dịch vụ theo id Chuyên khoa
  static Future<List<Service>> getAllServeById(int specialtyId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/service/get-by-specialty');
    String? token = await LocalStorageService.getToken();
    if (token == null) {
      return [];
    }
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "specialtyId": specialtyId,
      }),
    );
    print('Giá trị status của API: ${response.statusCode}');
    print('Giá trị API trả về body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        List<Service> services = (data['data'] as List)
            .map((item) => Service.fromJson(item))
            .toList();
        return services;
      } else {
        print(' Lỗi từ API: ${data['message']}');
      }
    } else {
      print(' API lỗi: ${response.statusCode}');
    }
    return [];
  }

  //Lấy tất cả dịch vụ
  static Future<List<Service>?> getAllServe() async {
    final url = Uri.parse('${AppConfig.baseUrl}/service/get-all');
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
      if (data['status'] == 0) {
        List<Service> services = (data['data'] as List)
            .map((item) => Service.fromJson(item))
            .toList();
        return services;
      } else {
        print(' Lỗi từ API: ${data['message']}');
      }
    } else {
      print(' API lỗi: ${response.statusCode}');
    }
    return null;
  }
}
