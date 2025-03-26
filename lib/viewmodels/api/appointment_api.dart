import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/views/screens/appointment/appointment_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/appointment/appointment.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/models/appointment/appointment_Create.dart';

class AppointmentApi {
  //Lấy tất cả đặt lịch
  static Future<List<Appointment>?> getAllAppointment() async {
    final url = Uri.parse('${AppConfig.baseUrl}/appointment/get-all');
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
    print('Giá trị status apptoinment: ${response.statusCode}');
    print('Giá trị api apptoinment: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] is List) {
        List<Appointment> apptoinments = (data['data'] as List)
            .map((item) => Appointment.fromJson(item))
            .toList();
        return apptoinments;
      } else {
        print('Lỗi Api:${data['message']}');
      }
    } else {
      print('Api Lỗi: ${response.statusCode}');
    }
    return null;
  }

  //Xem đặt lịch theo id
  static Future<Appointment?> getAppointmentById(int appointmentId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/appointment/get-by-id');
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
      body: jsonEncode({
        'id': appointmentId,
      }),
    );
    print('Giá trị status apptoinment: ${response.statusCode}');
    print('Giá trị api apptoinment: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null && data['data'] is Map) {
        return Appointment.fromJson(data['data']);
      } else {
        print('Lỗi Api:${data['message']}');
      }
    } else {
      print('Api Lỗi: ${response.statusCode}');
    }
    return null;
  }

  //Xem dặt lịch theo customer ID
  static Future<List<Appointment>?> getAppointmentByCus(int customerId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/appointment/get-by-customer');
      String? token = await LocalStorageService.getToken();
      if (token == null) {
        return null;
      }

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'customerId': customerId,
          }));

      print('📢 API Response Status: ${response.statusCode}');
      print('📢 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['data'] is List) {
          return (data['data'] as List)
              .map((item) => Appointment.fromJson(item))
              .toList();
        } else {
          print('⚠ Dữ liệu API không hợp lệ: "data" không phải danh sách');
        }
      } else {
        print('⚠ Dữ liệu API không có key "data"');
      }
    } catch (e) {
      print('🚨 Lỗi khi gọi API: $e');
    }
    return null;
  }

  // Đặt lịch
  static Future<int?> createAppointment(
      AppointmentCreate AppointmentCreate) async {
    final url = Uri.parse('${AppConfig.baseUrl}/appointment/create');
    String? token = await LocalStorageService.getToken();

    if (token == null) {
      print("❌ Không tìm thấy token!");
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(AppointmentCreate.toJson()),
      );
      print(
          "📤 Dữ liệu gửi lên APIz: ${jsonEncode(AppointmentCreate.toJson())}");

      print('📩 Phản hồi API (Đặt lịch): ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 0) {
          int appointmentId =
              data['data']['id']; // Giả sử API trả về { "data": { "id": 123 } }
          return appointmentId;
        } else {
          print("❌ Lỗi API: ${data['message']}");
        }
      } else {
        print("❌ API trả về lỗi: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠ Lỗi hệ thống: $e");
    }
    return null; // Nếu có lỗi, trả về null
  }
}
