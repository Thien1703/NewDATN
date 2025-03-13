import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';

class ServiceSelection extends StatelessWidget {
  const ServiceSelection({super.key});
  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
        title: 'Chọn dịch vụ',
        body: Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListView(
                  children: [
                    _customItemService(
                        titleService: 'Khám Dịch Vụ Khu Vip',
                        calendar: 'Thứ 2, 3, 4, 5, 6',
                        price: '127.000đ'),
                    _customItemService(
                        titleService: 'Khám Thường',
                        calendar: 'Thứ 2, 3, 4, 5, 6',
                        price: '42.000đ')
                  ],
                ))));
  }
}

Widget _customItemService(
    {required String titleService,
    required String calendar,
    required String price}) {
  return InkWell(
    onTap: () {},
    child: Container(
      margin: EdgeInsets.only(top: 5, bottom: 10),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFC4C2C2), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleService,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accent)),
          SizedBox(height: 5),
          Text('Lịch khám: ${calendar}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutralBlack)),
          SizedBox(height: 5),
          Text('Giá: ${price}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutralYellow)),
        ],
      ),
    ),
  );
}
