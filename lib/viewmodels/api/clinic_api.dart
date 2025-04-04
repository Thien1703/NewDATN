import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/services/local_storage_service.dart';

class ClinicApi {
  //Lấy api của phòng khám
  static Future<List<Clinic>> getAllClinic() async {
    final url = Uri.parse('${AppConfig.baseUrl}/clinic/get-all');
    String? token = await LocalStorageService.getToken();
    if (token == null) {
      return [];
    }
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print('Giá trị status của API: ${response.statusCode}');
    print('Giá trị API trả về body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        List<Clinic> clinices = (data['data'] as List)
            .map((item) => Clinic.fromJson(item))
            .toList();
        return clinices;
      } else {
        print(' Lỗi từ API: ${data['message']}');
      }
    } else {
      print(' API lỗi: ${response.statusCode}');
    }
    return [];
  }

  //Lấy api của phòng khám theo id
  static Future<Clinic?> getClinicById(int clinicId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/clinic/get-by-id');
    String? token = await LocalStorageService.getToken();

    if (token == null) return null;

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"id": clinicId}),
    );

    print('Giá trị status của API: ${response.statusCode}');
    print('Giá trị API trả về body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 0 && data['data'] != null) {
        return Clinic.fromJson(data['data']); // Trả về một đối tượng Clinic
      } else {
        print('Lỗi từ API: ${data['message']}');
      }
    } else {
      print('API lỗi: ${response.statusCode}');
    }

    return null;
  }
}
