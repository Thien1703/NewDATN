import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/views/screens/appointment/create_profile_booking.dart';

class WidgetNoprofile extends StatelessWidget {
  const WidgetNoprofile({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/img_profile.png',
            width: 200,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              textAlign: TextAlign.center,
              'Hiện tại bạn chưa có hồ sơ nào,vui lòng tạo hồ sơ để tiếp tục quá trình đặt khám',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutralDarkGreen2),
            ),
          ),
          Container(
            width: 145,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    side: BorderSide(color: AppColors.accent, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateProfileBooking()));
                },
                child: Row(
                  children: [
                    Image.asset(AppIcons.addProfile),
                    SizedBox(width: 5),
                    Text(
                      'Tạo hồ sơ',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
