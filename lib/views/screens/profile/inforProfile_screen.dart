import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/api/api_service.dart';
import 'package:health_care/views/screens/profile/editProfile_screen.dart';
import 'package:intl/intl.dart';

class InforProfileScreen extends StatefulWidget {
  const InforProfileScreen({super.key});

  @override
  _InforProfileScreenState createState() => _InforProfileScreenState();
}

class _InforProfileScreenState extends State<InforProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final data = await ApiService.getUserProfile();
    if (mounted) {
      setState(() {
        userData = data;
        isLoading = false;
      });
    }
  }

  String formatBirthDate(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return 'Chưa cập nhật';
    try {
      DateTime dateTime = DateTime.parse(birthDate);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return 'Sai định dạng';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.12;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị loading
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: headerHeight,
                  color: AppColors.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Text(
                          'Xác nhận thông tin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            // Xử lý xóa
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Nội dung hiển thị thông tin người dùng
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin tài khoản',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow('Họ và tên',
                            userData?['fullName'] ?? 'Chưa cập nhật'),
                        _buildInfoRow(
                            'Ngày sinh',
                            formatBirthDate(userData?['birthDate'])),
                        _buildInfoRow('Giới tính',
                            userData?['gender'] ?? 'Chưa cập nhật'),
                        _buildInfoRow(
                            'Email', userData?['email'] ?? 'Chưa cập nhật'),
                        _buildInfoRow('Số điện thoại',
                            userData?['phoneNumber'] ?? 'Chưa cập nhật'),
                        _buildInfoRow(
                            'Địa chỉ', userData?['address'] ?? 'Chưa cập nhật'),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Chỉnh sửa'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.neutralDarkGreen2)),
          Text(
            value,
            style: TextStyle(
              color: AppColors.neutralDarkGreen2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
