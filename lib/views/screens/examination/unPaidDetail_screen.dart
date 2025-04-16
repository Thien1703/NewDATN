import 'package:flutter/material.dart';
import 'package:health_care/models/appointment/appointment.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/views/screens/examination/paidDetail_screen.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class UnpaiddetailScreen extends StatefulWidget {
  const UnpaiddetailScreen({super.key, required this.appointmentId});
  final int appointmentId;
  @override
  State<UnpaiddetailScreen> createState() => _UnpaiddetailScreen();
}

class _UnpaiddetailScreen extends State<UnpaiddetailScreen> {
  Appointment? appointment;
  @override
  void initState() {
    super.initState();
    fetchAppointment();
  }

  void fetchAppointment() async {
    Appointment? data =
        await AppointmentApi.getAppointmentById(widget.appointmentId);
    setState(() {
      appointment = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Chi tiết đơn hủy',
      body: appointment != null
          ? Container(
              color: const Color(0xFFECECEC),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    _buildContainer(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đã hủy lịch khám',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.check_circle_outline_outlined,
                            size: 28,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    _buildContainer(
                      Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  appointment!.clinic.image,
                                  width: 100,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment!.clinic.name,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          _buildRowValueLabel(
                              value: 'Yêu cầu bởi', label: 'Người dùng'),
                          _buildRowValueLabel(
                              value: 'Lý do',
                              label: '${appointment!.cancelNote}')
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaidDetailScreen(
                              appointmentId: appointment!.id,
                              status: appointment!.status,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Chi tiết lịch khám',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: double.infinity,
              height: 700,
              alignment: Alignment.center,
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
    );
  }

  Widget _buildRowValueLabel({required String value, required String label}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 140),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1),
        ],
      ),
      child: child,
    );
  }
}
