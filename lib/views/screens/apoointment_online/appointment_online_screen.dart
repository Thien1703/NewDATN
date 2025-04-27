import 'package:flutter/material.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/views/screens/apoointment_online/confirmAppointment_online_screen.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/selectedOnline/seleCustomerOnline.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/selectedOnline/seleServiceOnline.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/selectedOnline/seleSpecialtyOnline.dart';
import 'package:health_care/views/widgets/bottomSheet/select_day_widget.dart';
import 'package:health_care/views/widgets/widgetSelectedTimeOnline.dart';
import 'package:intl/intl.dart';

import 'package:health_care/common/app_colors.dart';

class AppointmentOnlineScreen extends StatefulWidget {
  final Doctor doctor;

  const AppointmentOnlineScreen({super.key, required this.doctor});

  @override
  State<AppointmentOnlineScreen> createState() =>
      _AppointmentOnlineScreenState();
}

class _AppointmentOnlineScreenState extends State<AppointmentOnlineScreen> {
  DateTime? selectedDate;
  Customer? customer;
  Specialty? _selectedSpecialty;
  String? _selectedSpecialtyId;
  String? _selectedServiceName;
  int? _selectedServiceId;
  String? selectedTimes;
  bool _isAppointmentValid() {
    return _selectedSpecialty != null &&
        _selectedServiceId != null &&
        selectedDate != null &&
        selectedTimes != null &&
        customer != null; // Ensure customer is selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Đặt lịch khám'),
        centerTitle: true, // Căn giữa title
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
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 1),
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
                  child: Row(
                    children: [
                      _buildTItleRow(
                          '1', 'Chọn lịch khám', AppColors.deepBlue, true),
                      _buildTItleRow('2', 'Xác nhận', Color(0xFF656565), true),
                      _buildTItleRow(
                          '3', 'Nhận lịch hẹn', Color(0xFF656565), false),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      padding:
                          EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400]!,
                              blurRadius: 1,
                              spreadRadius: 1,
                            )
                          ]),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.deepBlue, width: 1),
                              shape: BoxShape.circle, // ✅ bo tròn viền
                            ),
                            child: CircleAvatar(
                              radius: 34,
                              backgroundImage:
                                  NetworkImage(widget.doctor.avatar),
                              onBackgroundImageError: (_, __) {},
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            // Thêm cái này để Column có thể co giãn và không bị tràn
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bác sĩ',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  widget.doctor.fullName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                ),
                                Text(
                                  'Chuyên khoa: ${widget.doctor.specialties.isNotEmpty ? widget.doctor.specialties.map((e) => e.name).join(', ') : "Chưa có chuyên khoa"}',
                                  style: TextStyle(fontSize: 15),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildTitle('Đặt lịch khám này cho: '),
                    Selecustomeronline(
                      onCustomerSelected: (value) {
                        setState(() {
                          customer = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTitle('Chọn chuyên khoa'),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 25, right: 12, top: 10, bottom: 10),
                      child: InkWell(
                        onTap: () async {
                          final selected =
                              await showModalBottomSheet<Specialty>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Selespecialtyonline(
                              specialties: widget.doctor.specialties,
                            ),
                          );

                          if (selected != null) {
                            setState(() {
                              _selectedSpecialty = selected;
                              _selectedSpecialtyId =
                                  selected.id.toString(); // Lưu id chuyên khoa
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ]),
                          child: Text(
                            _selectedSpecialty?.name ?? 'Chọn chuyên khoa',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    // Text(
                    //   _selectedSpecialtyId != null
                    //       ? 'SpecialtyId: $_selectedSpecialtyId'
                    //       : 'SpecialtyId: Chưa chọn',
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    // ),
                    _buildTitle('Chọn dịch vụ'),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 25, right: 12, top: 10, bottom: 10),
                      child: InkWell(
                        onTap: () async {
                          final result =
                              await showModalBottomSheet<Map<String, dynamic>>(
                            context: context,
                            builder: (context) => Seleserviceonline(
                              serviceId: _selectedSpecialtyId.toString(),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _selectedServiceName = result['name'];
                              _selectedServiceId = result['id'];
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ]),
                          child: Text(
                            _selectedServiceName ?? 'Chọn dịch vụ',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),

                    _buildTitle('Chọn ngày khám'),
                    InkWell(
                      onTap: () async {
                        final selected = await showModalBottomSheet<DateTime>(
                          context: context,
                          builder: (context) => SelectDayWidget(
                            clinicId: widget.doctor.clinic.id,
                          ),
                        );

                        if (selected != null) {
                          setState(() {
                            selectedDate = selected; // Update selectedDate here
                          });
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 25, right: 12, top: 10, bottom: 10),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400]!,
                                blurRadius: 1,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            selectedDate != null
                                ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                                : 'Chọn ngày khám', // Display selected date
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    _buildTitle('Chọn giờ khám'),
                    Widgetselectedtimeonline(
                      onTimeSelected: (time) {
                        setState(() {
                          selectedTimes = time;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[400]!,
              child: Container(
                margin: EdgeInsets.only(top: 1),
                color: Colors.white,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    color: Colors.white,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isAppointmentValid()
                          ? () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return ConfirmappointmentOnlineScreen(
                                      specialtyId: int.tryParse(
                                              _selectedSpecialtyId ?? '') ??
                                          0,
                                      clinicId: widget.doctor.clinic.id,
                                      customer: customer,
                                      customerId: customer!.id,
                                      date: selectedDate!,
                                      employeeId: widget.doctor.id,
                                      time: selectedTimes.toString(),
                                      serviceIds: [_selectedServiceId ?? 0],
                                      doctor: widget.doctor,
                                      specialtyName: _selectedSpecialty?.name ??
                                          'Chưa chọn chuyên khoa',
                                    );
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                        position: offsetAnimation,
                                        child: child);
                                  },
                                ),
                              );
                            }
                          : null, // Disable the button if validation fails
                      child: const Text(
                        "Tiếp tục",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String value) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 10),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: AppColors.deepBlue,
            size: 20,
          ),
          SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget _buildTItleRow(String value, String label, Color colors, bool icon) {
    return Row(
      children: [
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            color: colors, // màu nền hình tròn
            shape: BoxShape.circle, // tạo hình tròn
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
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
                color: const Color(0xFF656565),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
