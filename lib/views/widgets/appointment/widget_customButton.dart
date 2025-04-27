import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class WidgetCustombutton extends StatelessWidget {
  const WidgetCustombutton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false, // Thêm tham số isLoading
  });

  final VoidCallback? onTap; // Cho phép onTap null
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Nếu onTap null (tức là chưa nhập đủ), thì màu nền chuyển sang grey
    final Color bgColor = onTap == null ? Colors.grey : AppColors.deepBlue;

    return Container(
      width: double.infinity,
      height: 45,
      margin: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          side: BorderSide(color: bgColor),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        onPressed: isLoading
            ? null
            : onTap, // Nếu onTap là null, nút sẽ bị vô hiệu hóa
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
