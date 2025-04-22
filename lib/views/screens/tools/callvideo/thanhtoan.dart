import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

int calculateFee(String selectedPackage) {
  final durationParts = selectedPackage.split(' ');
  final timeValue = double.tryParse(durationParts[0].replaceAll(',', '.')) ?? 0;
  return (timeValue * 2 * 100000).toInt(); // 30 phút = 100.000
}

class PaymentScreen extends StatelessWidget {
  final String doctorName;
  final String selectedPackage;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const PaymentScreen({
    super.key,
    required this.doctorName,
    required this.selectedPackage,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final formattedTime = selectedTime.format(context);
    final fee = calculateFee(selectedPackage);
    final formattedFee =
        '${fee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} VND';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Thông tin khám Online",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Khung thông tin bác sĩ và gói khám
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bác sĩ:", style: _labelStyle()),
                  Text(doctorName, style: _valueStyle()),
                  const SizedBox(height: 12),
                  Text("Gói khám:", style: _labelStyle()),
                  Text(selectedPackage, style: _valueStyle()),
                  const SizedBox(height: 12),
                  Text("Ngày khám:", style: _labelStyle()),
                  Text(formattedDate, style: _valueStyle()),
                  const SizedBox(height: 12),
                  Text("Giờ khám:", style: _labelStyle()),
                  Text(formattedTime, style: _valueStyle()),
                  const SizedBox(height: 12),
                  Text("Tổng tiền:", style: _labelStyle()),
                  Text(formattedFee,
                      style: _valueStyle().copyWith(color: Colors.red[700])),
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// Mã QR thanh toán
            // const Text(
            //   "Quét mã QR để thanh toán",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            // ),
            // const SizedBox(height: 16),
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(16),
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.black12,
            //         blurRadius: 6,
            //         offset: Offset(0, 3),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),

            // ElevatedButton.icon(
            //   onPressed: () async {
            //     final orderCode =
            //         DateTime.now().millisecondsSinceEpoch.toString();
            //     final paymentUrl = await createPaymentLink(
            //       amount: fee,
            //       description:
            //           'Thanh toán khám với bác sĩ $doctorName - $selectedPackage',
            //       orderCode: orderCode,
            //       returnUrl:
            //           'https://backend-healthcare-up0d.onrender.com/admin/success',
            //       cancelUrl:
            //           'https://backend-healthcare-up0d.onrender.com/admin/cancel',
            //     );

            //     if (paymentUrl != null) {
            //       await launchUrl(Uri.parse(paymentUrl),
            //           mode: LaunchMode.externalApplication);
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(
            //             content: Text("Không tạo được link thanh toán")),
            //       );
            //     }
            //   },
            //   icon: const Icon(Icons.payment),
            //   label: const Text("Thanh toán qua PayOS"),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),

            /// Nút hoàn tất
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cảm ơn bạn đã đặt lịch!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                "Hoàn tất",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle() => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      );

  TextStyle _valueStyle() => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );
}
