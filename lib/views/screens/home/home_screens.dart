import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';
import 'package:health_care/views/screens/profile/profile_screen.dart';
import 'package:health_care/views/screens/examination/examination_screen.dart';
import 'package:health_care/views/screens/home/homePage.dart';
import 'package:health_care/views/tools/tools_screen.dart';
import 'package:health_care/views/widgets/build_Draw.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  int _selectedIndex = 0;
  Customer? customers;

  @override
  void initState() {
    super.initState();
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
    return SafeArea(
      child: Scaffold(
        drawer: _selectedIndex == 0
            ? BuildDraw(fullName: customers?.fullName ?? 'Không xác định')
            : null,
        extendBody: _selectedIndex == 0,
        body: _screens[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.deepBlue,
          shape: CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClinicScreen()),
            );
          },
          child: Icon(Icons.add, size: 30, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 2,
              spreadRadius: 2,
            )
          ]),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: Colors.white,
            child: Container(
              height: screenHeight *
                  0.08, // Tự động điều chỉnh theo chiều cao màn hình
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomBarItem(Icons.home, 'Trang chủ', 0),
                  _buildBottomBarItem(Icons.local_hospital, 'Lịch khám', 1),
                  SizedBox(width: 50), // Chừa chỗ cho FAB
                  _buildBottomBarItem(Icons.speed_outlined, 'Công cụ', 3),
                  _buildBottomBarItem(Icons.person, 'Tài khoản', 4),
                ],
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
