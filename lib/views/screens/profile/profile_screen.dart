import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/views/screens/profile/inforProfile_screen.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:health_care/views/screens/profile/qr_customer.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final data = await AppConfig.getUserProfile();
      if (mounted) {
        // Kiểm tra xem widget có còn tồn tại không
        setState(() {
          userData = data;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {}); // Tránh gọi setState khi đã dispose
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            // _buildOrderSection(),
            _buildAccountSection(),
            // _buildPharmacyInfoSection(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.deepBlue,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: userData?['avtar'] != null
                ? NetworkImage(userData!['avtar'])
                : const AssetImage('assets/images/noavatar.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData?['fullName'] ?? 'Người dùng',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userData?['phoneNumber'] ?? 'Số điện thoại',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tài khoản",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            Icons.qr_code,
            "Mã QR của tôi",
            () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QrCustomer()));
            },
          ),
          _buildMenuItem(Icons.person, "Thông tin cá nhân", () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const InforProfileScreen()))
                .then((_) {
              fetchUserProfile(); // Cập nhật lại dữ liệu khi trở về ProfileScreen
            });
          }),
          _buildMenuItem(Icons.location_on, "Quản lý số địa chỉ"),
          _buildMenuItem(Icons.credit_card, "Quản lý thẻ thanh toán"),
          _buildMenuItem(Icons.local_hospital, "Đơn thuốc của tôi"),
        ],
      ),
    );
  }

  // Widget _buildPharmacyInfoSection() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "Về Nhà thuốc FPT Long Châu",
  //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 10),
  //         _buildMenuItem(Icons.info, "Giới thiệu nhà thuốc"),
  //         _buildMenuItem(Icons.description, "Giấy phép kinh doanh"),
  //         _buildMenuItem(Icons.policy, "Quy chế hoạt động"),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 40.0),
      child: OutlinedButton(
        onPressed: () async {
          final authViewModel = Provider.of<AuthViewModel>(
            context,
            listen: false,
          );
          await authViewModel.signOut(context);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepBlue,
          side: const BorderSide(color: AppColors.deepBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Đăng xuất',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, [VoidCallback? onTap]) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.deepBlue),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
