import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';

class WidgetUserCard extends StatelessWidget {
  const WidgetUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hướng dẫn chọn hồ sơ
        Container(
          width: double.infinity,
          height: 54,
          padding: const EdgeInsets.all(12),
          // margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            // borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Vui lòng chọn 1 trong các hồ sơ bên dưới, hoặc bấm vào biểu tượng ở trên để thêm hồ sơ người bệnh',
                  style: TextStyle(color: Color(0xFF1772B2), fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Card thông tin bệnh nhân
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Thông tin bệnh nhân
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customRow(
                      image: AppIcons.user1,
                      titleOfImage: 'NGUYỄN HỮU THIỆN',
                      isBold: true,
                    ),
                    _customRow(
                        image: AppIcons.call, titleOfImage: '0901492845'),
                    _customRow(
                        image: AppIcons.calendar, titleOfImage: '01/07/2003'),
                    _customRow(
                        image: AppIcons.location,
                        titleOfImage: 'Thành phố Hồ Chí Minh'),
                  ],
                ),

                // Nút chọn
                ElevatedButton(
                  onPressed: () {
                    // Xử lý sự kiện chọn
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: const Text(
                    'Chọn',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Widget tạo dòng thông tin
Widget _customRow(
    {required String image,
    required String titleOfImage,
    bool isBold = false}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Image.asset(
          image,
          color: AppColors.accent,
          width: 20,
        ),
        const SizedBox(width: 10),
        Text(
          titleOfImage,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: AppColors.accent,
          ),
        ),
      ],
    ),
  );
}
