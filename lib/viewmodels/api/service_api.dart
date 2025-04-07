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

  //Lấy api của dịch vụ theo id dịch vụ
  static Future<List<Service>?> getServiceByIds(List<int> serviceIds) async {
    final url = Uri.parse('${AppConfig.baseUrl}/service/get-by-ids');
    String? token = await LocalStorageService.getToken();

    if (token == null) {
      print("❌ Lỗi: Không tìm thấy token");
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"id": serviceIds}),
      );

      print("📌 API Response Status: ${response.statusCode}");
      print("📌 API Response Headers: ${response.headers}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Không ép về UTF-8

        if (data is List) {
          print("✅ API trả về danh sách dịch vụ hợp lệ.");
          return data.map((item) => Service.fromJson(item)).toList();
        } else {
          print("❌ API trả về dữ liệu không hợp lệ: $data");
        }
      } else {
        print("❌ Lỗi API: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API: $e");
    }

    return null;
  }

// Lấy API của dịch vụ theo id dịch vụ (chỉ 1 ID dịch vụ)
  static Future<Service?> getServiceById(int serviceId) async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/service/get-by-id'); // Giả sử bạn có endpoint này
    String? token = await LocalStorageService.getToken();

    if (token == null) {
      print("❌ Lỗi: Không tìm thấy token");
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"id": serviceId}), // Gửi ID dịch vụ duy nhất
      );

      print("📌 API Response Status: ${response.statusCode}");
      print("📌 API Response Headers: ${response.headers}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Không ép về UTF-8

        if (data is Map<String, dynamic> && data['status'] == 0) {
          // Kiểm tra nếu API trả về dữ liệu hợp lệ
          print("✅ API trả về dịch vụ hợp lệ.");

          // Lấy trường 'data' chứa thông tin dịch vụ và chuyển thành đối tượng Service
          var serviceData = data['data'];
          if (serviceData != null && serviceData is Map<String, dynamic>) {
            return Service.fromJson(
                serviceData); // Chuyển đổi dữ liệu thành đối tượng Service
          } else {
            print("❌ Dữ liệu dịch vụ không hợp lệ: $serviceData");
          }
        } else {
          print("❌ Lỗi từ API: ${data['message']}");
        }
      } else {
        print("❌ Lỗi API: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API: $e");
    }

    return null;
  }
}
