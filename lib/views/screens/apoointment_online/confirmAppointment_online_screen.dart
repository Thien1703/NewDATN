import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointmentOnline_Create.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/views/screens/apoointment_online/payment_listener_screen.dart';
import 'package:health_care/views/screens/apoointment_online/receiveAppont_online_screen.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:intl/intl.dart';

class ConfirmappointmentOnlineScreen extends StatefulWidget {
  const ConfirmappointmentOnlineScreen({
    super.key,
    required this.clinicId,
    required this.customerId,
    this.customeProfileId = 0,
    required this.date,
    required this.time,
    this.isOnline = 1,
    required this.employeeId,
    required this.serviceIds,
  });
  final int clinicId;
  final int customerId;
  final int customeProfileId;
  final DateTime date;
  final String time;
  final int isOnline;
  final int employeeId;
  final List<int> serviceIds;

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
              // PageRouteBuilder(
              //   pageBuilder: (context, animation, secondaryAnimation) {
              //     return ConfirmappointmentOnlineScreen(); // Trang bạn muốn quay lại
              //   },
              //   transitionsBuilder:
              //       (context, animation, secondaryAnimation, child) {
              //     const begin = Offset(1.0, 0.0); // Di chuyển từ phải sang trái
              //     const end = Offset.zero; // Kết thúc tại vị trí ban đầu
              //     const curve = Curves.easeInOut; // Hiệu ứng mượt mà

              //     var tween = Tween(begin: begin, end: end)
              //         .chain(CurveTween(curve: curve));
              //     var offsetAnimation = animation.drive(tween);

              //     return SlideTransition(
              //         position: offsetAnimation, child: child);
              //   },
              // ),
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
                          children: [
                            Text('Clinic ID: ${widget.clinicId}'),
                            Text('Customer ID: ${widget.customerId}'),
                            Text(
                                'CustomerProfile ID: ${widget.customeProfileId}'),
                            Text('isOnline: ${widget.isOnline}'),
                            Text(
                                'Date: ${DateFormat('yyyy-MM-dd').format(widget.date)}'),
                            Text('Time: ${widget.time}'),
                            Text('Employee ID: ${widget.employeeId}'),
                            Text(
                                'Selected Services: ${widget.serviceIds.join(', ')}'),
                          ],
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
                  onPressed: () async {
                    final appointment = AppointmentCreateOnline(
                      clinicId: widget.clinicId,
                      customerId: widget.customerId,
                      customerProfileId: widget.customeProfileId == 0
                          ? null
                          : widget.customeProfileId,
                      date: DateFormat('yyyy-MM-dd').format(widget.date),
                      time: widget.time,
                      isOnline: widget.isOnline,
                      employeeId: widget.employeeId,
                      serviceIds: widget.serviceIds,
                    );

                    final response =
                        await AppointmentApi.getBookingOnline(appointment);

                    if (response != null) {
                      if (response.statusCode == 200) {
                        final bookingInfo =
                            response.data; // lấy ra thông tin booking
                        if (bookingInfo != null) {
                          // 👉 LẤY TOKEN TRƯỚC
                          final token =
                              await LocalStorageService.getToken() ?? '';

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đặt lịch thành công!'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // 👉 rồi mới Navigator.push
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentListenerScreen(
                                qrCode: bookingInfo.qrCode,
                                checkoutUrl: bookingInfo.checkoutUrl,
                                userId: widget.customerId,
                                jwtToken: token,
                              ),
                            ),
                          );
                        }
                      } else if (response.statusCode == 409) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dịch vụ này đã được đặt rồi!'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đặt lịch thất bại!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Không kết nối được tới máy chủ!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
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
