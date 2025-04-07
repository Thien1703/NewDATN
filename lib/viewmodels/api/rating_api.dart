import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/rating/rating_sreate.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingApi {
  static Future<RatingCreate?> writeApiRating(
      int serviceId, int customerId, int stars, String? comment) async {
    final url = Uri.parse('${AppConfig.baseUrl}/rating/create');

    // Lấy token từ local storage
    String? token = await LocalStorageService.getToken();
    if (token == null) {
      print('Token không hợp lệ.');
      return null;
    }

    // Kiểm tra xem các tham số có hợp lệ không
    if (serviceId <= 0 || customerId <= 0 || stars < 1 || stars > 5) {
      print('Thông tin không hợp lệ.');
      return null;
    }

    // Tạo request
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "serviceId": serviceId,
          "customerId": customerId,
          "stars": stars,
          "comment": comment,
        }),
      );

      // Kiểm tra response từ server
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return RatingCreate.fromJson(responseBody['data']);
      } else {
        print('Lỗi khi gửi đánh giá: ${response.statusCode}');
        print('Chi tiết lỗi: ${response.body}');
        return null;
      }
    } catch (e) {
      // Xử lý lỗi kết nối hoặc các lỗi không mong muốn
      print('Đã xảy ra lỗi: $e');
      return null;
    }
  }
}
