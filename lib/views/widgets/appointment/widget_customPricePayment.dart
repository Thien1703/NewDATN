import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class WidgetCustomPricePayment extends StatelessWidget {
  final List<Map<String, dynamic>> priceDetails;

  const WidgetCustomPricePayment({super.key, required this.priceDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: priceDetails
            .map((item) => _customRowTitleWithPrice(
                  title: item['title'],
                  price: item['price'],
                  isTitleBold: item['isBold'] ?? false,
                ))
            .toList(),
      ),
    );
  }
}

Widget _customRowTitleWithPrice({
  required String title,
  required String price,
  bool isTitleBold = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
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
