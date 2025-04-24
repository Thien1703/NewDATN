import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';

class HeaderBottomSheet extends StatelessWidget {
  const HeaderBottomSheet({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      color: AppColors.ghostWhite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: 70,
            height: 5,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 99, 97, 97),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(AppIcons.cancel, width: 14),
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          body,
        ],
      ),
    );
  }
}
