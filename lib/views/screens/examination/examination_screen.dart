import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';

class ExaminationScreen extends StatefulWidget {
  const ExaminationScreen({super.key});

  @override
  State<ExaminationScreen> createState() => _ExaminationScreenState();
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  List<AppointmentService>? appointmentServices;
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

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: false,
      title: 'Danh sách phiếu khám',
      body: SingleChildScrollView(
        child: Column(
          children: [
            appointmentServices != null
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appointmentServices!.length,
                    itemBuilder: (context, index) {
                      final appointmentService = appointmentServices![index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Column(
                          children: [
                            Text(appointmentService.appointmentId.toString()),
                            Text(appointmentService.serviceId.toString()),
                            Text(appointmentService.serviceName),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('Không có data'),
                  )
          ],
        ),
      ),
    );
  }
}
