import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'dart:math' as math;

class SelectItemWidget extends StatelessWidget {
  const SelectItemWidget({
    super.key,
    required this.image,
    required this.text,
    this.bottomSheet,
    this.onTap,
  });
  final String image;
  final String text;
  final Widget? bottomSheet;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else if (bottomSheet != null) {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: bottomSheet!,
                    ),
                  ),
                );
              });
        }
      },
      child: Container(
          width: double.infinity,
          height: 55,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Transform(
                    transform: Matrix4.rotationY(math.pi),
                    alignment: Alignment.center,
                    child: Image.asset(image, width: 20),
                  ),
                  SizedBox(width: 10),
                  Text(text,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutralGrey3,
                      )),
                ],
              ),
              Icon(Icons.keyboard_arrow_right_outlined)
            ],
          )),
    );
  }
}
