import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
import 'package:intl/intl.dart';

class SelectTimeWidget extends StatefulWidget {
  final Function(String) onTimeSelected;
  final String selectedDate;

  const SelectTimeWidget({
    super.key,
    required this.onTimeSelected,
    required this.selectedDate,
  });

  @override
  State<SelectTimeWidget> createState() => _SelectTimeWidgetState();
}

class _SelectTimeWidgetState extends State<SelectTimeWidget> {
  String? selectedTime;
  Map<String, bool> availableTimes = {};

  final List<String> allTimes = [
    '07:00', '08:00', '09:00', '10:00', '11:00', // Sáng
    '13:00', '14:00', '15:00', '16:00', // Chiều
  ];

  @override
  void initState() {
    super.initState();
    _fetchAvailableTimes();
  }

  Future<void> _fetchAvailableTimes() async {
    Map<String, bool> tempAvailableTimes = {};

    for (String time in allTimes) {
      int availableSlots = await AppointmentApi.fetchAvailableSlots(
        DateFormat('yyyy-MM-dd').parse(widget.selectedDate),
        '$time:00', // Thêm giây cho đúng format của API
      );

      tempAvailableTimes[time] = availableSlots > 0; // true nếu có slot
    }

    setState(() {
      availableTimes = tempAvailableTimes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Chọn giờ khám',
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _customLabel(label: 'Buổi sáng'),
            Wrap(
              spacing: 13.0,
              runSpacing: 13.0,
              children: allTimes
                  .where((time) => int.parse(time.split(':')[0]) < 12)
                  .map((time) =>
                      _customValueTime(time, availableTimes[time] ?? false))
                  .toList(),
            ),
            _customLabel(label: 'Buổi chiều'),
            Wrap(
              spacing: 13.0,
              runSpacing: 13.0,
              children: allTimes
                  .where((time) => int.parse(time.split(':')[0]) >= 12)
                  .map((time) =>
                      _customValueTime(time, availableTimes[time] ?? false))
                  .toList(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Tất cả thời gian theo múi giờ Việt Nam GMT + 7',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFEAD6D),
                ),
              ),
            ),
            Image.asset(
              'assets/images/pageTime.jpg',
              width: double.infinity,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _customLabel({required String label}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.neutralBlack,
        ),
      ),
    );
  }

  Widget _customValueTime(String valueTime, bool isAvailable) {
    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                selectedTime = valueTime;
              });
              widget.onTimeSelected(valueTime);
              Navigator.pop(context);
            }
          : null, // Nếu không có slot thì không bấm được
      child: Container(
        decoration: BoxDecoration(
          color: isAvailable
              ? const Color.fromARGB(255, 184, 221, 253) // Có slot
              : Colors.grey.shade300, // Không có slot thì xám
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            valueTime,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isAvailable
                  ? AppColors.deepBlue
                  : Colors.grey.shade600, // Không chọn được thì nhạt màu
            ),
          ),
        ),
      ),
    );
  }
}
