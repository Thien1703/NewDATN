import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/rating/rating.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingApi {
  static Future<Rating?> writeApiRating(
    int appointmentId,
    int serviceId,
    int customerId,
    int stars,
    String? comment,
    String targetType, // Thêm parameter targetType
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}/rating/create');

    String? token = await LocalStorageService.getToken();
    if (token == null) {
      print('❌ Token không hợp lệ.');
      return null;
    }

    if (appointmentId <= 0 ||
        serviceId <= 0 ||
        customerId <= 0 ||
        stars < 1 ||
        stars > 5) {
      print('❌ Dữ liệu đầu vào không hợp lệ.');
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "appointmentId": appointmentId,
          "serviceId": serviceId,
          "customerId": customerId,
          "stars": stars,
          "comment": comment,
          "targetType": targetType, // Truyền targetType từ ngoài vào
        }),
      );

      print('📥 API response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Kiểm tra nếu trả về dữ liệu trong trường hợp thành công
        if (responseBody.containsKey('data')) {
          // Chuyển đổi dữ liệu trả về thành đối tượng Rating
          return Rating.fromJson(responseBody['data']);
        } else {
          print(
              '⚠️ Server trả lỗi: ${responseBody['message'] ?? "Không rõ lý do"}');
          return null;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi exception: $e');
      return null;
    }
  }

  static Future<Rating?> writeApiRatingDoctor(
    int appointmentId,
    int customerId,
    int stars,
    String? comment,
    String targetType, // Thêm parameter targetType
    int?
        employeeId, // employeeId có thể nullable, vì có thể không có trong trường hợp "SERVICE"
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}/rating/create');

    String? token = await LocalStorageService.getToken();
    if (token == null) {
      print('❌ Token không hợp lệ.');
      return null;
    }

    if (appointmentId <= 0 || customerId <= 0 || stars < 1 || stars > 5) {
      print('❌ Dữ liệu đầu vào không hợp lệ.');
      return null;
    }

    // Tạo body JSON với các tham số đã thay đổi
    Map<String, dynamic> body = {
      "appointmentId": appointmentId,
      "customerId": customerId,
      "stars": stars,
      "comment": comment,
      "targetType": targetType,
    };

    // Chỉ thêm employeeId nếu targetType là "DOCTOR"
    if (targetType == "DOCTOR" && employeeId != null) {
      body["employeeId"] = employeeId;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('📥 API response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Kiểm tra nếu trả về dữ liệu trong trường hợp thành công
        if (responseBody.containsKey('data')) {
          // Chuyển đổi dữ liệu trả về thành đối tượng Rating
          return Rating.fromJson(responseBody['data']);
        } else {
          print(
              '⚠️ Server trả lỗi: ${responseBody['message'] ?? "Không rõ lý do"}');
          return null;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi exception: $e');
      return null;
    }
  }

//Lấy danh sách đánh giá dịch vụ theo cuộc hẹn
  static Future<List<Rating>?> getRatingByAppointment(int appointmentId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/rating/get-by-appointment');

    String? token = await LocalStorageService.getToken();
    if (token == null) {
      print('❌ Token không hợp lệ.');
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "appointmentId": appointmentId,
        }),
      );

      print('📥 API response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Kiểm tra xem status có phải là 0 và dữ liệu có dạng List không
        if (responseBody['status'] == 0 && responseBody['data'] is List) {
          List<dynamic> data = responseBody['data'];

          // Chuyển đổi từ JSON thành danh sách các đối tượng Rating
          List<Rating> ratings =
              data.map((item) => Rating.fromJson(item)).toList();
          return ratings;
        } else {
          print('⚠️ Dữ liệu không đúng định dạng hoặc status không phải 0');
          return null;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi exception: $e');
      return null;
    }
  }

  static Future<List<Rating>?> getRatingByService(int serviceId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/rating/get-by-service');

    String? token = await LocalStorageService.getToken();
    if (token == null) {
      print('❌ Token không hợp lệ.');
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "serviceId": serviceId,
        }),
      );

      print('📥 API response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['status'] == 0 && responseBody['data'] is List) {
          List<dynamic> data = responseBody['data'];
          List<Rating> ratings =
              data.map((item) => Rating.fromJson(item)).toList();
          return ratings;
        } else {
          print('⚠️ Dữ liệu không đúng định dạng hoặc status khác 0');
          return null;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi exception: $e');
      return null;
    }
  }

  static Future<List<Rating>?> getRatingByEmployee(int employeeId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/rating/get-by-employee');

    String? token = await LocalStorageService.getToken();
    if (token == null) {
      print('❌ Token không hợp lệ.');
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "employeeId": employeeId, // ✅ Sửa đúng key
        }),
      );

      print('📥 API response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 0 && data['data'] != null) {
          List<dynamic> rawList = data['data'];
          return rawList.map((e) => Rating.fromJson(e)).toList();
        } else {
          print('⚠️ API không trả về danh sách hợp lệ.');
          return null;
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi exception: $e');
      return null;
    }
  }
}
