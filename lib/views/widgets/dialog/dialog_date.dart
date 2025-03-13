import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'vi', null); // Khởi tạo định dạng cho ngôn ngữ 'vi'
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookingScreen(),
    );
  }
}

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime.now().subtract(Duration(days: 30));
  final DateTime _lastDay = DateTime.now().add(Duration(days: 365));
  final Set<DateTime> _kinLichDays = {}; // Tracks days marked as "kín lịch"

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: 900,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Chọn ngày khám',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 48), // Placeholder for alignment
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bệnh viện Nhân Dân Gia Định hỗ trợ đặt lịch khám bệnh trước từ 1 đến 30 ngày.',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
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
                      _kinLichDays.add(selectedDay);
                    });
                    Navigator.pop(context);
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    //ngày hiện tại
                    todayDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 213, 234, 213),
                      border: Border.all(
                          color: const Color.fromARGB(255, 95, 130, 91),
                          width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // chọn ngày
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    //ngaythang
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.white),
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
                  // thứ
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.black),
                    weekendStyle: TextStyle(color: Colors.black),
                    dowTextFormatter: (day, locale) {
                      return DateFormat.E(locale).format(day).toUpperCase();
                    },
                  ),
                ),
                SizedBox(height: 16),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Chọn ngày khám', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showBottomSheet(context),
          child: Text('Chọn ngày'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ),
    );
  }
}
