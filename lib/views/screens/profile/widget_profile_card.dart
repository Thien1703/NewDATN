import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:intl/intl.dart';

class WidgetProfileCard extends StatefulWidget {
  final Map<String, dynamic> profile;
  final Function(int)? onTap;

  const WidgetProfileCard({
    super.key,
    required this.profile,
    this.onTap,
  });

  @override
  State<WidgetProfileCard> createState() => _WidgetProfileCardState();
}

class _WidgetProfileCardState extends State<WidgetProfileCard> {
  String formatBirthDate(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return 'Chưa có ngày sinh';
    try {
      DateTime dateTime = DateTime.parse(birthDate);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return 'Sai định dạng';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.profile['id'] != null) {
          int customerId = widget.profile['id'];
          if (widget.onTap != null) {
            widget.onTap!(customerId);
          }
        }
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customRow(
                image: AppIcons.user1,
                titleOfImage: widget.profile['fullName'] ?? 'Chưa có tên',
              ),
              _customRow(
                image: AppIcons.call,
                titleOfImage: widget.profile['phoneNumber'] ?? 'Chưa có SĐT',
              ),
              _customRow(
                image: AppIcons.calendar,
                titleOfImage: formatBirthDate(widget.profile['birthDate']),
              ),
              _customRow(
                image: AppIcons.location,
                titleOfImage: widget.profile['address'] ?? 'Chưa có địa chỉ',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customRow({
    required String image,
    required String titleOfImage,
    VoidCallback? onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                image,
                color: AppColors.deepBlue,
                width: 25,
              ),
              const SizedBox(width: 10),
              Text(
                titleOfImage,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.deepBlue,
                ),
              ),
            ],
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.add, size: 18, color: AppColors.deepBlue),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
