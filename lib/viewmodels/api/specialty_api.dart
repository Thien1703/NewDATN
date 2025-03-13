import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health_care/viewmodels/api/api_service.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/services/local_storage_service.dart';

class SpecialtyApi {
  //Lấy api của chuyên khoa
  static Future<List<Specialty>?> getAllSpecialty() async {
    final url = Uri.parse('${ApiService.baseUrl}/specialty/get-all');

    String? token = await LocalStorageService.getToken();
    if (token == null) {
      return null;
    }
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Giá trị status của API: ${response.statusCode}');
    print('Giá trị API trả về body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        List<Specialty> specialties = (data['data'] as List)
            .map((item) => Specialty.fromJson(item))
            .toList();
        return specialties;
      } else {
        print(' Lỗi từ API: ${data['message']}');
      }
    } else {
      print(' API lỗi: ${response.statusCode}');
    }

    return null;
  }

  //Lấy api của chuyên khoa theo id
  static Future<Specialty?> getSpecialtyById(int specialtyId) async {
    final url = Uri.parse('${ApiService.baseUrl}/specialty/get-by_id');

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
        'id': specialtyId,
      }),
    );

    print('Giá trị status của API: ${response.statusCode}');
    print('Giá trị API trả về body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0 && data['data'] != null) {
        return Specialty.fromJson(data['data']);
      } else {
        print(' Lỗi từ API: ${data['message']}');
      }
    } else {
      print(' API lỗi: ${response.statusCode}');
    }

    return null;
  }
}
