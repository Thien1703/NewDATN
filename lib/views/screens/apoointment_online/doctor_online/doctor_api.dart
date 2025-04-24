import 'dart:convert';
import 'package:health_care/models/employee.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
import 'package:http/http.dart' as http;
import 'package:health_care/config/app_config.dart';
import 'package:health_care/services/local_storage_service.dart';

class DoctorApi {
  static Future<List<Employee>> getAllOnlineDoctors() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/employee/get-all-doctor-online');
    String? token = await LocalStorageService.getToken();

    if (token == null) {
      print("❌ Không tìm thấy token");
      return [];
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 [Doctor API] Status: ${response.statusCode}');
      print('📡 [Doctor API] Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 0 && data['data'] is List) {
          List<Employee> doctors = (data['data'] as List)
              .map((item) => Employee.fromJson(item))
              .toList();
          return doctors;
        } else {
          print("❌ Lỗi từ API: ${data['message']}");
        }
      } else {
        print("❌ Lỗi HTTP: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API bác sĩ: $e");
    }

    return [];
  }
}
