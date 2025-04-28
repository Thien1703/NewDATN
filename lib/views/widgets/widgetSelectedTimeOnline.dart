import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class Widgetselectedtimeonline extends StatefulWidget {
  final Function(String) onTimeSelected;

  const Widgetselectedtimeonline({
    super.key,
    required this.onTimeSelected,
  });

  @override
  State<Widgetselectedtimeonline> createState() =>
      _WidgetselectedtimeonlineState();
}

class _WidgetselectedtimeonlineState extends State<Widgetselectedtimeonline> {
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 12, top: 10, bottom: 10),
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
                  _buildTimeButtons([
                    '08:00',
                    '08:30',
                    '09:00',
                    '09:30',
                    '10:00',
                    '10:30',
                    '11:00',
                    '11:30'
                  ]),
                  _buildTimeButtons([
                    '13:00',
                    '13:30',
                    '14:00',
                    '14:30',
                    '15:00',
                    '15:30',
                    '16:00',
                    '16:30'
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButtons(List<String> times) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: times.map((time) {
          final isSelected = _selectedTime == time;
          return ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedTime = time;
              });
              widget.onTimeSelected(time); // Gửi giờ ra ngoài
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? AppColors.deepBlue : Colors.white,
              foregroundColor: isSelected ? Colors.white : AppColors.deepBlue,
              side: BorderSide(color: AppColors.deepBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            child: Text(time),
          );
        }).toList(),
      ),
    );
  }
}
