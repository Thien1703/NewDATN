import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import để sử dụng SystemNavigator.pop()
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';
import 'package:health_care/views/screens/profile/profile_screen.dart';
import 'package:health_care/views/screens/examination/examination_screen.dart';
import 'package:health_care/views/screens/home/homePage.dart';
import 'package:health_care/views/screens/tools/tools_screen.dart';
import 'package:health_care/views/widgets/build_Draw.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key, this.inttialIndex = 0});
  final int inttialIndex;

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  int _selectedIndex = 0;
  Customer? customers;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.inttialIndex;
    fetchCustomerProfile();
  }

  void fetchCustomerProfile() async {
    try {
      Customer? result = await CustomerApi.getCustomerProfile();
      if (mounted) {
        setState(() {
          customers = result;
        });
      }
    } catch (e) {
      debugPrint("Error fetching customer profile: $e");
    }
  }

  final List<Widget> _screens = [
    HomePage(),
    ExaminationScreen(),
    ClinicScreen(),
    ToolsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          // Nếu không phải màn Trang chủ, chuyển về Trang chủ
          setState(() {
            _selectedIndex = 0;
          });
          return false; // Không thoát app
        } else {
          // Nếu đã ở màn Trang chủ, thoát app
          SystemNavigator.pop();
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          drawer: _selectedIndex == 0
              ? BuildDraw(
                  fullName: customers?.fullName ?? 'Không xác định',
                  image: customers?.avatar ?? 'assets/images/iconProfile.jpg',
                  phone: customers?.phoneNumber.toString() ?? '0',
                )
              : null,
          extendBody: _selectedIndex == 0,
          body: _screens[_selectedIndex],
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.deepBlue,
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClinicScreen()),
              );
            },
            child: const Icon(Icons.add, size: 30, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 2,
              )
            ]),
            child: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              color: Colors.white,
              child: SizedBox(
                height: screenHeight * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomBarItem(Icons.home, 'Trang chủ', 0),
                    _buildBottomBarItem(Icons.local_hospital, 'Lịch khám', 1),
                    const SizedBox(width: 50),
                    _buildBottomBarItem(Icons.speed_outlined, 'Công cụ', 3),
                    _buildBottomBarItem(Icons.person, 'Tài khoản', 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? AppColors.deepBlue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? AppColors.deepBlue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
