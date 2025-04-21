import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health_care/views/screens/tools/callvideo/donebookOn.dart';
import 'package:intl/intl.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/tools/callvideo/doctorOnLineModel.dart';

String generateRoomCode() {
  final random = Random();
  return random.nextInt(10000).toString().padLeft(4, '0');
}

class BookingOnlineScreen extends StatefulWidget {
  final Doctor doctor;

  const BookingOnlineScreen({super.key, required this.doctor});

  @override
  State<BookingOnlineScreen> createState() => _BookingOnlineScreenState();
}

class _BookingOnlineScreenState extends State<BookingOnlineScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedPackage;

  final List<String> packages = [
    '1 giờ',
    '1 giờ 30 phút',
    '2 giờ'
  ]; // ✅ Fix thiếu dấu ]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đặt lịch với ${widget.doctor.name}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.deepBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(widget.doctor.imagePath),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                widget.doctor.specialty,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),

            /// Chọn ngày
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                  : 'Chọn ngày khám'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),

            /// Chọn giờ
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(selectedTime != null
                  ? selectedTime!.format(context)
                  : 'Chọn giờ khám'),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
            ),

            /// Gói khám
            const SizedBox(height: 16),
            const Text('Chọn gói khám:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: packages.map((pkg) {
                final isSelected = selectedPackage == pkg;
                return ChoiceChip(
                  label: Text(pkg),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedPackage = pkg;
                    });
                  },
                  selectedColor: AppColors.deepBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            /// Nút xác nhận
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedDate != null &&
                        selectedTime != null &&
                        selectedPackage != null)
                    ? () {
                        String roomCode = generateRoomCode(); // 🔥 Tạo mã phòng

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingConfirmationScreen(
                              doctorName: widget.doctor.name,
                              selectedPackage: selectedPackage!,
                              selectedDate: selectedDate!,
                              selectedTime: selectedTime!,
                              roomCode: roomCode, // 🔥 Truyền mã phòng
                            ),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Đã đặt lịch thành công cho ${widget.doctor.name}'),
                        ));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Xác nhận đặt lịch',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
