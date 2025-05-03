import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDayWidget extends StatefulWidget {
  const SelectDayWidget({super.key, required this.clinicId});
  final int clinicId;

  @override
  State<SelectDayWidget> createState() => _SelectDayWidgetState();
}

class _SelectDayWidgetState extends State<SelectDayWidget> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime.now(); // Không cho chọn ngày trước đó
  final DateTime _lastDay = DateTime.now().add(Duration(days: 60));

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Chọn ngày khám',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Giúp co giãn
        children: [
          TableCalendar(
            firstDay: _firstDay, // Giới hạn ngày đầu tiên trong tháng
            lastDay: _lastDay, // Giới hạn ngày cuối cùng trong tháng
            focusedDay: _focusedDay,
            locale: 'vi',
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay
                  .isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                return;
              }

              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              Navigator.pop(context, _selectedDay);
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false, // Ẩn ngày ngoài tháng
              cellMargin: EdgeInsets.all(1), // Giảm khoảng cách
              defaultTextStyle: TextStyle(fontSize: 12), // Giảm font size
              weekendTextStyle: TextStyle(fontSize: 12),
              todayTextStyle: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.bold), // Giảm font size
              // Nếu chọn ngày (selected)
              selectedDecoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6), // Thu nhỏ borderRadius
              ),
              // Cài đặt cho ngày hôm nay, tránh xung đột với borderRadius khi dùng circle
              todayDecoration: BoxDecoration(
                color: AppColors.deepBlue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6), // Thu nhỏ borderRadius
              ),
              weekendDecoration: BoxDecoration(
                color: AppColors.softBlue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6), // Thu nhỏ borderRadius
              ),
              defaultDecoration: BoxDecoration(
                color: AppColors.softBlue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6), // Thu nhỏ borderRadius
              ),
              disabledTextStyle:
                  TextStyle(color: const Color.fromARGB(255, 179, 179, 179)),
              disabledDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 227, 227),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6), // Thu nhỏ borderRadius
              ),
            ),
            headerStyle: HeaderStyle(
              headerPadding: EdgeInsets.symmetric(vertical: 3), // Giảm padding
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16, // Giảm font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              leftChevronIcon: Icon(Icons.chevron_left,
                  size: 18, color: Colors.white), // Giảm kích thước icon
              rightChevronIcon: Icon(Icons.chevron_right,
                  size: 18, color: Colors.white), // Giảm kích thước icon
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), // Giảm borderRadius
                  topRight: Radius.circular(16), // Giảm borderRadius
                ),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600), // Giảm font size
              weekendStyle: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600), // Giảm font size
            ),
          ),
          SizedBox(height: 8), // Giảm khoảng cách
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendIndicator(Colors.grey, 'Hôm nay'),
              _buildLegendIndicator(AppColors.softBlue, 'Còn trống'),
            ],
          ),
          SizedBox(height: 8), // Giảm khoảng cách
        ],
      ),
    );
  }

  Widget _buildLegendIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10, // Giảm kích thước
          height: 10, // Giảm kích thước
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6), // Thu nhỏ borderRadius
          ),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 12)), // Giảm font size
      ],
    );
  }
}
