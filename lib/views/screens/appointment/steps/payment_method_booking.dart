import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/views/widgets/appointment/widget_hospital_info_card.dart';
import 'package:health_care/views/widgets/widget_select_item.dart';
import 'package:health_care/views/widgets/appointment/widget_customPricePayment.dart';
import 'package:health_care/views/widgets/appointment/widget_customButton.dart';
import 'package:health_care/views/widgets/widget_userProfile_card.dart';
import 'package:health_care/views/screens/home/home_screens.dart';

class PaymentMethodBooking extends StatefulWidget {
  const PaymentMethodBooking({super.key});

  @override
  State<PaymentMethodBooking> createState() => _PaymentMethodBooking();
}

class _PaymentMethodBooking extends State<PaymentMethodBooking> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: const [
                HospitalInfoWidget(
                  nameHospital: 'Bệnh viện nhân dân Gia Định',
                  addressHospital:
                      'Số 1 Nơ Trang Long, Phường 7, Quận Bình Thạnh, TpHCM',
                ),
                SectionTitle(title: 'Thông tin bệnh nhân'),
                WidgetUserprofileCard(),
                SectionTitle(title: 'Thông tin đặt khám'),
                BookingInformation(
                  text1: 'Đông Y',
                  text2: 'Khám Dịch Vụ Khu Vip',
                  text3: '03/01/2025 (08:00 - 09:00)',
                  text4: '127,000đ',
                ),
                SectionTitle(title: 'Phương thức thanh toán'),
                PaymentMethod(),
                PriceSummary(),
                TermsAndConditions(),
              ],
            ),
          ),
        ),
        BottomBar(),
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
      margin: const EdgeInsets.only(top: 10),
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

// class PatientInfo extends StatelessWidget {
//   const PatientInfo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const WidgetInfoPatient(
//       image: AppIcons.user1,
//       text: 'Nguyễn Hữu Thiện ',
//     );
//   }
// }

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
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 21,
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

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectItemWidget(
      image: AppIcons.user1,
      text: 'Chọn phương thức thanh toán',
    );
  }
}

class PriceSummary extends StatelessWidget {
  const PriceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const WidgetCustompricepayment(),
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppIcons.checkmark,
            width: 20,
            color: AppColors.accent,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Tôi đồng ý Phí tiện ích Health Care để sử dụng dịch vụ đặt khám, thanh toán viện phí, tra cứu kết quả khám và các tính năng tiện lợi khác trên nền tảng Health Care, đây không phải là dịch vụ bắt buộc bởi cơ sở y tế.',
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: WidgetCustombutton(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreens()));
        },
        text: 'Thanh toán',
      ),
    );
  }
}
