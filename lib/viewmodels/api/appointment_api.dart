import 'package:health_care/models/appointment/appointmentOnline_Create.dart';
import 'package:health_care/models/appointment/bookingOnlineInfo.dart';
import 'package:health_care/models/appointment/statusAppointment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/appointment/appointment.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/models/appointment/appointment_Create.dart';
import 'package:intl/intl.dart';

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

  //Hủy đặt lịch
  static Future<bool?> getCancelAppointment(int appointmentId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/appointment/cancel');
    String? token = await LocalStorageService.getToken();
    if (token == null) return null;
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
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 0;
    } else {
      print("Lỗi hủy đặt lịch: ${response.body}");
    }
    return null;
  }

  // Hủy đặt lịch
  static Future<bool?> cancelAppointment(int appointmentId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/appointment/cancel');
    String? token = await LocalStorageService.getToken();
    if (token == null) return null;

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'id': appointmentId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 0;
    }
    return null;
  }

  // Kiểm tra slot trống
  static Future<Map<String, int>> fetchAvailableSlots(
      int clinicId, DateTime date) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/appointment/check-available-slots');
      String? token = await LocalStorageService.getToken();
      if (token == null) {
        print('Error: Token is null');
        return {};
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "date": DateFormat('yyyy-MM-dd').format(date),
          "clinicId": clinicId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 0 && data['data'] != null) {
          Map<String, int> availableSlots = Map<String, int>.from(data['data']);
          return availableSlots;
        }
      }

      print('API Error: ${response.statusCode} - ${response.body}');
      return {}; // Trả về danh sách trống nếu có lỗi
    } catch (e) {
      print('fetchAvailableSlots Error: $e');
      return {};
    }
  }

  //Update appointment
  static Future<bool> updateAppointment(
    int appointmentId,
    String cancelNote,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}/appointment/update-by-id');
    String? token = await LocalStorageService.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': appointmentId,
          'status': 'CANCELLED',
          'cancelNote': cancelNote,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Thành công
      } else {
        print('Lỗi: ${response.statusCode} - ${response.body}');
        return false; // Lỗi từ API
      }
    } catch (e) {
      print('Lỗi ngoại lệ: $e');
      return false; // Lỗi hệ thống
    }
  }

  //đặt lịch offline
  static Future<int?> getBooking(AppointmentCreate appointmentCreate) async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/appointment/create-with-services');
    String? token = await LocalStorageService.getToken();

    if (token == null) {
      print('Không tìm thấy token.');
      return null;
    }

    final body = json.encode(appointmentCreate.toJson());

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    print('Giá trị status code: ${response.statusCode}');
    print('Giá trị response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      if (jsonBody['status'] == 0) {
        return 0; // thành công
      } else {
        print('Lỗi từ API: ${jsonBody['message']}');
        return jsonBody['status']; // trả lỗi từ API
      }
    } else if (response.statusCode == 409) {
      return 409; // lỗi dịch vụ đã đặt rồi
    } else {
      print('API Lỗi: ${response.statusCode}');
      return null; // lỗi không xác định
    }
  }

// đặt lịch online
  static Future<ApiResponse<BookingOnlineInfo?>> getBookingOnline(
      AppointmentCreateOnline appointmentCreateOnline) async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/appointment/create-online-and-pay');
    String? token = await LocalStorageService.getToken();

    if (token == null) {
      print('❌ Không tìm thấy token.');
      return ApiResponse(statusCode: 401, message: 'Không tìm thấy token');
    }

    final body = json.encode(appointmentCreateOnline.toJson());

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('📩 Status code: ${response.statusCode}');
      print('📩 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['status'] == 0) {
          final data = jsonBody['data'];
          return ApiResponse(
            statusCode: 200,
            data: BookingOnlineInfo.fromJson(data),
          );
        } else if (jsonBody['status'] == 409) {
          // Xử lý đặt lịch trùng dịch vụ
          return ApiResponse(
            statusCode: 409,
            message: jsonBody['message'] ?? 'Bạn đã đặt lịch dịch vụ này rồi.',
          );
        } else {
          return ApiResponse(
            statusCode: 400,
            message: jsonBody['message'] ?? 'Đặt lịch thất bại',
          );
        }
      } else {
        return ApiResponse(
          statusCode: response.statusCode,
          message: 'Lỗi API: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('❌ Lỗi kết nối API: $e');
      return ApiResponse(statusCode: 500, message: 'Lỗi kết nối tới máy chủ');
    }
  }
}
