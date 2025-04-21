import 'package:health_care/models/rating/rating.dart';
import 'package:health_care/viewmodels/api/rating_api.dart';
import 'package:health_care/views/screens/examination/paidDetail_screen.dart';
import 'package:health_care/views/screens/examination/ratingStar/showEvaluate_screen.dart';
import 'package:health_care/views/screens/examination/ratingStar/showServiceStar_screen.dart';
import 'package:health_care/views/screens/examination/unPaidDetail_screen.dart';
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
  Map<int, List<Rating>> appointmentRatings = {};
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

        // Gọi song song các API getRatingByAppointment cho mỗi appointment
        if (appointments != null) {
          for (var apm in appointments!) {
            final ratings = await RatingApi.getRatingByAppointment(apm.id);
            appointmentRatings[apm.id] = ratings ?? [];
          }
        }
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
          .where((item) => item.status.toUpperCase() == _selectedStatus)
          .toList();
  bool _shouldShowRating(Appointment appointment) {
    if (appointment.status != "COMPLETED") return false;

    // Nếu chưa có đánh giá nào → hiện nút
    final ratings = appointmentRatings[appointment.id];
    return ratings == null || ratings.isEmpty;
  }

  bool _hasUnratedService(int appointmentId) {
    final ratings = appointmentRatings[appointmentId];
    if (ratings == null || ratings.isEmpty) return true;

    // Nếu có bất kỳ dịch vụ nào status != true → chưa đánh giá hết
    return ratings.any((rating) => rating.status != true);
  }

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
                            padding: EdgeInsets.only(top: 15),
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
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 1,
              )
            ]),
        child: Text(label,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  Widget  _buildAppointmentCard(Appointment appointment) {
    return InkWell(
      onTap: () {
        appointment.status == "CANCELLED"
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UnpaiddetailScreen(
                    appointmentId: appointment.id,
                  ),
                ))
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaidDetailScreen(
                    appointmentId: appointment.id,
                    status: appointment.status,
                  ),
                ),
              );
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.only(bottom: 15, right: 15, left: 15),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusRow(appointment.status),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      appointment.clinic.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w800,
                      ),
                      softWrap: true,
                    ),
                  ),
                  SizedBox(width: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      appointment.clinic.image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              _buildLabelRow(
                icon: Icons.person,
                label: 'Bệnh nhân',
                value: appointment.customerProfile == null
                    ? appointment.customer.fullName
                    : appointment.customerProfile!.fullName,
              ),
              _buildLabelRow(
                  icon: Icons.date_range_rounded,
                  label: "Ngày khám",
                  value: formatDate(appointment.date)),
              _buildLabelRow(
                icon: Icons.access_time_filled_rounded,
                label: "Giờ khám",
                value: appointment.time.substring(0, 5),
                colorLabel: true,
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.topRight,
                child: appointment.status == "COMPLETED"
                    ? _hasUnratedService(appointment.id)
                        ? InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowservicestarScreen(
                                      appointmentId: appointment.id),
                                ),
                              );
                              if (result == true) {
                                fetchAppointments(); // Gọi lại API để load dữ liệu mới
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.circular(10),
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
                        : InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowevaluateScreen(
                                    appointmentId: appointment.id,
                                  ),
                                )),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Xem đánh giá',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String status) {
    final statusMap = {
      'PENDING': 'Đã đặt lịch',
      'CONFIRM': 'Đã xác nhận',
      'ARRIVED': 'Đã tới khám',
      'COMPLETED': 'Đã khám',
      'CANCELLED': 'Đã hủy'
    };
    final textColor = {
          'PENDING': Colors.blueAccent,
          'CONFIRM': Colors.orangeAccent,
          'ARRIVED': Colors.teal,
          'COMPLETED': Colors.green,
          'CANCELLED': Colors.redAccent
        }[status] ??
        Colors.black;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.2),
        border: Border.all(color: Color(0xFFDCEFDD), width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 5, backgroundColor: textColor),
          SizedBox(width: 7),
          Text(
            statusMap[status] ?? status,
            style: TextStyle(
                color: textColor, fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelRow({
    required IconData icon,
    required String label,
    required String value,
    bool? colorLabel,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Color(0xFF929191),
                size: 22,
              ),
              SizedBox(width: 5),
              Text(label,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF929191),
                    fontWeight: FontWeight.normal,
                  )),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: colorLabel != null
                  ? AppColors.deepBlue
                  : Colors.black.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
