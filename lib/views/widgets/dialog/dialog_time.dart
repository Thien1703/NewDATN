import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: AppointmentDialog(),
    );
  }
}


class AppointmentDialog extends StatelessWidget {
  const AppointmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đặt Lịch Hẹn"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildAlertDialog(context),
            );
          },
          child: Text('Chọn giờ khám'),
        ),
      ),
    );
  }

  Widget _buildAlertDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    title: Row(

      children: [
        IconButton(
          icon: Image.asset('assets/icons/cancle_icon.png'),
          iconSize: 48,
          onPressed: () {
            Navigator.pop(context); // Đóng dialog
          },
        ),
        SizedBox(width: 40,),
        Text(
          'Chọn giờ khám',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    ),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái các phần tiêu đề
        mainAxisSize: MainAxisSize.min,
        children: [
          // Buổi sáng
          Text(
            'Buổi sáng',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: _buildTimeSlots(timeSlotsMorning), // Đưa khung giờ vào giữa
          ),
          SizedBox(height: 16),
          // Buổi chiều
          Text(
            'Buổi chiều',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: _buildTimeSlots(timeSlotsAfternoon), // Đưa khung giờ vào giữa
          ),
          SizedBox(height: 16),
          Text(
            'Tất cả thời gian theo múi giờ Việt Nam GMT+7',
            style: TextStyle(
              fontSize: 12,
              color: const Color.fromARGB(255, 215, 101, 44),
            ),
          ),
        ],
      ),
    ),
  );
  }
}

Widget _buildTimeSlots(List<String> timeSlots) {
  return Wrap(
    spacing: 15,
    runSpacing: 15,
    alignment: WrapAlignment.center, // Căn giữa toàn bộ các khung giờ
    children: timeSlots.map((time) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(10.0),
          // border: Border.all(color: Colors.green),
        ),
        child: Text(
          time,
          style: TextStyle(fontSize: 10,color: const Color.fromARGB(255, 42, 140, 46)),
        ),
      );
    }).toList(),
  );
}



final List<String> timeSlotsMorning = [
  '06:00 - 07:00',
  '07:00 - 08:00',
  '08:00 - 09:00',
  '09:00 - 10:00',
  '10:00 - 11:00',
  '11:00 - 11:30',
];

final List<String> timeSlotsAfternoon = [
  '12:00 - 13:00',
  '13:00 - 14:00',
  '14:00 - 15:00',
  '15:00 - 16:00',
  '16:00 - 17:00',
  '17:00 - 17:30',
];