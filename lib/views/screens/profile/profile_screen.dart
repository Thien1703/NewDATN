import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/services/user_preferences_service.dart';
import 'package:health_care/views/screens/auth/Login/login_screen.dart';
import 'package:health_care/views/screens/profile/inforProfile_screen.dart';
import 'package:health_care/views/screens/profile/notification_setting_screen.dart';
import 'package:health_care/views/screens/profile/patient_profiles.dart';
import 'package:health_care/views/screens/profile/termsAndServices_screen.dart';
import 'package:health_care/views/widgets/bottomSheet/logOut_bottomSheet.dart';

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
    loadUserFromPrefs(); // Load dữ liệu cache trước
    fetchUserProfile(); // Gọi API để cập nhật
  }

  Future<void> fetchUserProfile() async {
    try {
      final data = await AppConfig.getUserProfile();
      if (!mounted) return;

      setState(() {
        userData = data;
      });

      // Lưu thông tin vào local
      await UserPreferencesService.saveUserProfile(
        avatar: data?['avatar'] ?? '',
        fullName: data?['fullName'] ?? '',
        phoneNumber: data?['phoneNumber'] ?? '',
      );
    } catch (_) {
      if (mounted) setState(() {});
    }
  }

  Future<void> loadUserFromPrefs() async {
    final data = await UserPreferencesService.getUserProfile();
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
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

  // Widget _buildProfileHeader() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: AppColors.deepBlue,
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         CircleAvatar(
  //           radius: 40,
  //           backgroundImage: userData?['avatar'] != null
  //               ? NetworkImage(userData!['avatar'])
  //               : const AssetImage(
  //                   'assets/images/iconProfile.jpg',
  //                 ) as ImageProvider,
  //           backgroundColor: Colors.transparent,
  //         ),
  //         const SizedBox(width: 10),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 userData?['fullName'] ?? 'Người dùng',
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //                 softWrap: false,
  //               ),
  //               Text(
  //                 userData?['phoneNumber'] ?? 'Số điện thoại',
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _buildProfileHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.deepBlue,
          ),
        ),
        Positioned(
          top: 45,
          // Đẩy avatar xuống 1 nửa, đè ra ngoài
          left: 0,
          right: 0,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: userData?['avatar'] != null
                        ? NetworkImage(userData!['avatar'])
                        : const AssetImage('assets/images/iconProfile.jpg')
                            as ImageProvider,
                    backgroundColor: Colors.white,
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: -2,
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //       color: Colors.white,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     padding: const EdgeInsets.all(4),
                  //     child: const Icon(
                  //       Icons.camera_alt,
                  //       size: 16,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                userData?['fullName'] ?? 'Người dùng',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tài khoản",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(Icons.person, "Thông tin cá nhân", () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => InforProfileScreen(),
              ),
            )
                .then((_) {
              fetchUserProfile(); // Cập nhật lại dữ liệu khi trở về ProfileScreen
            });
          }),
          _buildMenuItem(Icons.folder, "Hồ sơ đặt khám", () {
            Navigator.of(context)
                .push(
                    MaterialPageRoute(builder: (context) => PatientProfiles()))
                .then((_) {
              fetchUserProfile(); // Cập nhật lại dữ liệu khi trở về ProfileScreen
            });
          }),
          // const SizedBox(height: 5),
          _buildMenuItem(Icons.list_alt_outlined, "Điều khoản dịch vụ", () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TermsandservicesScreen()));
          }),
          _buildMenuItem(Icons.notifications, "Cài đặt thông báo", () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NotificationSettingScreen()));
          })
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 40.0),
      child: OutlinedButton(
        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,
            builder: (context) => const LogoutBottomsheet(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
          );

          if (result == true && mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
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
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.deepBlue),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
