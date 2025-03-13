import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';

class SpecialtySelection extends StatelessWidget {
  const SpecialtySelection({super.key});
  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
        title: 'Chọn chuyên khoa',
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customSearchListItem(),
              Expanded(
                  child: ListView(
                children: [
                  _customeItemSpecialty(item: 'Đông y'),
                  _customeItemSpecialty(item: 'Can Thiệp Mạch Máu - U Gan'),
                  _customeItemSpecialty(item: 'Cơ Xương Khớp'),
                  _customeItemSpecialty(item: 'Da Liễu'),
                  _customeItemSpecialty(item: 'Gan Mật Tụy'),
                  SizedBox(height: 20),
                ],
              ))
            ],
          ),
        ));
  }
}

Widget _customeItemSpecialty({required String item}) {
  return InkWell(
    onTap: () {},
    child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC4C2C2), width: 1.5),
          borderRadius: BorderRadius.circular(7)),
      child: Text(item),
    ),
  );
}

Widget _customSearchListItem() {
  return TextField(
    decoration: InputDecoration(
        labelText: 'Tìm kiếm',
        labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.neutralGrey2),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.neutralGrey2,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.neutralGrey2, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.neutralGrey2, width: 1)),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        filled: true,
        fillColor: AppColors.grey4),
  );
}
