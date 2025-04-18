import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/views/screens/profile/editProfile_screen.dart';
import 'package:intl/intl.dart';

class WidgetCustomerinforCard extends StatefulWidget {
  final Function()? onProfileUpdated;
  final Function(int)? onTap;
  const WidgetCustomerinforCard({super.key, this.onTap, this.onProfileUpdated});

  @override
  WidgetCustomerinforCardState createState() => WidgetCustomerinforCardState();
}

class WidgetCustomerinforCardState extends State<WidgetCustomerinforCard> {
  Map<String, dynamic>? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() => isLoading = true); // Hiển thị loading khi lấy dữ liệu
    final data = await AppConfig.getUserProfile(); // Lấy dữ liệu mới
    if (mounted) {
      setState(() {
        userInfo = data;
        isLoading = false;
      });
    }
  }

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Thẻ Card chứa thông tin người dùng
        InkWell(
          onTap: () {
            if (userInfo != null && userInfo!['id'] != null) {
              int customerId = userInfo!['id'];
              if (widget.onTap != null) {
                widget.onTap!(customerId);
              }
            }
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : userInfo == null
                      ? Center(child: Text("Không có dữ liệu"))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _customRow(
                              image: AppIcons.user1,
                              titleOfImage:
                                  userInfo!['fullName'] ?? 'Chưa có tên',
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                      onProfileUpdated: () {
                                        fetchUserProfile();
                                        if (widget.onProfileUpdated != null) {
                                          widget
                                              .onProfileUpdated!(); // ✅ gọi callback về ProfileBooking
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            _customRow(
                              image: AppIcons.call,
                              titleOfImage:
                                  userInfo!['phoneNumber'] ?? 'Chưa có SĐT',
                            ),
                            _customRow(
                                image: AppIcons.calendar,
                                titleOfImage:
                                    formatBirthDate(userInfo!['birthDate'])),
                            _customRow(
                                image: AppIcons.location,
                                titleOfImage:
                                    userInfo!['address'] ?? 'Chưa có địa chỉ'),
                          ],
                        ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _customRow({
  required String image,
  required String titleOfImage,
  VoidCallback? onEdit,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        Image.asset(
          image,
          color: AppColors.deepBlue,
          width: 25,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            titleOfImage,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.deepBlue),
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
        SizedBox(width: 10),
      ],
    ),
  );
}
