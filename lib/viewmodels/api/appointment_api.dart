import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health_care/viewmodels/api/api_service.dart';
import 'package:health_care/models/appointment/appointment.dart';
import 'package:health_care/services/local_storage_service.dart';

class AppointmentApi {
  //Lấy tất cả đặt lịch
  static Future<List<Appointment>?> getAllAppointment() async {
    final url = Uri.parse('${ApiService.baseUrl}/appointment/get-all');
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
    final url = Uri.parse('${ApiService.baseUrl}/appointment/get-by-id');
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

  // Đặt lịch
  static Future<int?> createAppointment(Appointment appointment) async {
    final url = Uri.parse('${ApiService.baseUrl}/appointment/create');
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
        body: jsonEncode(appointment.toJson()),
      );

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
