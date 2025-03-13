import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class WidgetSelectcheckbox extends StatefulWidget {
  const WidgetSelectcheckbox({super.key});
  @override
  State<WidgetSelectcheckbox> createState() {
    return _WidgetSelectcheckbox();
  }
}

class _WidgetSelectcheckbox extends State<WidgetSelectcheckbox> {
  String? selecedOption;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            _buildCheckboxTitle(
                option: 'Option 1',
                text: 'Xét nghiệm tại nhà',
                price: 'Giá: 300.000đ'),
            _buildCheckboxTitle(
                option: 'Option 2',
                text: 'Tư vấn dinh dưỡng online',
                price: 'Giá: 200.000đ/ 30 phút tư vấn'),
            _buildCheckboxTitle(
                option: 'Option 3',
                text: 'Chăm sóc sức khỏe tại nhà',
                price: 'Giá: 400.000đ'),
          ],
        ));
  }

  CheckboxListTile _buildCheckboxTitle(
      {required String option, required String text, required String price}) {
    return CheckboxListTile(
      value: selecedOption == option,
      onChanged: (bool? value) {
        setState(() {
          selecedOption = value == true ? option : null;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.only(left: 0, right: 10),
      title: _customTextCheckBox(text: text, price: price, onTap: () {}),
    );
  }
}

Widget _customTextCheckBox(
    {required String text, required String price, required onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.neutralDarkGreen2),
          ),
          Text(
            price,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.neutralDarkGreen1),
          ),
        ],
      ),
      InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
              color: AppColors.grey4, borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Chi tiết',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.neutralBlack),
          ),
        ),
      )
    ],
  );
}
