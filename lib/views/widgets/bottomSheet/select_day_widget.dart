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
  final DateTime _lastDay = DateTime.now().add(Duration(days: 365));

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Chọn ngày khám',
      body: Column(
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
              cellMargin: EdgeInsets.all(2),
              defaultTextStyle: TextStyle(fontSize: 15),
              weekendTextStyle: TextStyle(fontSize: 15),
              todayTextStyle:
                  TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              // Nếu chọn ngày (selected)
              selectedDecoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              // Cài đặt cho ngày hôm nay, tránh xung đột với borderRadius khi dùng circle
              todayDecoration: BoxDecoration(
                color: AppColors.deepBlue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              weekendDecoration: BoxDecoration(
                color: AppColors.softBlue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              defaultDecoration: BoxDecoration(
                color: AppColors.softBlue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              disabledTextStyle:
                  TextStyle(color: const Color.fromARGB(255, 179, 179, 179)),
              disabledDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 227, 227),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            headerStyle: HeaderStyle(
              headerPadding: EdgeInsets.symmetric(vertical: 5),
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              leftChevronIcon:
                  Icon(Icons.chevron_left, size: 20, color: Colors.white),
              rightChevronIcon:
                  Icon(Icons.chevron_right, size: 20, color: Colors.white),
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              weekendStyle:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendIndicator(Colors.grey, 'Hôm nay'),
              _buildLegendIndicator(AppColors.softBlue, 'Còn trống'),
              // _buildLegendIndicator(Colors.grey, 'Kín lịch'),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildLegendIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
