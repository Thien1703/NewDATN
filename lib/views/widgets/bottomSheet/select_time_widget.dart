import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';

class SelectTimeWidget extends StatefulWidget {
  final Function(String) onTimeSelected;
  final DateTime? selectedDate;

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

  final List<String> allTimes = [
    '07:00', '08:00', '09:00', '10:00', '11:00', // Sáng
    '13:00', '14:00', '15:00', '16:00', // Chiều
  ];

  bool _isPastTime(String time) {
    DateTime now = DateTime.now();
    int hour = int.parse(time.split(':')[0]);
    int minute = int.parse(time.split(':')[1]);
    return now.hour > hour || (now.hour == hour && now.minute > minute);
  }

  Widget _customLabel({required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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

  Widget _customValueTime(String valueTime, bool isDisabled) {
    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              setState(() {
                selectedTime = valueTime;
              });
              widget.onTimeSelected(valueTime);
              Navigator.pop(context);
            },
      child: Container(
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey[300]
              : const Color.fromARGB(255, 184, 221, 253),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          valueTime,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDisabled ? Colors.grey : AppColors.deepBlue,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isToday = widget.selectedDate != null &&
        widget.selectedDate!.year == now.year &&
        widget.selectedDate!.month == now.month &&
        widget.selectedDate!.day == now.day;

    return Container(
      color: AppColors.ghostWhite,
      child: HeaderBottomSheet(
        title: 'Chọn giờ khám',
        body: Container(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _customLabel(label: 'Buổi sáng'),
                        Wrap(
                          spacing: 5.0,
                          runSpacing: 13.0,
                          children: allTimes
                              .where(
                                  (time) => int.parse(time.split(':')[0]) < 12)
                              .map((time) => _customValueTime(
                                    time,
                                    isToday && _isPastTime(time),
                                  ))
                              .toList(),
                        ),
                        _customLabel(label: 'Buổi chiều'),
                        Wrap(
                          spacing: 5.0,
                          runSpacing: 13.0,
                          children: allTimes
                              .where(
                                  (time) => int.parse(time.split(':')[0]) >= 12)
                              .map((time) => _customValueTime(
                                    time,
                                    isToday && _isPastTime(time),
                                  ))
                              .toList(),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Tất cả thời gian theo múi giờ Việt Nam GMT + 7',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFEAD6D),
                            ),
                          ),
                        ),
                        // Responsive image
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Image.asset(
                              'assets/images/pageTime.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
