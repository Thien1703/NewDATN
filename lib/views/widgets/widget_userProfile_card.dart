import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/config/app_config.dart';
import 'package:intl/intl.dart';

class WidgetUserprofileCard extends StatefulWidget {
  final Function(int)? onTap;
  // final Function(Function refreshProfile)? onEdit; // Gửi hàm để cập nhật dữ liệu sau khi chỉnh sửa

  const WidgetUserprofileCard({super.key, this.onTap});

  @override
  WidgetUserprofileCardState createState() => WidgetUserprofileCardState();
}

class WidgetUserprofileCardState extends State<WidgetUserprofileCard> {
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

  
Widget build(BuildContext context) {
  return InkWell(
    onTap: () {
      if (userInfo != null && userInfo!['id'] != null) {
        int customerId = userInfo!['id']; // Lấy ID từ API
        print("ID khách hàng: $customerId"); // In ra console
        if (widget.onTap != null) {
          widget.onTap!(customerId); // Truyền ID qua callback
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
        child: Stack(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator()) // Hiển thị khi tải dữ liệu
                : userInfo == null
                    ? Center(child: Text("Không có dữ liệu"))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _customRow(
                                  image: AppIcons.user1,
                                  titleOfImage:
                                      userInfo!['fullName'] ?? 'Chưa có tên'),
                              _customRow(
                                  image: AppIcons.call,
                                  titleOfImage:
                                      userInfo!['phoneNumber'] ?? 'Chưa có SĐT'),
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
                        ],
                      ),
            
          ],
        ),
      ),
    ),
  );
}

Widget _customRow({required String image, required String titleOfImage}) {
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
            color: AppColors.accent,
          ),
        ),
      ],
    ),
  );
}
}
