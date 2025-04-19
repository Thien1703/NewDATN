import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/tools/callvideo/video_call_screen.dart';

class ScheduleCallScreen extends StatelessWidget {
  final TextEditingController _channelController = TextEditingController();

  ScheduleCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vào phòng khám online',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: AppColors.deepBlue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_hospital,
                    size: 80, color: AppColors.deepBlue),
                const SizedBox(height: 20),
                const Text(
                  'Nhập mã phòng khám',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _channelController,
                          decoration: const InputDecoration(
                            labelText: 'Mã phòng khám',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.meeting_room),
                          ),
                          keyboardType:
                              TextInputType.number, // Cho phép nhập số
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                4), // Giới hạn 4 ký tự
                            FilteringTextInputFormatter
                                .digitsOnly, // Chỉ cho phép nhập chữ số
                          ],
                          onChanged: (value) {
                            // Kiểm tra nếu mã có 4 chữ số và hợp lệ
                            if (value.length == 4 &&
                                RegExp(r'^\d{4}$').hasMatch(value)) {
                              // Mã hợp lệ
                              print("Mã phòng khám hợp lệ: $value");
                            } else if (value.length > 4) {
                              // Nếu nhập quá 4 chữ số
                              _channelController.text = value.substring(0, 4);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _joinChannel(context),
                            icon: const Icon(Icons.video_call),
                            label: const Text(
                              'Tham gia',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: AppColors.deepBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _joinChannel(BuildContext context) {
    if (_channelController.text.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          channelName: _channelController.text,
        ),
      ),
    );
  }
}
