import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/views/widgets/appointment/widget_hospital_info_card.dart';
import 'package:health_care/views/widgets/appointment/widget_customPricePayment.dart';
import 'package:health_care/views/widgets/appointment/widget_customButton.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';
import 'package:health_care/views/widgets/widget_userProfile_card.dart';
import 'package:health_care/models/appointment/appointment.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/models/appointment/appointmentCreate.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';

class ConfirmBooking extends StatefulWidget {
  const ConfirmBooking({
    super.key,
    required this.onNavigateToScreen,
    required this.customerId,
    required this.clinicId,
    required this.selectedServiceIds,
    required this.date,
    required this.time,
    required this.paymentId,
  });

  final Function(int, String) onNavigateToScreen;
  final int customerId;
  final int clinicId;
  final List<int> selectedServiceIds;
  final String date;
  final String time;
  final int paymentId;

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  bool isLoading = false;

  Future<void> _bookAppointment() async {
    setState(() => isLoading = true);

    // Gửi yêu cầu tạo lịch hẹn
    Appointment newBooking = Appointment(
      id: 0,
      clinicId: widget.clinicId,
      customerId: widget.customerId,
      date: widget.date,
      time: widget.time,
      status: "pending",
      paymentId: widget.paymentId,
    );

    int? appointmentId = await AppointmentApi.createAppointment(newBooking);

    if (appointmentId == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Đặt lịch thất bại, vui lòng thử lại!")),
      );
      return;
    }
    print("✅ Đã tạo lịch hẹn với ID: $appointmentId");

    // Gửi yêu cầu thêm dịch vụ vào lịch hẹn
    bool serviceAdded = await AppointmentserviceApi.addServicesToAppointment(
      appointmentId,
      widget.selectedServiceIds,
    );

    setState(() => isLoading = false);

    if (serviceAdded) {
      widget.onNavigateToScreen(3, 'Thông tin thanh toán');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("❌ Thêm dịch vụ thất bại, vui lòng thử lại!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Text('Customer ID: ${widget.customerId}'),
                Text("Clinic ID: ${widget.clinicId}"),
                Text("Dịch vụ đã chọn: ${widget.selectedServiceIds}"),
                Text("Ngày khám: ${widget.date}"),
                Text("Giờ khám: ${widget.time}"),
                Text("Thanh toán: ${widget.paymentId}"),
                const HospitalInfoWidget(
                  nameHospital: 'Bệnh viện nhân dân Gia Định',
                  addressHospital:
                      'Số 1 Nơ Trang Long, P.7, Q.Bình Thạnh, Tp.HCM',
                ),
                const SectionTitle(title: 'Thông tin bệnh nhân'),
                const WidgetUserprofileCard(),
                const SectionTitle(title: 'Thông tin đặt khám'),
                BookingInformation(
                  text1: 'Đông Y',
                  text2: 'Khám Dịch Vụ Khu Vip',
                  text3: '${widget.date} (${widget.time})',
                  text4: '127,000đ',
                ),
                const WidgetLineBold(),
                const CancellationNotice(),
              ],
            ),
          ),
        ),
        BottomBar(
          onContinue: isLoading ? null : _bookAppointment,
          isLoading: isLoading,
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.neutralDarkGreen1,
        ),
      ),
    );
  }
}

class BookingInformation extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final String text4;

  const BookingInformation({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          BookingInfoRow(image: AppIcons.specialty, text: text1),
          BookingInfoRow(image: AppIcons.service2, text: text2),
          BookingInfoRow(image: AppIcons.calendar, text: text3),
          BookingInfoRow(
              image: AppIcons.payment, text: text4, isTextBlack: true),
        ],
      ),
    );
  }
}

class BookingInfoRow extends StatelessWidget {
  final String image;
  final String text;
  final bool isTextBlack;

  const BookingInfoRow({
    super.key,
    required this.image,
    required this.text,
    this.isTextBlack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 23,
            color: AppColors.accent,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: isTextBlack ? 17 : 16,
              fontWeight: isTextBlack ? FontWeight.w700 : FontWeight.w500,
              color: isTextBlack ? Colors.black : AppColors.neutralDarkGreen2,
            ),
          ),
        ],
      ),
    );
  }
}

class CancellationNotice extends StatelessWidget {
  const CancellationNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 238, 206, 203),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.priority_high_rounded,
              color: Color.fromARGB(255, 216, 93, 84)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Trong thời gian quy định, nếu quý khách hủy phiếu khám sẽ được hoàn lại tiền khám và các dịch vụ đặt thêm (không bao gồm phí tiện ích)',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 216, 93, 84),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final VoidCallback? onContinue;
  final bool isLoading;

  const BottomBar(
      {super.key, required this.onContinue, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: WidgetCustompricepayment(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: WidgetCustombutton(
              onTap: onContinue,
              text: isLoading ? 'Đang xử lý...' : 'Tiếp tục',
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}
