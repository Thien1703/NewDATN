import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class WidgetCustombutton extends StatelessWidget {
  const WidgetCustombutton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false, // Thêm tham số isLoading
  });

  final VoidCallback?
      onTap; // Đổi VoidCallback thành VoidCallback? để cho phép null
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      margin: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.accent,
          side: BorderSide(color: AppColors.accent),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        onPressed: isLoading ? null : onTap, // Vô hiệu hóa nút khi đang loading
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
