import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class WidgetHeaderBody extends StatelessWidget {
  final String title;
  final Widget body;
  final double headerHeight;
  final VoidCallback? onBackPressed;
  final Widget? selectedIcon;
  final bool iconBack;

  const WidgetHeaderBody({
    super.key,
    required this.iconBack,
    required this.title,
    required this.body,
    this.headerHeight = 0.12,
    this.onBackPressed,
    this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final header = screenHeight * headerHeight;

    return Scaffold(
        body: Column(children: [
      Container(
        width: double.infinity,
        height: header,
        color: AppColors.accent,
        child: SafeArea(
            child: Column(children: [
          SizedBox(height: 15),
          HeaderRow(
            iconBack: iconBack,
            title: title,
            onBackPressed: onBackPressed,
          ),
          if (selectedIcon != null) SizedBox(height: 5),
          Container(child: selectedIcon)
        ])),
      ),
      Expanded(
          child: Container(
        color: Colors.white,
        child: body,
      ))
    ]));
  }
}

class HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool iconBack;

  const HeaderRow(
      {super.key,
      required this.title,
      this.onBackPressed,
      required this.iconBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (iconBack == true)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: AppColors.neutralWhite, size: 22),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                  color: AppColors.neutralWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
