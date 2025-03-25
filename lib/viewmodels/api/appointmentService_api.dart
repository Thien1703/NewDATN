import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/models/appointment/appointmentService_Create.dart';

class AppointmentserviceApi {
  static Future<List<AppointmentService>?> getAllAppointmentService() async {
    final url = Uri.parse('${AppConfig.baseUrl}/appointment-service/get-all');
    String? token = await LocalStorageService.getToken();

    if (token == null) {
      print("Lỗi: Không tìm thấy token!");
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status code get-all-appointment-service: ${response.statusCode}');
      print('Response get-all-appointment-service: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Kiểm tra nếu 'data' tồn tại và là danh sách hợp lệ
        if (data.containsKey('data') && data['data'] != null) {
          if (data['data'] is List) {
            return (data['data'] as List)
                .map((item) => AppointmentService.fromJson(item))
                .toList();
          } else {
            print("Lỗi API: 'data' không phải là danh sách!");
          }
        } else {
          print("Lỗi API: Không có dữ liệu hợp lệ.");
        }
      } else {
        print("Lỗi API: Status ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      print("Lỗi ngoại lệ khi gọi API: $e");
    }

    return [];
  }

  //đặt lịch
  static Future<bool> addServicesToAppointment(
      int appointmentId, List<int> serviceIds) async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/appointment-service/create-multiple');
    String? token = await LocalStorageService.getToken();

    if (token == null) {
      print("❌ Lỗi: Không tìm thấy token");
      return false;
    }

    // Tạo object từ model
    AddServiceRequest request = AddServiceRequest(
      appointmentId: appointmentId,
      serviceIds: serviceIds,
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      print('📤 Gửi yêu cầu thêm dịch vụ: ${jsonEncode(request.toJson())}');
      print('📩 Phản hồi API: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 0) {
          print("✅ Thêm dịch vụ thành công!");
          return true;
        } else {
          print("❌ Lỗi API: ${data['message']}");
        }
      } else {
        print("❌ API trả về lỗi: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠ Lỗi hệ thống: $e");
    }
    return false;
  }

  static Future<List<AppointmentService>?> getAppointmentServiceByCus(
      int customerId) async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/appointment-service/get-by-customer');
    String? token = await LocalStorageService.getToken();
    if (token == null) return null;

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'customerId': customerId,
          }));

      print('Status code get-all-appointment-service: ${response.statusCode}');
      print('Response get-all-appointment-service: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] is List) {
          return (data['data'] as List)
              .map((item) => AppointmentService.fromJson(item))
              .toList();
        } else {
          print('⚠ Dữ liệu API không hợp lệ');
        }
      } else {
        print('⚠ Lỗi API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("⚠ Lỗi hệ thống: $e");
    }
    return null;
  }

  static Future<AppointmentService?> getAppointmentService(int id) async {
    final url = Uri.parse('${AppConfig.baseUrl}/appointment-service/get-by-id');
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
      body: jsonEncode(
        {'id': id},
      ),
    );
    print('Status code get-all-appointment-service: ${response.statusCode}');
    print('Response get-all-appointment-service: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0 && data['data'] != null) {
        return AppointmentService.fromJson(data['data']);
      } else {
        print(' Lỗi từ API: ${data['message']}');
      }
    } else {
      print(' API lỗi: ${response.statusCode}');
    }
    return null;
  }

  static Future<List<AppointmentService>> getByAppointment(
      int appointmentId) async {
    try {
      String? token = await LocalStorageService.getToken();
      if (token == null) throw Exception("Token không tồn tại");

      final response = await http.post(
        Uri.parse(
            "${AppConfig.baseUrl}/appointment-service/get-by-appointment"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'appointmentId': appointmentId}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is List) {
          return (responseData['data'] as List)
              .map((e) => AppointmentService.fromJson(e))
              .toList();
        } else {
          throw Exception("Dữ liệu API không đúng định dạng");
        }
      } else {
        throw Exception("Lỗi lấy dữ liệu: ${response.statusCode}");
      }
    } catch (e) {
      print("❗ Lỗi API: $e");
      return [];
    }
  }
}
