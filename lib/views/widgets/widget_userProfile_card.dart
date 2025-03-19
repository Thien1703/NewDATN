import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/views/screens/profile/editProfile_screen.dart';
import 'package:intl/intl.dart';

class WidgetUserprofileCard extends StatefulWidget {
  final Function(int)? onTap;
  final Function()? onEdit; // Thêm callback chỉnh sửa

  const WidgetUserprofileCard({super.key, this.onTap, this.onEdit});

  @override
  _WidgetUserprofileCardState createState() => _WidgetUserprofileCardState();
}

class _WidgetUserprofileCardState extends State<WidgetUserprofileCard> {
  Map<String, dynamic>? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final data = await AppConfig.getUserProfile();
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
              print("ID khách hàng: $customerId");
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
                            _customeRow(
                                image: AppIcons.user1,
                                titleOfImage:
                                    userInfo!['fullName'] ?? 'Chưa có tên'),
                            _customeRow(
                                image: AppIcons.call,
                                titleOfImage:
                                    userInfo!['phoneNumber'] ?? 'Chưa có SĐT'),
                            _customeRow(
                                image: AppIcons.calendar,
                                titleOfImage:
                                    formatBirthDate(userInfo!['birthDate'])),
                            _customeRow(
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

Widget _customeRow({required String image, required String titleOfImage}) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        Image.asset(
          image,
          color: AppColors.accent,
          width: 25,
        ),
        SizedBox(width: 10),
        Text(
          titleOfImage,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.accent),
        ),
      ],
    ),
  );
}
