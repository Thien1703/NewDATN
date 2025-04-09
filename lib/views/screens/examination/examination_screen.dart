import 'package:health_care/views/screens/examination/paidDetail_screen.dart';
import 'package:health_care/views/screens/examination/ratingStar/showServiceStar_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointment.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class ExaminationScreen extends StatefulWidget {
  const ExaminationScreen({super.key});

  @override
  State<ExaminationScreen> createState() => _ExaminationScreenState();
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  List<Appointment>? appointments;
  Customer? customer;
  String _selectedStatus = 'Tất cả';
  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  void fetchAppointments() async {
    try {
      customer = await CustomerApi.getCustomerProfile();
      if (customer != null) {
        appointments = await AppointmentApi.getAppointmentByCus(customer!.id);
      }
    } catch (e) {
      debugPrint("❗ Lỗi hệ thống: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<Appointment> get filteredAppointments => _selectedStatus == 'Tất cả'
      ? appointments ?? []
      : (appointments ?? [])
          .where((item) => item.status?.toUpperCase() == _selectedStatus)
          .toList();

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: false,
      title: 'Danh sách phiếu khám',
      body: Column(
        children: [
          _buildStatusFilter(),
          Expanded(
            child: Container(
              color: const Color(0xFFECECEC),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: isLoading
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
                    : filteredAppointments.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            itemCount: filteredAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment =
                                  filteredAppointments.reversed.toList()[index];
                              return _buildAppointmentCard(appointment);
                            },
                          )
                        : Center(child: Text('Không có lịch khám')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    final statuses = {
      'Tất cả': 'Tất cả',
      'Đã đặt khám': 'PENDING',
      'Đã xác nhận': 'CONFIRM',
      'Đã tới khám': 'ARRIVED',
      'Đã khám': 'COMPLETED',
      'Đã hủy': 'CANCELLED'
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: statuses.entries
            .map((entry) => _buildFilterButton(entry.key, entry.value))
            .toList(),
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isSelected = value == _selectedStatus;
    return InkWell(
      onTap: () => setState(() => _selectedStatus = value),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepBlue : Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isSelected ? AppColors.deepBlue : Color(0xFFF0F2F5),
              width: 1),
        ),
        child: Text(label,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaidDetailScreen(
                      appointmentId: appointment.id,
                      status: appointment.status,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDADADA), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow('Trạng thái', appointment.status),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    appointment.clinic.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                  ),
                ),
                SizedBox(width: 50),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    appointment.clinic.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            _buildLabelRow(
                label: "Giờ khám", value: appointment.time.substring(0, 5)),
            _buildLabelRow(
                label: "Ngày khám", value: formatDate(appointment.date)),
            _buildLabelRow(
                label: 'Bệnh nhân', value: appointment.customer.fullName),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.topRight,
              child: appointment.status == "COMPLETED"
                  ? InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowservicestarScreen(
                              appointmentId: appointment.id,
                            ),
                          )),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Đánh giá',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    final statusMap = {
      'PENDING': 'Đã đặt lịch',
      'CONFIRM': 'Đã xác nhận',
      'ARRIVED': 'Đã tới khám',
      'COMPLETED': 'Đã khám',
      'CANCELLED': 'Đã hủy'
    };
    final textColor = {
          'PENDING': Colors.green,
          'CONFIRM': AppColors.deepBlue,
          'ARRIVED': AppColors.softBlue,
          'COMPLETED': AppColors.deepBlue,
          'CANCELLED': Colors.red
        }[status] ??
        Colors.black;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.2),
        border: Border.all(color: Color(0xFFDCEFDD), width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: textColor),
          SizedBox(width: 5),
          Text(statusMap[status] ?? status,
              style: TextStyle(
                  color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLabelRow({required String label, required String value}) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                fontWeight: FontWeight.normal,
              )),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
