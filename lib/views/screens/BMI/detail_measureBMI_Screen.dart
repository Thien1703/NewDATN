import 'package:flutter/material.dart';

class DetailMeasurebmiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Chỉ Số BMI'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BMI title and description
              Text(
                'ĐO CHỈ SỐ CÂN NẶNG - CHIỀU CAO (BMI)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'BMI không được lượng trực tiếp mà có thể hình dung được, nhưng có thể đánh giá bằng BMI tương quan với độ mỡ trực tiếp. BMI là phương pháp không tìm kiếm và thực hiện khi thân thể muốn sử dụng sức khỏe.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),

              // Step 1: BMI calculator section
              Text(
                '1. Sử dụng BMI như thế nào?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'BMI được sử dụng như là một công cụ tầm soát các yếu tố sức khỏe liên quan tới trọng lượng hình hợp với chiều cao. Tuy nhiên, BMI không phải là điều hoàn hảo trong việc đánh giá các chỉ số sức khỏe, và có thể bị ảnh hưởng bởi nhiều yếu tố.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),

              // Step 2: BMI chart with images (visual representation)
              Text(
                '2. Tại sao Cơ quan kiểm soát bệnh tật Hoa Kỳ - CDC sử dụng BMI để xác định sự thay đổi cân và béo phì?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Chỉ số BMI là phương pháp phổ biến nhất để đánh giá tình trạng cân nặng và béo phì. Tuy nhiên, chỉ số này có thể không phản ánh chính xác sức khỏe vì các yếu tố như cơ bắp và mỡ cơ thể.',
                style: TextStyle(fontSize: 16),
              ),
              
              // BMI Calculation guidance section
              SizedBox(height: 24),
              Text(
                'Cách tính và đánh giá chỉ số BMI như thế nào?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Image.asset('assets/images/imagBMI.png'),
              SizedBox(height: 8),
              
              // BMI categories with icons
              Text(
                'Cách đánh giá chỉ số BMI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Đối với người lớn từ 20 tuổi trở lên, sử dụng bảng phân loại chuẩn cho cả nam và nữ để đánh giá chỉ số BMI.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              BMIClassificationList(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for BMI category widget
  Widget bmiCategoryWidget(String title, String value, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: color,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class BMIClassificationList extends StatelessWidget {
  final List<Map<String, String>> bmiCategories = [
    {'category': 'BMI < 16', 'description': 'Gầy độ III'},
    {'category': '16 ≤ BMI < 17', 'description': 'Gầy độ II'},
    {'category': '17 ≤ BMI < 18.5', 'description': 'Gầy độ I'},
    {'category': '18.5 ≤ BMI < 25', 'description': 'Bình thường'},
    {'category': '25 ≤ BMI < 30', 'description': 'Thừa cân'},
    {'category': '30 ≤ BMI < 35', 'description': 'Béo phì độ I'},
    {'category': '35 ≤ BMI < 40', 'description': 'Béo phì độ II'},
    {'category': 'BMI > 40', 'description': 'Béo phì độ III'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: bmiCategories.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.circle,
              size: 8,
              color: Colors.blue,
            ),
            SizedBox(width: 8),
            Text(
              '${bmiCategories[index]['category']} : ${bmiCategories[index]['description']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      },
    );
  }
}
