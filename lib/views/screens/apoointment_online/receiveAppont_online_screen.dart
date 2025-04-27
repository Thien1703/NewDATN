import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';

class ReceiveappontOnlineScreen extends StatefulWidget {
  const ReceiveappontOnlineScreen({
    super.key,
  });

  @override
  State<ReceiveappontOnlineScreen> createState() =>
      _ReceiveappontOnlineScreenState();
}

class _ReceiveappontOnlineScreenState extends State<ReceiveappontOnlineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Thanh toán'),
        centerTitle: true,
        backgroundColor: AppColors.deepBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: AppColors.ghostWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[400]!,
              child: Container(
                margin: EdgeInsets.only(bottom: 1),
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTItleRow('1', 'Chọn lịch khám', Colors.green, true),
                    _buildTItleRow('2', 'Xác nhận', Colors.green, true),
                    _buildTItleRow(
                        '3', 'Nhận lịch hẹn', AppColors.deepBlue, false),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Xác nhận đặt lịch",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String value) {
    return Padding(
        padding: EdgeInsets.only(left: 35, top: 5, bottom: 5),
        child: Text(
          value,
          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
        ));
  }

  Widget _buildTItleRow(String value, String label, Color colors, bool icon) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: colors,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: colors,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 5),
        icon == true
            ? Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: const Color.fromARGB(255, 136, 136, 136),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
