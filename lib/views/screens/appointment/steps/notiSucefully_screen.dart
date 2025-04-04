import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/widgets/bottomSheet/showCustomer.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NotiSucefully extends StatefulWidget {
  const NotiSucefully({super.key, required this.appointmentId});
  final int appointmentId;

  @override
  State<NotiSucefully> createState() => _NotiSucefullyState();
}

class _NotiSucefullyState extends State<NotiSucefully> {
  List<AppointmentService>? appointmentServices;

  @override
  void initState() {
    super.initState();
    fetchAppointmentServices();
  }

  void fetchAppointmentServices() async {
    final services =
        await AppointmentserviceApi.getByAppointment(widget.appointmentId);
    setState(() {
      appointmentServices = services;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointment = appointmentServices?.first.appointment;
    final qrData = widget.appointmentId.toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F2F5),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreens()),
            );
          },
        ),
        title: Text(
          'Kết quả đặt khám',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: appointment == null
          ? Container(
              width: double.infinity,
              height: 700,
              alignment: Alignment.center,
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 35),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 25),
                                    const Text(
                                      'Đã đặt lịch',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          appointment.time.substring(0, 5),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700]),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          '${appointment.date.split("-")[2]}-${appointment.date.split("-")[1]}-${appointment.date.split("-")[0]}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700]),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Positioned(
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 34,
                                    backgroundColor:
                                        Color.fromARGB(255, 184, 235, 189),
                                    child: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 15),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text('Mã lịch khám',
                                            style: TextStyle(fontSize: 16)),
                                        Text(
                                          appointment.id.toString(),
                                          style: TextStyle(
                                            fontSize: 35,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    QrImageView(
                                      data: qrData, // Giữ nguyên QR code
                                      version: QrVersions.auto,
                                      size: 100,
                                      gapless: false,
                                    ),
                                  ],
                                ),
                                const WidgetLineBold(),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                appointment.clinic.image,
                                                width: 80,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: Text(
                                                appointment.clinic.name,
                                                softWrap: true,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        _buildRow(
                                          'Ngày khám',
                                          '${appointment.date.split("-")[2]}-${appointment.date.split("-")[1]}-${appointment.date.split("-")[0]}',
                                        ),
                                        _buildRow('Giờ khám',
                                            appointment.time.substring(0, 5)),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 10),
                                          child: Text(
                                            'THÔNG TIN BỆNH NHÂN',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        _buildRow('Họ và tên',
                                            appointment.customer.fullName),
                                        //             ? DateFormat('dd/MM/yyyy')
                                        // .format(DateTime.parse(customers!.birthDate))
                                        _buildRow(
                                            'Ngày sinh',
                                            appointment.customer.birthDate !=
                                                    null
                                                ? DateFormat('dd/MM/yyyy')
                                                    .format(DateTime.parse(
                                                        appointment.customer
                                                            .birthDate))
                                                : 'Chưa cập nhật'),
                                        _buildRow('Giới tính',
                                            appointment.customer.gender),
                                        _buildRow('Số điện thoại',
                                            appointment.customer.phoneNumber),
                                        SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.center,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    Showcustomer(),
                                              );
                                            },
                                            child: Text(
                                              'Xem chi tiết',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.deepBlue,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 10),
                            child: Text(
                              'Thông tin hộ trợ đặt khám',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _buildtitleRow(
                              icon: Icons.chat_rounded,
                              title: 'Chat với CSKH',
                              onTap: () {}),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 207, 207, 207),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          _buildtitleRow(
                              icon: Icons.event_note_outlined,
                              title: 'Hướng dẫn đặt khám',
                              onTap: () {}),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 207, 207, 207),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          _buildtitleRow(
                              icon: Icons.event_note_outlined,
                              title: 'Quy trình hủy lịch/hoàn tiền',
                              onTap: () {}),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: const Color.fromARGB(255, 201, 201, 201),
                        spreadRadius: 1,
                        blurRadius: 2)
                  ]),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreens(),
                        )),
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: 10, left: 40, right: 40, top: 10),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Về trang chủ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF757575),
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildtitleRow(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: const Color.fromARGB(255, 111, 111, 111),
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 111, 111, 111),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color.fromARGB(255, 111, 111, 111),
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
