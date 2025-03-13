import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class SelectDayWidget extends StatefulWidget {
  const SelectDayWidget({super.key});
  @override
  State<SelectDayWidget> createState() => _SelectDayWidget();
}

class _SelectDayWidget extends State<SelectDayWidget> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime.now().subtract(Duration(days: 30));
  final DateTime _lastDay = DateTime.now().add(Duration(days: 365));
  final Set<DateTime> _kinLichDays = {};
  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Chọn ngày khám',
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableCalendar(
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusedDay: _focusedDay,
                locale: 'vi',
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  Navigator.pop(context,
                      _selectedDay); // Trả ngày đã chọn về DateSelector
                  print(_selectedDay);
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 213, 234, 213),
                    border: Border.all(
                        color: const Color.fromARGB(255, 95, 130, 91),
                        width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  todayTextStyle: TextStyle(color: Colors.black),
                  selectedDecoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 179, 178, 180), // Change to "kín lịch" color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  defaultDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 213, 234, 213),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  weekendDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 213, 234, 213),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 213, 234, 213),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  markerDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 179, 178, 180),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  outsideDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 213, 234, 213),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledTextStyle: TextStyle(
                      color: const Color.fromARGB(255, 206, 205, 205)),
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.black),
                  cellMargin: EdgeInsets.all(2),
                  // CHỌN NGÀY
                  rangeEndDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 179, 178, 180),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextFormatter: (date, locale) {
                    return DateFormat.yMMMM(locale).format(date);
                  },
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  //ngaythang
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Colors.white),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black),
                  weekendStyle: TextStyle(color: Colors.black),
                  dowTextFormatter: (day, locale) {
                    return DateFormat.E(locale).format(day).toUpperCase();
                  },
                ),
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 213, 234, 213),
                          border: Border.all(
                              color: const Color.fromARGB(255, 95, 130, 91),
                              width: 1.5),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Hôm nay'),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: const Color.fromARGB(255, 213, 234, 213),
                      ),
                      SizedBox(width: 8),
                      Text('Còn trống'),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: const Color.fromARGB(255, 179, 178, 180),
                      ),
                      SizedBox(width: 8),
                      Text('Kín lịch'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
