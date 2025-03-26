// import 'package:flutter/material.dart';
// import 'package:health_care/common/app_colors.dart';
// import 'package:health_care/config/app_config.dart';
// import 'package:health_care/views/screens/medical_examination_record/medical_record.dart';
// import 'package:health_care/views/screens/profile/inforProfile_screen.dart';
// import 'package:provider/provider.dart';
// import '../../../viewmodels/auth_viewmodel.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   Map<String, dynamic>? _userData;
//   bool _isLoading = true;
//   bool _hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserProfile();
//   }

//   Future<void> _fetchUserProfile() async {
//     try {
//       final data = await AppConfig.getUserProfile();
//       setState(() {
//         _userData = data;
//         _isLoading = false;
//         _hasError = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             height: screenHeight / 3,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: AppColors.deepBlue,
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(25),
//                 bottomRight: Radius.circular(25),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black,
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Center(
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : _hasError
//                       ? const Text(
//                           'Lỗi tải thông tin',
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         )
//                       : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const CircleAvatar(
//                               radius: 50,
//                               backgroundImage:
//                                   AssetImage('assets/images/avt.png'),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               _userData?['fullName'] ?? 'Người dùng',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             OutlinedButton(
//                               onPressed: () async {
//                                 final authViewModel =
//                                     Provider.of<AuthViewModel>(
//                                   context,
//                                   listen: false,
//                                 );
//                                 await authViewModel.signOut(context);
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 foregroundColor: Colors.white,
//                                 side: const BorderSide(color: Colors.white),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               child: const Text('Đăng xuất'),
//                             ),
//                           ],
//                         ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               children: [
//                 _buildMenuItem(
//                   Icons.medical_services,
//                   'Hồ sơ khám bệnh',
//                   () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                           builder: (context) => const MedicalRecord()),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.account_circle,
//                   'Thông tin tài khoản',
//                   () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                           builder: (context) => const InforProfileScreen()),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   Icons.lock,
//                   'Chính sách bảo mật',
//                   () {},
//                 ),
//                 _buildMenuItem(
//                   Icons.info,
//                   'Phiên bản ứng dụng v1.2',
//                   () {},
//                 ),
//                 _buildMenuItem(
//                   Icons.star,
//                   'Đánh giá',
//                   () {},
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         leading: Icon(icon, color: AppColors.deepBlue),
//         title: Text(text),
//         onTap: onTap,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/views/screens/profile/inforProfile_screen.dart';
import 'package:health_care/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final data = await AppConfig.getUserProfile();
      setState(() {
        _userData = data;
      });
    } catch (e) {
      setState(() {});
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
            _buildOrderSection(),
            _buildAccountSection(),
            _buildPharmacyInfoSection(),
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
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/avt.png'),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userData?['fullName'] ?? 'Người dùng',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _userData?['phoneNumber'] ?? 'Số điện thoại',
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

  Widget _buildOrderSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Đơn của tôi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderItem(Icons.shopping_bag, "Đang xử lý"),
              _buildOrderItem(Icons.local_shipping, "Đang giao"),
              _buildOrderItem(Icons.check_circle, "Đã giao"),
              _buildOrderItem(Icons.autorenew, "Đổi/Trả"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 30, color: AppColors.deepBlue),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
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
          _buildMenuItem(Icons.qr_code, "Mã QR của tôi"),
          _buildMenuItem(Icons.person, "Thông tin cá nhân", () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const InforProfileScreen()),
            );
          }),
          _buildMenuItem(Icons.location_on, "Quản lý số địa chỉ"),
          _buildMenuItem(Icons.credit_card, "Quản lý thẻ thanh toán"),
          _buildMenuItem(Icons.local_hospital, "Đơn thuốc của tôi"),
        ],
      ),
    );
  }

  Widget _buildPharmacyInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Về Nhà thuốc FPT Long Châu",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildMenuItem(Icons.info, "Giới thiệu nhà thuốc"),
          _buildMenuItem(Icons.description, "Giấy phép kinh doanh"),
          _buildMenuItem(Icons.policy, "Quy chế hoạt động"),
        ],
      ),
    );
  }

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
