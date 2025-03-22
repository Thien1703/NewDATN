import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class WidgetHeaderBody extends StatelessWidget {
  final String title;
  final Widget body;
  final double headerHeight;
  final VoidCallback? onBackPressed;
  final Widget? selectedIcon;
  final bool iconBack;
  final Color? color;

  const WidgetHeaderBody({
    super.key,
    required this.iconBack,
    required this.title,
    required this.body,
    this.headerHeight = 0.12,
    this.onBackPressed,
    this.selectedIcon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final header = screenHeight * headerHeight;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(header, context),
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

  Widget _buildHeader(double headerHeight, BuildContext context) {
    return Container(
      width: double.infinity,
      height: headerHeight,
      color: AppColors.deepBlue,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            HeaderRow(
              iconBack: iconBack,
              title: title,
              onBackPressed: onBackPressed,
            ),
            if (selectedIcon != null) const SizedBox(height: 5),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: selectedIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool iconBack;

  const HeaderRow({
    super.key,
    required this.title,
    this.onBackPressed,
    required this.iconBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (iconBack)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.neutralWhite, size: 22),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.neutralWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
