import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';

class WidgetSelectedTimeOnline extends StatefulWidget {
  final Function(String) onTimeSelected;
  final int doctorId;
  final String date;

  const WidgetSelectedTimeOnline({
    super.key,
    required this.onTimeSelected,
    required this.doctorId,
    required this.date,
  });

  @override
  State<WidgetSelectedTimeOnline> createState() =>
      _WidgetSelectedTimeOnlineState();
}

class _WidgetSelectedTimeOnlineState extends State<WidgetSelectedTimeOnline> {
  String? _selectedTime;
  List<Map<String, dynamic>> _availableTimes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAvailableTimes();
  }

  Future<void> _fetchAvailableTimes() async {
    final result = await AppointmentApi.checkAppointmentTime(
      doctorId: widget.doctorId,
      date: widget.date,
    );

    if (result != null && result.slots.isNotEmpty) {
      _availableTimes = result.slots.entries
          .map((entry) => {
                'time': entry.key, // Giờ
                'slots': entry.value, // Số slot
              })
          .toList()
        ..sort((a, b) {
          String timeA = a['time'] as String? ?? '';
          String timeB = b['time'] as String? ?? '';
          return timeA.compareTo(timeB);
        });
    } else {
      _availableTimes = [];
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isTimePast(String time) {
    final now = DateTime.now();
    final selectedDate =
        DateTime.parse(widget.date); // widget.date định dạng "yyyy-MM-dd"

    // Nếu là ngày tương lai thì không cần kiểm tra giờ
    if (selectedDate.isAfter(DateTime(now.year, now.month, now.day))) {
      return false;
    }

    // Nếu là hôm nay, mới cần so sánh giờ
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );

    return selectedDateTime.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
      child: SizedBox(
        height: 250, // Tăng chiều cao để chứa số lượng slot dưới mỗi giờ
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildTimeButtons(_availableTimes),
      ),
    );
  }

  Widget _buildTimeButtons(List<Map<String, dynamic>> times) {
    if (times.isEmpty) {
      return const Center(child: Text('Không có giờ trống cho ngày này'));
    }

    return Padding(
      padding: EdgeInsets.zero,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: times.map((timeData) {
          final time = timeData['time'] as String;
          final slots = timeData['slots'] as int;
          final isSelected = _selectedTime == time;
          final isPastTime = _isTimePast(time);

          return Column(
            children: [
              ElevatedButton(
                onPressed: (isPastTime || slots == 0)
                    ? null
                    : () {
                        setState(() {
                          _selectedTime = time;
                        });
                        widget.onTimeSelected(time);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? AppColors.deepBlue
                      : (isPastTime
                          ? Colors.grey
                          : AppColors.deepBlue.withOpacity(0.5)),
                  foregroundColor: isSelected
                      ? Colors.white
                      : (isPastTime
                          ? Colors.black
                          : AppColors.deepBlue.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 5),
              // Chỉ hiển thị slot nếu nút giờ có thể nhấn được (không phải giờ đã qua và có slot trống)
              if (!(isPastTime || slots == 0))
                Text(
                  '$slots slot${slots > 1 ? 's' : ''} ',
                  style: TextStyle(color: AppColors.deepBlue),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
