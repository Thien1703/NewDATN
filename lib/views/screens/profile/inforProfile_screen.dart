import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/screens/profile/change_password.dart';
import 'package:health_care/views/screens/profile/editProfile_screen.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InforProfileScreen extends StatefulWidget {
  const InforProfileScreen({super.key});

  @override
  _InforProfileScreenState createState() => _InforProfileScreenState();
}

class _InforProfileScreenState extends State<InforProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  File? _avatarFile;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() => isLoading = true);
    final data = await AppConfig.getUserProfile();
    debugPrint('User data: $data');
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.uploadAvatar(context, _avatarFile!);

    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Xác nhận thông tin',
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị loading
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: userData?['avtar'] != null
                                ? NetworkImage(userData!['avtar'])
                                : const AssetImage('assets/images/noavatar.png')
                                    as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      'Họ và tên', userData?['fullName'] ?? 'Chưa cập nhật'),
                  _buildInfoRow(
                      'Ngày sinh', formatBirthDate(userData?['birthDate'])),
                  _buildInfoRow(
                      'Giới tính', userData?['gender'] ?? 'Chưa cập nhật'),
                  _buildInfoRow('Email', userData?['email'] ?? 'Chưa cập nhật'),
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
                            builder: (context) => EditProfileScreen(
                              onProfileUpdated: () async {
                                await fetchUserData();
                              },
                            ),
                          ),
                        );
                        fetchUserData(); // Đảm bảo dữ liệu luôn mới ngay khi quay lại
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppColors.deepBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Chỉnh sửa'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppColors.deepBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Đổi mật khẩu'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: const Color(0xFF808080))),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
