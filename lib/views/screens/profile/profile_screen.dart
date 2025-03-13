import 'package:flutter/material.dart';
import 'package:health_care/viewmodels/api/api_service.dart';
import 'package:health_care/views/screens/medical_examination_record/medical_record.dart';
import 'package:health_care/views/screens/profile/inforProfile_screen.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final data = await ApiService.getUserProfile();
      setState(() {
        _userData = data;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: screenHeight / 3,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : _hasError
                      ? const Text(
                          'Lỗi tải thông tin',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/avt.png'),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _userData?['fullName'] ?? 'Người dùng',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            OutlinedButton(
                              onPressed: () async {
                                final authViewModel =
                                    Provider.of<AuthViewModel>(
                                  context,
                                  listen: false,
                                );
                                await authViewModel.signOut(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Đăng xuất'),
                            ),
                          ],
                        ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildMenuItem(
                  Icons.medical_services,
                  'Hồ sơ khám bệnh',
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const MedicalRecord()),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.account_circle,
                  'Thông tin tài khoản',
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const InforProfileScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.lock,
                  'Chính sách bảo mật',
                  () {},
                ),
                _buildMenuItem(
                  Icons.info,
                  'Phiên bản ứng dụng v1.2',
                  () {},
                ),
                _buildMenuItem(
                  Icons.star,
                  'Đánh giá',
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
