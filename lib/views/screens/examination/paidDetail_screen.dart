import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaidDetailScreen extends StatefulWidget {
  const PaidDetailScreen({super.key, required this.appointmentServiceId});
  final int appointmentServiceId;
  @override
  State<PaidDetailScreen> createState() => _PaidDetailScreen();
}

class _PaidDetailScreen extends State<PaidDetailScreen> {
  final String data = 'fsfsfdsfsdf';
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Thông tin phiếu khám',
      color: Color(0xFFF0F2F5),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.0, left: 14.0, right: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            'Phòng khám Hello Doctor',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('STT', style: TextStyle(fontSize: 17)),
                                  Text(
                                    '1',
                                    style: TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              QrImageView(
                                data: data,
                                size: 110,
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 193, 225, 194),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                                child: Icon(Icons.close,
                                    color: Colors.white, size: 10),
                              ),
                              SizedBox(width: 10),
                              Text('Đã đặt khám',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      'Đã hủy. Lịch khám đã được hủy bởi Bạn. Để được hỗ trợ vui lòng liên hệ ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: ' 1900 - 2805',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.blue)),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        ),
                        WidgetLineBold(),
                        _buildDetailsRow('Mã phiếu khám', 'YMA2412270986'),
                        _buildDetailsRow('Ngày khám', '30/12/2024'),
                        _buildDetailsRow(
                            'Giờ đăng ký khám', '09:00-12:00 (Buổi sáng)'),
                        _buildDetailsRow(
                            'Giờ khám dự kiến', '09:00', Colors.green),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text('Thông tin bệnh nhân',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 5),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailsRow(
                            'Mã bệnh nhân', 'YMP242046970', AppColors.deepBlue),
                        _buildDetailsRow('Họ và tên', 'Lê Văn Dũng'),
                        _buildDetailsRow('Số điện thoại', '0979591276'),
                        WidgetLineBold(),
                        Center(
                          child: Text(
                            'Chi tiết',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.deepBlue,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Thông tin đăng ký khám',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 5,
                ),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phòng khám Hello Doctor',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Image.asset(
                              'assets/images/logoApp.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        WidgetLineBold(),
                        SizedBox(height: 10),
                        _buildDetailsRow('Chi nhánh', 'Chi nhánh 1'),
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
                      Text('Tổng đài hỗ trợ chăm sóc khách hàng',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 76, 76, 76),
                          )),
                      Text('1900-2805',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.deepBlue,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 17),
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow(String label, String value,
      [Color textColor = Colors.black]) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14, color: Color.fromARGB(255, 76, 76, 76))),
          Text(value,
              style: TextStyle(
                  fontSize: 15, color: textColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
