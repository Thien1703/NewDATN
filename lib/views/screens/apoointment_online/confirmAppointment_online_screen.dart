import 'dart:math';
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/widget_customerPainted.dart';

class ConfirmappointmentOnlineScreen extends StatefulWidget {
  const ConfirmappointmentOnlineScreen({super.key});

  @override
  State<ConfirmappointmentOnlineScreen> createState() =>
      _ConfirmappointmentOnlineScreenState();
}

class _ConfirmappointmentOnlineScreenState
    extends State<ConfirmappointmentOnlineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ConfirmappointmentOnlineScreen(); // Trang bạn muốn quay lại
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // Di chuyển từ phải sang trái
                  const end = Offset.zero; // Kết thúc tại vị trí ban đầu
                  const curve = Curves.easeInOut; // Hiệu ứng mượt mà

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Đặt lịch khám'),
        centerTitle: true,
        backgroundColor: AppColors.deepBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: AppColors.ghostWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTItleRow('1', 'Chọn lịch khám', Colors.green, true),
                    _buildTItleRow('2', 'Xác nhận', AppColors.deepBlue, true),
                    _buildTItleRow('3', 'Nhận lịch hẹn', Colors.grey, false),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 237, 172),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        child: Row(
                          children: [
                            Container(
                              height: 70,
                              width: 4,
                              color: Colors.red,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                'Hãy kiểm tra các thông tin trước khi xác nhận. Nếu bạn cần hộ trợ, vui lòng chat với CSKH hoặc liên hệ tổng đài',
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTitle('THÔNG TIN ĐĂNG KÝ'),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [Row()],
                        ),
                      ),
                    ]),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Xác nhận đặt lịch",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String value) {
    return Padding(
        padding: EdgeInsets.only(left: 35, top: 5, bottom: 5),
        child: Text(
          value,
          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
        ));
  }

  Widget _buildTItleRow(String value, String label, Color colors, bool icon) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: colors,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: colors,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 5),
        icon == true
            ? Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: const Color.fromARGB(255, 136, 136, 136),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
