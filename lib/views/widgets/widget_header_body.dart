import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/profile/add_profile.dart';

class WidgetHeaderBody extends StatefulWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBackPressed;
  final Widget? selectedIcon;
  final bool iconBack;
  final Color? color;
  final bool iconAdd;
  final VoidCallback? onAddPressed;

  const WidgetHeaderBody({
    super.key,
    required this.iconBack,
    required this.title,
    required this.body,
    this.onBackPressed,
    this.selectedIcon,
    this.color,
    this.iconAdd = false,
    this.onAddPressed,
  });

  @override
  State<WidgetHeaderBody> createState() => _WidgetHeaderBodyState();
}

class _WidgetHeaderBodyState extends State<WidgetHeaderBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              color: widget.color ?? Colors.white,
              child: widget.body,
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
        top: MediaQuery.of(context).padding.top + 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      color: AppColors.deepBlue,
      child: Column(
        children: [
          HeaderRow(
            iconBack: widget.iconBack,
            title: widget.title,
            onBackPressed: widget.onBackPressed,
            onAddPressed: widget.onAddPressed,
            iconAdd: widget.iconAdd,
          ),
          if (widget.selectedIcon != null) const SizedBox(height: 5),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: widget.selectedIcon,
          ),
        ],
      ),
    );
  }
}

class HeaderRow extends StatefulWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onAddPressed;
  final bool iconBack;
  final bool iconAdd;

  const HeaderRow({
    super.key,
    required this.title,
    this.onBackPressed,
    required this.iconBack,
    required this.iconAdd,
    this.onAddPressed,
  });

  @override
  State<HeaderRow> createState() => _HeaderRowState();
}

class _HeaderRowState extends State<HeaderRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: widget.iconBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 24),
                  onPressed:
                      widget.onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: AppColors.deepBlue, size: 24),
                  onPressed:
                      widget.onBackPressed ?? () => Navigator.of(context).pop(),
                ),
        ),
        Expanded(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Flexible(
          child: widget.iconAdd
              ? IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProfile(),
                      ),
                    );
                    if (widget.onAddPressed != null) {
                      widget
                          .onAddPressed!(); // 👈 gọi lại hàm ở PatientProfiles
                    }
                  },
                  icon: const Icon(
                    Icons.group_add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
