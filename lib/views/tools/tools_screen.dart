import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/tools/BMI/measureBMI_Screen.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({Key? key}) : super(key: key);

  @override
  State<ToolsScreen> createState() => _ToolsScreen();
}

class _ToolsScreen extends State<ToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Công cụ sức khỏe"),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.notifications_none), onPressed: () {}),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Khám phá'),
              Tab(text: 'Chăm sóc cá nhân'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildExploreTab(context),
            const Center(child: Text('Chăm sóc cá nhân')),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFoodLibraryBanner(),
          const SizedBox(height: 20),
          const Text(
            'Công cụ tính nhanh',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text('Kiểm tra nhanh các chỉ số sức khoẻ'),
          const SizedBox(height: 12),
          _buildQuickToolsGrid(),
          const SizedBox(height: 24),
          const Text(
            'Chăm sóc cá nhân',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildPersonalCareCard(),
        ],
      ),
    );
  }

  Widget _buildFoodLibraryBanner() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue[200],
      ),
      padding: const EdgeInsets.all(16),
    );
  }

  Widget _buildQuickToolsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _ToolCard(
          title: 'Tính chỉ số BMI',
          icon: Icons.speed,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MeasurebmiScreen()),
            );
          },
        ),
        _ToolCard(
          title: 'Tính chỉ số BMR',
          icon: Icons.local_fire_department,
          onTap: () {},
        ),
        _ToolCard(
          title: 'Thư viện thức ăn',
          icon: Icons.soup_kitchen,
          onTap: () {},
        ),
        _ToolCard(
          title: 'Tính nhịp tim lý tưởng',
          icon: Icons.monitor_heart,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPersonalCareCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.alarm, size: 40, color: Colors.blue),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Nhắc nhở uống thuốc',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ToolCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
