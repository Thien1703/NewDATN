import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';
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
    final qrData = widget.appointmentId.toString(); // Dữ liệu QR giữ nguyên

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 35),
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                          color: AppColors.deepBlue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (appointment != null) ...[
                        Text(
                          appointment.time,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        Text(
                          appointment.date,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ]
                    ],
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: Color.fromARGB(255, 184, 235, 189),
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
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Column(
                        children: [
                          Text('STT', style: TextStyle(fontSize: 16)),
                          Text(
                            '2',
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: appointment != null
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      appointment.clinic.image,
                                      width: 80,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
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
                                  'Mã lịch khám', appointment.id.toString()),
                              _buildRow('Ngày khám', appointment.date),
                              _buildRow('Giờ khám', appointment.time),
                            ],
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ],
        ),
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
}
