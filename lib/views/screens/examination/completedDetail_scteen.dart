import 'package:flutter/material.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class CompletedDetailScteen extends StatelessWidget {
  const CompletedDetailScteen({super.key});
  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      title: 'Chi tiết thăm khám',
      iconBack: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin thăm khám
            _buildSectionHeader('Thăm khám'),
            _buildInfoRow('Nơi khám', 'Phòng Khám Đa Khoa Pháp Anh'),
            _buildInfoRow('Người khám', 'Bác sĩ Nguyễn Tuấn Phong'),
            _buildInfoRow('Ngày khám', '11:50 - 3/1/2025'),
            _buildInfoRow('Bệnh nhân', 'Nguyễn Thị Ánh Tuyết'),
            SizedBox(height: 16),
            Divider(
                color: Colors.grey.withOpacity(0.5), thickness: 0.5, height: 1),
            SizedBox(height: 16),
            // Chỉ số dấu hiệu sinh tồn
            _buildSectionHeader('Chỉ số dấu hiệu sinh tồn'),
            _buildInfoRow('Nhiệt độ', '36.8°C'),
            _buildInfoRow('Mạch', '72 bpm'),
            _buildInfoRow('Huyết áp', '118/76 mmHg'),
            _buildInfoRow('Nhịp thở', '16 lần/phút'),
            SizedBox(height: 16),
            Divider(
                color: Colors.grey.withOpacity(0.5), thickness: 0.5, height: 1),
            SizedBox(height: 16),
            // Chẩn đoán
            _buildSectionHeader('Chẩn đoán'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Viêm đường hô hấp trên',
                style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 128, 172, 130)),
              ),
            ),
            SizedBox(height: 16),
            Divider(
                color: Colors.grey.withOpacity(0.5), thickness: 0.5, height: 1),
            SizedBox(height: 16),
            // Đơn thuốc
            _buildSectionHeader('Đơn thuốc'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Table(
                border: TableBorder.symmetric(
                    inside: BorderSide(color: Colors.green)),
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 233, 219)),
                    children: [
                      _buildTableCell('Tên thuốc', isHeader: true),
                      _buildTableCell('Cách sử dụng', isHeader: true),
                      _buildTableCell('Ghi chú', isHeader: true),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell('Paracetamol'),
                      _buildTableCell('Ngày uống 3 lần'),
                      _buildTableCell('Uống sau ăn'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Divider(
                color: Colors.grey.withOpacity(0.5), thickness: 0.5, height: 1),
            SizedBox(height: 19),
            // Ghi chú
            _buildSectionHeader('Ghi chú'),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Mặc đồ thoáng mát, theo dõi nhiệt độ thường xuyên, có các dấu hiệu bất thường đến cơ sở y tế gần nhất.',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 128, 172, 130)),
                )),

            SizedBox(height: 16),
            Divider(
                color: Colors.grey.withOpacity(0.5), thickness: 0.5, height: 1),

            SizedBox(height: 19),
            // Tái khám
            _buildSectionHeader('Tái khám'),
            _buildInfoRow('Ngày tái khám', '08:00 - 12/1/2025.'),
            _buildInfoRow('Liên hệ', '0909511768 - BS. Phong'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 128, 172, 130)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: TextStyle(
                fontSize: 15,
                color: const Color.fromARGB(255, 128, 172, 130),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTableCell(String text, {bool isHeader = false}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 14,
        color: isHeader
            ? const Color.fromARGB(255, 58, 150, 61)
            : const Color.fromARGB(255, 0, 0, 0),
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}
