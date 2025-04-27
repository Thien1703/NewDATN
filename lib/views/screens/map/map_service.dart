import 'dart:convert';
import 'package:health_care/env.dart';
import 'package:health_care/views/screens/map/mapmodel.dart';
import 'package:http/http.dart' as http;

class ClinicService {
  static bool useFakeData = true;
  // Nếu bạn muốn sử dụng dữ liệu thật từ API, hãy đặt biến này thành false
  // và đảm bảo rằng bạn đã cấu hình AppEnv.baseUrl đúng cách.
  static Future<List<MapModel>> fetchClinics() async {
    if (useFakeData) {
      return fetchClinicsFake();
    }
    // Gọi API thật
    final url = '${AppEnv.baseUrl}/api/clinics';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => MapModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load clinics');
      }
    } catch (e) {
      print('Error fetching clinics: $e');
      rethrow;
    }
  }

  // ✅ Thêm hàm fake data ngay dưới đây
  static Future<List<MapModel>> fetchClinicsFake() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      MapModel(
          id: 1,
          name: 'Phòng khám Đa Khoa FPT-Cơ sở quận 3',
          description: 'Phòng khám đa khoa chất lượng cao',
          address: '123 Đường Lê Văn Sỹ , Phường 14 , Quận 3',
          image:
              'https://www.google.com/imgres?q=ph%C3%B2ng%20kh%C3%A1m&imgurl=https%3A%2F%2Fmedia.vov.vn%2Fsites%2Fdefault%2Ffiles%2Fstyles%2Flarge%2Fpublic%2F2023-06%2F1_11.png.jpg&imgrefurl=https%3A%2F%2Fvov.vn%2Fdoanh-nghiep%2Fdoanh-nghiep-24h%2Fphong-kham-da-khoa-nam-viet-gioi-thieu-post1025485.vov&docid=mYC7minQrTSn_M&tbnid=GvLEzgy3MRrikM&vet=12ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA..i&w=667&h=467&hcb=2&ved=2ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA',
          latitude: 10.79175692757917,
          longitude: 106.67188155558836),
      MapModel(
        id: 2,
        name: 'Phòng khám Đa Khoa FPT-Cơ sở quận 1',
        description: 'Phòng khám chuyên khoa uy tín',
        address: '456 Đường Nguyễn Thị Minh Khai , Phường 6 , Quận 1',
        image:
            'https://www.google.com/imgres?q=ph%C3%B2ng%20kh%C3%A1m&imgurl=https%3A%2F%2Fmedia.vov.vn%2Fsites%2Fdefault%2Ffiles%2Fstyles%2Flarge%2Fpublic%2F2023-06%2F1_11.png.jpg&imgrefurl=https%3A%2F%2Fvov.vn%2Fdoanh-nghiep%2Fdoanh-nghiep-24h%2Fphong-kham-da-khoa-nam-viet-gioi-thieu-post1025485.vov&docid=mYC7minQrTSn_M&tbnid=GvLEzgy3MRrikM&vet=12ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA..i&w=667&h=467&hcb=2&ved=2ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA',
        latitude: 10.7686508686757,
        longitude: 106.6840997095696,
      ),
      MapModel(
        id: 3,
        name: 'Phòng khám Đa Khoa FPT-Cơ sở Quận Tân Bình',
        description: 'Phòng khám chuyên khoa uy tín',
        address: '321 Đường Hoàng Văn Thụ , Phường 4 , Quận Tân Bình    ',
        image:
            'https://www.google.com/imgres?q=ph%C3%B2ng%20kh%C3%A1m&imgurl=https%3A%2F%2Fmedia.vov.vn%2Fsites%2Fdefault%2Ffiles%2Fstyles%2Flarge%2Fpublic%2F2023-06%2F1_11.png.jpg&imgrefurl=https%3A%2F%2Fvov.vn%2Fdoanh-nghiep%2Fdoanh-nghiep-24h%2Fphong-kham-da-khoa-nam-viet-gioi-thieu-post1025485.vov&docid=mYC7minQrTSn_M&tbnid=GvLEzgy3MRrikM&vet=12ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA..i&w=667&h=467&hcb=2&ved=2ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA',
        latitude: 10.800634564959362,
        longitude: 106.661398280735,
      ),
      MapModel(
        id: 4,
        name: 'Phòng khám Đa Khoa FPT-Cơ sở Quận Phú Nhuận',
        description: 'Phòng khám chuyên khoa uy tín',
        address: '567 Đường Phan Xích Long , Phường 2 , Quận Phú Nhuận',
        image:
            'https://www.google.com/imgres?q=ph%C3%B2ng%20kh%C3%A1m&imgurl=https%3A%2F%2Fmedia.vov.vn%2Fsites%2Fdefault%2Ffiles%2Fstyles%2Flarge%2Fpublic%2F2023-06%2F1_11.png.jpg&imgrefurl=https%3A%2F%2Fvov.vn%2Fdoanh-nghiep%2Fdoanh-nghiep-24h%2Fphong-kham-da-khoa-nam-viet-gioi-thieu-post1025485.vov&docid=mYC7minQrTSn_M&tbnid=GvLEzgy3MRrikM&vet=12ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA..i&w=667&h=467&hcb=2&ved=2ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA',
        latitude: 10.801325725714275,
        longitude: 106.68370266539539,
      ),
      MapModel(
        id: 5,
        name: 'Phòng khám Đa Khoa FPT-Cơ sở quận 5',
        description: 'Phòng khám chuyên khoa uy tín',
        address: '789 Đường Trần Hưng Đạo , Phường 7 , Quận 5',
        image:
            'https://www.google.com/imgres?q=ph%C3%B2ng%20kh%C3%A1m&imgurl=https%3A%2F%2Fmedia.vov.vn%2Fsites%2Fdefault%2Ffiles%2Fstyles%2Flarge%2Fpublic%2F2023-06%2F1_11.png.jpg&imgrefurl=https%3A%2F%2Fvov.vn%2Fdoanh-nghiep%2Fdoanh-nghiep-24h%2Fphong-kham-da-khoa-nam-viet-gioi-thieu-post1025485.vov&docid=mYC7minQrTSn_M&tbnid=GvLEzgy3MRrikM&vet=12ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA..i&w=667&h=467&hcb=2&ved=2ahUKEwj4qey_m_iMAxVZyzgGHV56MpIQM3oECF4QAA',
        latitude: 10.755355356343504,
        longitude: 106.6813942114137,
      ),
    ];
  }
}
