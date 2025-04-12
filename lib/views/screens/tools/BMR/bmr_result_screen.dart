import 'package:flutter/material.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/screens/tools/gender_enum.dart';
import 'dart:math';

class BmrResultScreen extends StatelessWidget {
  final double bmr;
  final Gender gender;

  BmrResultScreen({required this.bmr, required this.gender});

  String getStatusText() {
    if (bmr < 1200) return 'Thấp';
    if (bmr < 1800) return 'Trung bình';
    return 'Cao';
  }

  String getStatusDescription() {
    if (bmr < 1200) {
      return 'Chỉ số BMR thấp có nghĩa là cơ thể bạn đốt cháy ít năng lượng khi ở trạng thái nghỉ ngơi. Điều này không có nghĩa là tốt hay xấu vì nó còn phụ thuộc vào chiều cao, cân nặng và độ tuổi của bạn.';
    } else if (bmr < 1800) {
      return 'Chỉ số BMR trung bình, phản ánh một mức độ trao đổi chất ổn định và phù hợp với đa số người trưởng thành.';
    } else {
      return 'Chỉ số BMR cao, nghĩa là cơ thể bạn tiêu tốn nhiều năng lượng ngay cả khi nghỉ ngơi. Điều này có thể đi kèm với khối lượng cơ bắp cao hoặc mức độ hoạt động cao.';
    }
  }

  int getStatusIndex() {
    if (bmr < 1200) return 0;
    if (bmr < 1400) return 1;
    if (bmr < 1600) return 2;
    if (bmr < 1800) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final statusColors = [
      Colors.blue,
      Colors.green.shade400,
      Colors.green,
      Colors.amber,
      Colors.deepOrange,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Công cụ tính chỉ số BMR'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.grey[600],
              size: 20,
            ),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeScreens())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 220,
                  child: CustomPaint(
                    painter: ArcGaugePainter(
                      activeIndex: getStatusIndex(),
                      colors: statusColors,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Image.asset('assets/images/food.jpg', height: 60),
                    const SizedBox(height: 8),
                    Text(
                      '${bmr.toStringAsFixed(0)} kcal',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Thấp'),
                Text('Cao'),
              ],
            ),
            const SizedBox(height: 20),
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Tình trạng'),
                      Tab(text: 'Nguy cơ'),
                      Tab(text: 'Giải thích'),
                    ],
                  ),
                  SizedBox(
                    height: 130,
                    child: TabBarView(
                      children: [
                        Text(getStatusDescription()),
                        Text(
                            'Nguy cơ sẽ phụ thuộc vào việc chỉ số BMR quá thấp (có thể dẫn đến mệt mỏi, thiếu năng lượng) hoặc quá cao (có thể gây áp lực lên tim mạch nếu không kiểm soát tốt).'),
                        Text(
                            'BMR giúp đánh giá lượng calo tiêu hao trong trạng thái nghỉ ngơi, từ đó xác định nhu cầu năng lượng cơ bản mỗi ngày.'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  "Kiểm tra lại",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ArcGaugePainter extends CustomPainter {
  final int activeIndex;
  final List<Color> colors;

  ArcGaugePainter({required this.activeIndex, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final sectionAngle = pi / colors.length;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 16
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final startAngle = pi + sectionAngle * i;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngle - 0.1,
        false,
        paint,
      );
    }

    // draw indicator arrow
    final arrowPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final arrowAngle = pi + sectionAngle * activeIndex + sectionAngle / 2;
    final arrowLength = radius - 8;
    final dx = center.dx + arrowLength * cos(arrowAngle);
    final dy = center.dy + arrowLength * sin(arrowAngle);
    canvas.drawCircle(Offset(dx, dy), 5, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
