import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/rating/rating.dart';
import 'package:health_care/models/rating/rating_sreate.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingApi {
  static Future<RatingCreate?> writeApiRating(
    int appointmentId,
    int serviceId,
    int customerId,
    int stars,
    String? comment,
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
        }),
      );

      print('📥 API response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('status') &&
            responseBody['status'] == 0 &&
            responseBody.containsKey('data')) {
          return RatingCreate.fromJson(responseBody['data']);
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
}
