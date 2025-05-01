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
    final currentTime = DateTime.now();
    final currentHour = currentTime.hour;
    final currentMinute = currentTime.minute;
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // So sánh giờ
    if (hour < currentHour ||
        (hour == currentHour && minute <= currentMinute)) {
      return true;
    }
    return false;
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
                onPressed: isPastTime
                    ? null // Disable button if the time is in the past
                    : () {
                        setState(() {
                          _selectedTime = time; // Lưu giờ đã chọn
                        });
                        widget.onTimeSelected(
                            time); // Gửi giá trị về màn hình chính
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? AppColors.deepBlue
                      : (isPastTime
                          ? Colors.grey
                          : AppColors.deepBlue.withOpacity(0.6)),
                  foregroundColor: isSelected
                      ? Colors.white
                      : (isPastTime
                          ? Colors.black
                          : AppColors.deepBlue.withOpacity(0.6)),
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
