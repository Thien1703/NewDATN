import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';
import 'package:health_care/views/screens/profile/profile_screen.dart';
import 'package:health_care/views/screens/examination/examination_screen.dart';
import 'package:health_care/views/screens/home/homePage.dart';
import 'package:health_care/views/screens/notification/notification_screen.dart';
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
    fetchSpecialties();
  }

  void fetchSpecialties() async {
    Customer? result = await CustomerApi.getCustomerProfile();
    if (result != null) {
      setState(() {
        customers = result;
      });
    }
  }

  final List<Widget> _screens = [
    HomePage(),
    ExaminationScreen(),
    ClinicScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _selectedIndex == 0
          ? BuildDraw(
              fullName: customers?.fullName ?? 'Không xác định',
            )
          : null,
      extendBody: _selectedIndex == 0 ? true : false,
      body: _screens[_selectedIndex],
      floatingActionButton: SizedBox(
        width: 50, // Tăng kích thước tổng thể
        height: 50,
        child: FloatingActionButton(
          backgroundColor: AppColors.deepBlue,
          shape: CircleBorder(),
          onPressed: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: Icon(Icons.add, size: 25, color: AppColors.deepBlue),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Màu bóng mờ
              blurRadius: 10, // Độ mờ của bóng
              spreadRadius: 2, // Độ lan của bóng
              offset: Offset(0, -3), // Bóng đổ lên trên
            ),
          ],
        ),
        child: BottomAppBar(
          elevation: 0,
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBottomBarItem(Icons.home, 'Trang chủ', 0),
              _buildBottomBarItem(Icons.local_hospital, 'Lịch khám', 1),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  'Đặt lịch',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              _buildBottomBarItem(Icons.notifications, 'Thông báo', 3),
              _buildBottomBarItem(Icons.person, 'Tài khoản', 4),
            ],
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
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? AppColors.deepBlue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.deepBlue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
