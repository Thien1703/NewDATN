import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_userProfile_card.dart';

class ProfileBooking extends StatefulWidget {
  final Function(
    int,
    String, {
    int? clinicId,
    List<int>? serviceIds,
    int? customerId,
    String? date, // ✅ Thêm ngày khám
    String? time, // ✅ Thêm giờ khám
    int? paymentId, // ✅ Thêm phương thức thanh toán
  }) onNavigateToScreen;

  final int clinicId;
  final List<int> selectedServiceId;
  final String date; // Thêm ngày khám
  final String time; // Thêm giờ khám
  final int paymentId;

  const ProfileBooking({
    super.key,
    required this.onNavigateToScreen,
    required this.clinicId,
    required this.selectedServiceId,
    required this.date,
    required this.time,
    this.paymentId = 1,
  });

  @override
  State<ProfileBooking> createState() => _ProfileBooking();
}

class _ProfileBooking extends State<ProfileBooking> {
  void _handleProfileTap(int customerId) {
    print("ID khách hàng: $customerId");
    print(
        "Dữ liệu nhận từ ExamInfoBooking: Clinic ID: ${widget.clinicId}, Dịch vụ: ${widget.selectedServiceId}");
    widget.onNavigateToScreen(
      2,
      'Xác nhận thông tin',
      customerId: customerId,
      clinicId: widget.clinicId,
      serviceIds: widget.selectedServiceId,
      date: widget.date,
      time: widget.time,
      paymentId: widget.paymentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          Text("Clinic ID: ${widget.clinicId}"),
          Text("Danh sách dịch vụ đã chọn:${widget.selectedServiceId}"),
          Text("Ngày khám: ${widget.date}"), // Hiển thị ngày khám
          Text("Giờ khám: ${widget.time}"), // Hiển thị giờ khám
          Text("Thanh toán: ${widget.paymentId}"),

          WidgetUserprofileCard(onTap: _handleProfileTap),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
