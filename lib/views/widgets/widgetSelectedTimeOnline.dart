import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class Widgetselectedtimeonline extends StatelessWidget {
  const Widgetselectedtimeonline({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.deepBlue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Buổi sáng'),
                Tab(text: 'Buổi chiều'),
              ],
            ),
            SizedBox(
              height: 150,
              child: TabBarView(
                children: [
                  Center(child: Text('Nội dung buổi sáng')),
                  Center(child: Text('Nội dung buổi chiều')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
