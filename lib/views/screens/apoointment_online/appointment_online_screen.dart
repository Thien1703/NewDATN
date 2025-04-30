import 'package:flutter/material.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/views/screens/apoointment_online/confirmAppointment_online_screen.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/selectedOnline/seleCustomerOnline.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/selectedOnline/seleServiceOnline.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/selectedOnline/seleSpecialtyOnline.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
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
  String? selectedTimes;
  Customer? customer;

  Specialty? _selectedSpecialty;
  int? _selectedServiceId;
  String? _selectedServiceName;

  bool get isFormValid =>
      customer != null &&
      _selectedSpecialty != null &&
      _selectedServiceId != null &&
      selectedDate != null &&
      selectedTimes != null;

  void _goToConfirmScreen() {
    if (!isFormValid) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) {
          return ConfirmappointmentOnlineScreen(
            specialtyId: _selectedSpecialty!.id,
            clinicId: widget.doctor.clinic.id,
            customer: customer,
            customerId: customer!.id,
            date: selectedDate!,
            employeeId: widget.doctor.id,
            time: selectedTimes!,
            serviceIds: [_selectedServiceId!],
            doctor: widget.doctor,
            specialtyName: _selectedSpecialty!.name,
          );
        },
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
              position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: AppColors.ghostWhite,
        child: Column(
          children: [
            _buildStepHeader(),
            Expanded(child: _buildFormContent()),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(color: Colors.white),
      title: const Text('Đặt lịch khám'),
      centerTitle: true,
      backgroundColor: AppColors.deepBlue,
      foregroundColor: Colors.white,
    );
  }

  Widget _buildStepHeader() {
    return Container(
      width: double.infinity,
      color: Colors.grey[400],
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildStepItem('1', 'Chọn lịch khám', AppColors.deepBlue, true),
              _buildStepItem('2', 'Xác nhận', const Color(0xFF656565), true),
              _buildStepItem(
                  '3', 'Nhận lịch hẹn', const Color(0xFF656565), false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDoctorInfo(),
          _buildSectionTitle('Đặt lịch khám này cho:'),
          Selecustomeronline(
              onCustomerSelected: (val) => setState(() => customer = val)),
          _buildSectionTitle('Chọn chuyên khoa'),
          _buildPickerTile(
            title: _selectedSpecialty?.name ?? 'Chọn chuyên khoa',
            onTap: () async {
              final selected = await showModalBottomSheet<Specialty>(
                context: context,
                isScrollControlled: true,
                builder: (_) =>
                    Selespecialtyonline(specialties: widget.doctor.specialties),
              );
              if (selected != null) {
                setState(() {
                  _selectedSpecialty = selected;
                  _selectedServiceId = null;
                  _selectedServiceName = null;
                });
              }
            },
          ),
          _buildSectionTitle('Chọn dịch vụ'),
          _buildPickerTile(
            title: _selectedServiceName ?? 'Chọn dịch vụ',
            onTap: () async {
              if (_selectedSpecialty == null) return;
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                builder: (_) => Seleserviceonline(
                    serviceId: _selectedSpecialty!.id.toString()),
              );
              if (result != null) {
                setState(() {
                  _selectedServiceName = result['name'];
                  _selectedServiceId = result['id'];
                });
              }
            },
          ),
          _buildSectionTitle('Chọn ngày khám'),
          _buildPickerTile(
            title: selectedDate != null
                ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                : 'Chọn ngày khám',
            onTap: () async {
              final selected = await showModalBottomSheet<DateTime>(
                context: context,
                builder: (_) =>
                    SelectDayWidget(clinicId: widget.doctor.clinic.id),
              );
              if (selected != null) {
                setState(() {
                  selectedDate = selected;
                  selectedTimes = null; // reset giờ khi chọn ngày mới
                });
              }
            },
          ),
          _buildSectionTitle('Chọn giờ khám'),
          _buildPickerTile(
            title: selectedTimes?.isNotEmpty == true
                ? selectedTimes!
                : 'Chọn giờ khám',
            onTap: () {
              if (selectedDate == null) return;
              showModalBottomSheet(
                context: context,
                builder: (_) => HeaderBottomSheet(
                  title: 'Chọn giờ khám',
                  body: WidgetSelectedTimeOnline(
                    doctorId: widget.doctor.id,
                    date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                    onTimeSelected: (time) {
                      setState(() => selectedTimes = time);
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey[400]!, blurRadius: 1, spreadRadius: 1)
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.deepBlue, width: 1),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 34,
              backgroundImage: NetworkImage(widget.doctor.avatar),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctor.qualification,
                    style: TextStyle(fontSize: 15)),
                Text(widget.doctor.fullName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 17)),
                Text(
                  'Chuyên khoa: ${widget.doctor.specialties.isNotEmpty ? widget.doctor.specialties.map((e) => e.name).join(', ') : "Chưa có chuyên khoa"}',
                  style: const TextStyle(fontSize: 15),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 12, bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check, size: 20, color: AppColors.deepBlue),
          const SizedBox(width: 5),
          Text(title,
              style:
                  const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPickerTile(
      {required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[400]!, blurRadius: 1, spreadRadius: 1)
            ],
          ),
          child: Text(title, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildStepItem(
      String number, String label, Color color, bool hasArrow) {
    return Row(
      children: [
        CircleAvatar(
          radius: 11.5,
          backgroundColor: color,
          child: Text(number,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        if (hasArrow)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Color(0xFF656565)),
          ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      color: Colors.grey[400],
      child: Container(
        width: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.only(top: 1),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ElevatedButton(
          onPressed: isFormValid ? _goToConfirmScreen : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepBlue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Tiếp tục',
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
