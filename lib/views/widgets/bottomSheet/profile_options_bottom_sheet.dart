import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';

class ProfileOptionsBottomSheet extends StatelessWidget {
  final VoidCallback onViewDetail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileOptionsBottomSheet({
    super.key,
    required this.onViewDetail,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Tuỳ chọn',
      body: Column(
        children: [
          _buildOptionTile(
            context,
            icon: Icons.info_outline,
            text: 'Xem chi tiết',
            onTap: onViewDetail,
          ),
          const SizedBox(height: 8),
          _buildOptionTile(
            context,
            icon: Icons.edit_note_outlined,
            text: 'Sửa hồ sơ',
            onTap: onEdit,
          ),
          const SizedBox(height: 8),
          _buildOptionTile(
            context,
            icon: Icons.delete_outlined,
            text: 'Xoá hồ sơ',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1.5, color: AppColors.grey4),
        // color: Colors.white,
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.black87),
        title: Text(
          text,
          style: TextStyle(color: textColor ?? Colors.black87),
        ),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  static void show(
    BuildContext context, {
    required VoidCallback onViewDetail,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.ghostWhite,
      builder: (context) => ProfileOptionsBottomSheet(
        onViewDetail: onViewDetail,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}
