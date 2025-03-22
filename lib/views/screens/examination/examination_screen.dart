import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/route_manager.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/examination/paidDetail_screen.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';

class ExaminationScreen extends StatefulWidget {
  const ExaminationScreen({super.key});

  @override
  State<ExaminationScreen> createState() => _ExaminationScreenState();
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  List<AppointmentService>? appointmentServices;
  String _selectedStatus = 'Tất cả';
  @override
  void initState() {
    super.initState();
    fetchAppointment();
  }

  void fetchAppointment() async {
    List<AppointmentService>? data =
        await AppointmentserviceApi.getAllAppointmentService();
    setState(() {
      appointmentServices = data;
    });
  }

  List<AppointmentService> get filteredAppointments {
    if (appointmentServices == null) return [];
    if (_selectedStatus == 'Tất cả') {
      return appointmentServices!;
    } else {
      return appointmentServices!
          .where((item) => item.appointment.status == _selectedStatus)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: false,
      title: 'Danh sách phiếu khám',
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCustomeButton(
                    label: 'Tất cả',
                    value: 'Tất cả',
                    onTap: () => setState(() {
                      _selectedStatus = 'Tất cả';
                    }),
                  ),
                  _buildCustomeButton(
                    label: 'Đã đặt khám',
                    value: 'PENDING',
                    onTap: () => setState(
                      () {
                        _selectedStatus = 'PENDING';
                      },
                    ),
                  ),
                  _buildCustomeButton(
                    label: 'Đã xác nhận',
                    value: 'CONFIRMED',
                    onTap: () => setState(
                      () {
                        _selectedStatus = 'CONFIRMED';
                      },
                    ),
                  ),
                  _buildCustomeButton(
                    label: 'Đã hủy',
                    value: 'CANCEL',
                    onTap: () => setState(
                      () {
                        _selectedStatus = 'CANCEL';
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFF0F2F5),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      filteredAppointments.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.only(top: 10),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredAppointments.length,
                              itemBuilder: (context, index) {
                                final appointmentService =
                                    filteredAppointments[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Mã đật lịch: ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xFF757575),
                                                    ),
                                                  ),
                                                  Text(
                                                    appointmentService.id
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                appointmentService.appointment
                                                    .customer.fullName,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PaidDetailScreen(
                                                        appointmentServiceId:
                                                            appointmentService
                                                                .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Xem chi tiết',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.deepBlue,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_right,
                                                color: AppColors.deepBlue,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      WidgetLineBold(),
                                      Text(
                                        appointmentService
                                            .appointment.clinic.name,
                                        style: TextStyle(
                                          color: AppColors.deepBlue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      _buildCustomeRow(
                                        label: 'Dịch vụ',
                                        value: appointmentService.service!.name,
                                      ),
                                      _buildCustomeRow(
                                        label: 'Chuyên khoa',
                                        value: appointmentService
                                            .service!.specialty.name,
                                      ),
                                      // Trong ListView.builder, thay phần dòng "Trạng thái" bằng:
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Trạng thái',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF757575),
                                              ),
                                            ),
                                            getStatusWidget(appointmentService
                                                .appointment.status),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text('Chưa có lịch '),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomeButton({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final bool isSelected = value == _selectedStatus;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 10),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.deepBlue : Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: isSelected ? AppColors.deepBlue : Color(0xFFF0F2F5),
                width: 1)),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomeRow({required String label, required String value}) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget getStatusWidget(String status) {
    String label;
    Color textColor;

    switch (status) {
      case "PENDING":
        label = "Đã đặt khám";
        textColor = Colors.green;
        break;
      case "CONFIRMED":
        label = "Đã xác nhận";
        textColor = AppColors.deepBlue;
        break;
      case "CANCEL":
        label = "Đã hủy";
        textColor = Colors.red;
        break;
      default:
        label = status;
        textColor = Colors.black;
    }
    return Text(
      label,
      style: TextStyle(
        color: textColor,
        fontSize: 15,
      ),
    );
  }
}
