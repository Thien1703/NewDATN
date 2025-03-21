import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';

class PaidDetailScreen extends StatefulWidget {
  @override
  State<PaidDetailScreen> createState() => _PaidDetailScreen();
}

class _PaidDetailScreen extends State<PaidDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Phiếu khám',
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100.0, left: 16.0, right: 16.0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Phòng khám Hello Doctor',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(27.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text('STT', style: TextStyle(fontSize: 27)),
                                  Text('1', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.green)),
                                ],
                              ),
                              SizedBox(width: 20),
                              Image.asset('assets/images/qr.png'),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                          decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                                child: Icon(Icons.close, color: Colors.white, size: 12),
                              ),
                              SizedBox(width: 10),
                              Text('Đã hủy', style: TextStyle(fontSize: 13, color: Colors.orange, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Đã hủy. Lịch khám đã được hủy bởi Bạn. Để được hỗ trợ vui lòng liên hệ ', style: TextStyle(fontSize: 16, color: Colors.orange)),
                              TextSpan(text: '1900-2805', style: TextStyle(fontSize: 16, color: Colors.blue)),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 20),
                        WidgetLineBold(),
                        SizedBox(height: 10),
                        _buildDetailsRow('Mã phiếu khám', 'YMA2412270986'),
                        _buildDetailsRow('Ngày khám', '30/12/2024'),
                        _buildDetailsRow('Giờ đăng ký khám', '09:00-12:00 (Buổi sáng)'),
                        _buildDetailsRow('Giờ khám dự kiến', '09:00', Colors.green),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Thông tin bệnh nhân', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Card(
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailsRow('Mã bệnh nhân', 'YMP242046970', AppColors.deepBlue),
                        _buildDetailsRow('Họ và tên', 'Lê Văn Dũng'),
                        _buildDetailsRow('Số điện thoại', '0979591276'),
                        WidgetLineBold(),
                        Center(
                          child: Text(
                            'Chi tiết',
                            style: TextStyle(fontSize: 16, color: AppColors.deepBlue),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Thông tin đăng ký khám', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Card(
                  elevation: 5,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phòng khám Hello Doctor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Image.asset('assets/images/logoApp.png', width: 40, height: 40, fit: BoxFit.contain),
                          ],
                        ),
                        SizedBox(height: 20),
                        WidgetLineBold(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Chi nhánh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Chi nhánh 1', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Tổng đài hỗ trợ chăm sóc khách hàng', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('1900-2805', style: TextStyle(fontSize: 16, color: AppColors.deepBlue)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          // Fixed Positioned Button
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: Container(
             
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Đặt lịch khám khác',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow(String label, String value, [Color textColor = Colors.black]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(value, style: TextStyle(fontSize: 16, color: textColor)),
      ],
    );
  }
}
