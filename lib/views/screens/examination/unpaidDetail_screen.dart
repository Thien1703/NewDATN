import 'package:flutter/material.dart';
import 'package:health_care/common/app_icons.dart';
import 'dart:async';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';

class UnPaidDetailScreen extends StatefulWidget {
  const UnPaidDetailScreen({super.key});
  @override
  State<UnPaidDetailScreen> createState() => _UnPaidDetailScreen();
}

class _UnPaidDetailScreen extends State<UnPaidDetailScreen> {
  late Timer _timer;
  int _remainingTime = 3600; // Thời gian đếm ngược (giây)

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes : $secs';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
        iconBack: true,
        title: 'Thông tin phiếu khám',
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Thanh toán bằng VIETQR không thành công',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Thời gian thanh toán còn lại',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _formatTime(_remainingTime),
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Image.asset(
                      AppIcons.creditCard,
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mã đặt lịch',
                            style: TextStyle(
                                fontSize: 19,
                                color: const Color.fromARGB(134, 148, 140, 140),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '4F450TY',
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 17),
                      width: 160,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Center(
                        child: Text(
                          'Chưa thanh toán',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    WidgetLineBold(),
                    SizedBox(height: 15),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors
                              .black54, // Định dạng chung cho toàn bộ văn bản
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Quý khách vừa thực hiện thanh toán VIETQR cho mã đặt lịch: ',
                          ),
                          TextSpan(
                            text: '4F450TY', // Phần văn bản cần nổi bật
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black, // Màu đen đậm
                            ),
                          ),
                          TextSpan(
                              text:
                                  ', giao dịch thất bại. STT dự kiến của bạn là 50. ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              )),
                        ],
                      ),
                    ),
                    Text(
                      'Để giữ STT này vui lòng hoàn tất thanh toán trong thời gian quy định.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(double.infinity,
                            50), // Chiếm toàn bộ chiều ngang và chiều cao là 50
                      ),
                      child: Text(
                        'Thanh toán lại',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

// Widget _customDashedLine() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: List.generate(23, (index) {
//       return Container(
//         margin: EdgeInsets.symmetric(vertical: 15),
//         width: 7,
//         height: 1.5,
//         color: AppColors.grey4,
//       );
//     }),
//   );
// }
