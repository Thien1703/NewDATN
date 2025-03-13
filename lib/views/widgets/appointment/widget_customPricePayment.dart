import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class WidgetCustompricepayment extends StatelessWidget {
  const WidgetCustompricepayment({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _customRowTitleWithPrice(title: 'Tiền khám', price: '127,000 VNĐ'),
        _customRowTitleWithPrice(
            title: 'Dịch vụ khám thêm', price: '300,000 VNĐ'),
        _customRowTitleWithPrice(
            title: 'Tạm tính', price: '427,000 VNĐ', isTitleBold: true),
      ],
    );
  }
}
Widget _customRowTitleWithPrice({
  required String title,
  required String price,
  bool isTitleBold = false,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isTitleBold ? FontWeight.bold : FontWeight.w500,
            color: isTitleBold
                ? AppColors.neutralDarkGreen1
                : AppColors.neutralDarkGreen2,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isTitleBold ? FontWeight.bold : FontWeight.w500,
            color: isTitleBold
                ? AppColors.neutralDarkGreen1
                : AppColors.neutralDarkGreen2,
          ),
        ),
      ],
    ),
  );
}
