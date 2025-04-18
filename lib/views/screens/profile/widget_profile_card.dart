import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/views/screens/profile/edit_profile_another.dart';
import 'package:intl/intl.dart';

class WidgetProfileCard extends StatefulWidget {
  final Map<String, dynamic> profile;
  final Function(int customerId, int customerProfileId)? onTap;

  const WidgetProfileCard({
    super.key,
    required this.profile,
    this.onTap,
    this.onProfileUpdated,
  });

  @override
  State<WidgetProfileCard> createState() => WidgetProfileCardState();
}

class WidgetProfileCardState extends State<WidgetProfileCard> {
  bool isLoading = true;
  Map<String, dynamic>? userInfo;

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Lấy customerId và customerProfileId từ profile
        int customerProfileId = widget.profile['id'];
        int customerId = widget.profile['customerId'] ??
            customerProfileId; // Nếu không có customerId thì dùng id làm customerId

        // Kiểm tra và gọi onTap nếu có
        if (widget.onTap != null) {
          widget.onTap!(customerId, customerProfileId);
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
                titleOfImage:
                    widget.profile['customerId'].toString() ?? 'Chưa có id',
              ),
              _customRow(
                image: AppIcons.user1,
                titleOfImage: widget.profile['fullName'] ?? 'Chưa có tên',
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileAnother(
                        id: widget.profile['id'],
                        customerId: widget.profile['customerId'],
                        onProfileAdded: () {
                          // Gọi lại setState để reload sau khi cập nhật xong
                          setState(() {});
                          // 👇 Gọi callback sau khi chỉnh sửa xong
                          if (widget.onProfileUpdated != null) {
                            widget.onProfileUpdated!();
                          }
                        },
                      ),
                    ),
                  );
                },
                onDelete: () {},
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
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Image.asset(
            image,
            color: AppColors.deepBlue,
            width: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              titleOfImage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.deepBlue,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          if (onEdit != null)
            TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                minimumSize: Size(30, 30),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Icon(Icons.edit, size: 20, color: AppColors.deepBlue),
            ),
          SizedBox(width: 5),
          if (onDelete != null)
            TextButton(
              onPressed: onDelete,
              style: TextButton.styleFrom(
                minimumSize: Size(30, 30),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child:
                  Icon(Icons.delete, size: 20, color: AppColors.neutralGrey3),
            ),
        ],
      ),
    );
  }
}
