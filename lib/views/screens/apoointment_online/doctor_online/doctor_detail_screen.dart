import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/employee.dart';
import 'package:health_care/views/screens/apoointment_online/appointment_online_screen.dart';
import 'package:intl/intl.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Employee employee;

  const DoctorDetailScreen({super.key, required this.employee});

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  bool _showGeneralInfo =
      true; // Mặc định là true để hiển thị "Thông tin chung"
  bool _showRating = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 183, 222, 253),
            Colors.white
          ], // 2 màu
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.05),
                  Center(
                    child: Container(
                      width: size.width * 0.28, // gấp đôi radius
                      height: size.width * 0.28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.deepBlue, // màu viền xanh
                          width: 3.0, // độ dày viền
                        ),
                      ),
                      child: CircleAvatar(
                        radius: size.width * 0.14,
                        backgroundImage: NetworkImage(widget.employee.avatar),
                        onBackgroundImageError: (_, __) {},
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bác sĩ ${widget.employee.fullName}',
                    style: TextStyle(
                        fontSize: isSmall ? 18 : 25,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepBlue),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Ngày sinh: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat('dd / MM / yyyy').format(
                              DateTime.parse(widget.employee.birthDate)),
                          softWrap: true,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Text(
                        'Giới tính: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.employee.gender == 'Male' ? 'Nam' : 'Nữ',
                          softWrap: true,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Text(
                        'Lịch khám: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Thứ 2, 3, 4, 5, 6, 7, Chủ nhật',
                          softWrap: true,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),

                  Text(
                    'Các chuyên khoa',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  widget.employee.specialty.isEmpty
                      ? Text(
                          'Chưa có chuyên khoa',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      : Container(
                          height: size.height * 0.13,
                          child: ListView.builder(
                            scrollDirection:
                                Axis.horizontal, // Cuộn theo chiều ngang
                            itemCount: widget.employee.specialty.length,
                            itemBuilder: (context, index) {
                              final specialty =
                                  widget.employee.specialty[index];
                              return Container(
                                width: size.width *
                                    0.25, // Cố định chiều dài cho Container
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Màu nền cho mỗi chuyên khoa
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    specialty.name,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(
                      height:
                          20), // Thêm khoảng cách giữa chuyên khoa và các nút
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showGeneralInfo = true; // Hiển thị thông tin chung
                            _showRating = false; // Ẩn đánh giá
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Text(
                                "Thông tin chung",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _showGeneralInfo
                                      ? AppColors.deepBlue
                                      : Colors.black,
                                ),
                              ),
                            ),
                            if (_showGeneralInfo)
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                height: 2,
                                width: size.width * 0.4,
                                color: AppColors.deepBlue,
                              ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showGeneralInfo = false; // Ẩn thông tin chung
                            _showRating = true; // Hiển thị đánh giá
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Text(
                                "Đánh giá",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _showRating
                                      ? AppColors.deepBlue
                                      : Colors.black,
                                ),
                              ),
                            ),
                            if (_showRating)
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                height: 2,
                                width: size.width * 0.4,
                                color: AppColors.deepBlue,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Hiển thị thông tin chung nếu nút được nhấn
                  Visibility(
                    visible: _showGeneralInfo,
                    child: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BS. ${widget.employee.fullName}, hiện đang công tác tại Phòng khám ${widget.employee.clinic.name}, là người có nhiều kinh nghiệm trong lĩnh vực Nội khoa- Da liễu.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Bác sĩ ${widget.employee.fullName} đã hoàn thành lớp kiến thức và thực hành cơ bản chuyên khoa Da Liễu tại Đại Học Y Dược TP HCM loại giỏi, hoàn thành các khóa đào tạo liên tục hằng năm.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            'Quá trình đào tạo',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '- Hoàn thành lớp kiến thức và thực hành cơ bản chuyên khoa Da Liễu tại Đại Học Y Dược TP HCM loại giỏi',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '- Hoàn thành lớp kỹ thuật tiêm chất làm đầy trong thẩm mỹ tại Đại Học Y Dược TP HCM loại giỏi',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '- Hoàn thành lớp kỹ thuật Botouliumtoxin trong thẩm mỹ da tại Đại Học Y Dược TPHCM loại giỏi',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '- Hoàn thành lớp căng chỉ trong thẩm mỹ da tại Đại Học Y Dược TPHCM loại giỏi',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '- Hoàn thành các khóa đào tạo liên thực hằng nằm',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            'Quá trình công tác',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '-Năm 2021 - 2025: Phòng khám Đa Khoa FPT địa chỉ ${widget.employee.clinic.name}',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        )
                      ],
                    )),
                  ),
                  // Hiển thị đánh giá nếu nút được nhấn
                  Visibility(
                    visible: _showRating,
                    child: Container(
                      child: Center(
                        child: Text(
                          'Chưa có đánh giá.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.black, size: 20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: isSmall ? 10 : 12,
                  horizontal: isSmall ? 16 : 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AppointmentOnlineScreen(doctor: widget.employee),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: isSmall ? 10 : 12),
                    backgroundColor: AppColors.deepBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Đặt lịch hẹn",
                    style: TextStyle(
                      fontSize: isSmall ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
