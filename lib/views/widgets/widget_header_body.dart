import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class WidgetHeaderBody extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBackPressed;
  final Widget? selectedIcon;
  final bool iconBack;
  final Color? color;
  final bool iconShare;

  const WidgetHeaderBody({
    super.key,
    required this.iconBack,
    required this.title,
    required this.body,
    this.onBackPressed,
    this.selectedIcon,
    this.color,
    this.iconShare = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              color: color ?? Colors.white,
              child: body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10, // Padding theo notch
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      color: AppColors.deepBlue,
      child: Column(
        children: [
          HeaderRow(
            iconBack: iconBack,
            title: title,
            onBackPressed: onBackPressed,
            iconShare: iconShare,
          ),
          if (selectedIcon != null) const SizedBox(height: 5),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedIcon,
          ),
        ],
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool iconBack;
  final bool iconShare;

  const HeaderRow({
    super.key,
    required this.title,
    this.onBackPressed,
    required this.iconBack,
    required this.iconShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            child: iconBack
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 24),
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                  )
                : IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.deepBlue, size: 24),
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                  ) // Khi không có icon, giữ khoảng trống
            ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          child: iconShare
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.ios_share_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                )
              : IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.ios_share_outlined,
                    color: AppColors.deepBlue,
                    size: 24,
                  ),
                ),
        )
      ],
    );
  }
}
