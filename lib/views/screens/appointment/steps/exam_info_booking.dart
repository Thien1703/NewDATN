import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/viewmodels/api/api_service.dart';
import 'package:health_care/views/widgets/appointment/widget_hospital_info_card.dart';
import 'package:health_care/views/widgets/widget_select_item.dart';
import 'package:health_care/views/widgets/appointment/widget_customButton.dart';
import 'package:health_care/views/widgets/bottomSheet/select_day_widget.dart';
import 'package:health_care/views/widgets/bottomSheet/select_time_widget.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/views/screens/cartService/serviceCart_screen.dart';
import 'package:health_care/models/service.dart';
import 'package:intl/intl.dart';

class ExamInfoBooking extends StatefulWidget {
  const ExamInfoBooking({
    super.key,
    required this.onNavigateToScreen,
    required this.clinicId,
  });

  final void Function(int, String,
      {int? clinicId,
      List<int>? serviceIds,
      String? date,
      String? time}) onNavigateToScreen;
  final int clinicId;

  @override
  State<ExamInfoBooking> createState() => _ExamInfoBooking();
}

class _ExamInfoBooking extends State<ExamInfoBooking> {
  Clinic? clinices;
  List<int> selectedServiceId = [];
  DateTime? selectedDate; // Thêm biến lưu ngày
  String? selectedTime; // Thêm biến lưu giờ

  @override
  void initState() {
    super.initState();
    fetchClinics();
  }

  void fetchClinics() async {
    Clinic? data = await ApiService.getClinicById(widget.clinicId);
    if (data != null) {
      setState(() {
        clinices = data;
      });
    }
  }

  void updateSelectedServices(List<int> serviceIds) {
    setState(() {
      selectedServiceId = serviceIds;
    });
  }

  void updateSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void updateSelectedTime(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                HospitalInfoWidget(
                  nameHospital: clinices?.name ?? 'Đang tải',
                  addressHospital: clinices?.address ?? "Đang tải",
                ),
                SectionTitle(title: 'Dịch vụ'),
                ServiceSelector(onServicesSelected: updateSelectedServices),
                SectionTitle(title: 'Ngày khám'),
                DateSelector(onDateSelected: updateSelectedDate),
                SectionTitle(title: 'Giờ khám'),
                TimeSelector(onTimeSelected: updateSelectedTime),
              ],
            ),
          ),
          WidgetCustombutton(
            onTap: () {
              print(
                "Dữ liệu gửi sang ProfileBooking: clinicId = ${widget.clinicId}, dịch vụ: $selectedServiceId, ngày: $selectedDate, giờ: $selectedTime",
              );
              widget.onNavigateToScreen(
                1,
                'Chọn hồ sơ',
                clinicId: widget.clinicId,
                serviceIds: selectedServiceId,
                date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                time: selectedTime!,
              );
            },
            text: 'Tiếp tục',
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.neutralDarkGreen1,
        ),
      ),
    );
  }
}

class ServiceSelector extends StatefulWidget {
  final Function(List<int>)
      onServicesSelected; // Nhận callback để truyền lên ExamInfoBooking
  const ServiceSelector({super.key, required this.onServicesSelected});

  @override
  State<ServiceSelector> createState() => _ServiceSelectorState();
}

class _ServiceSelectorState extends State<ServiceSelector> {
  List<Service> selectedServices = [];
  List<int> selectedServiceId = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectItemWidget(
          image: AppIcons.service2,
          text: selectedServices.isEmpty
              ? 'Chọn dịch vụ'
              : 'Đã chọn ${selectedServices.length} dịch vụ',
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ServicecartScreen()),
            );

            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                selectedServices =
                    List<Service>.from(result['selectedServiceList']);
                selectedServiceId = List<int>.from(result['selectedServiceId']);
              });

              // Gọi callback để truyền dữ liệu lên ExamInfoBooking
              widget.onServicesSelected(selectedServiceId);
            }
          },
        ),
        if (selectedServices.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...selectedServices.map((service) => Text(
                      "- ${service.name}",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    )),
              ],
            ),
          ),
      ],
    );
  }
}

class DateSelector extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  const DateSelector({super.key, required this.onDateSelected});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime? _selectedDate;

  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) => SelectDayWidget(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      widget.onDateSelected(pickedDate); // Truyền ngày lên ExamInfoBooking
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectItemWidget(
      image: AppIcons.calendar,
      text: _selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
          : 'Chọn ngày khám',
      onTap: () => _showDatePicker(context),
    );
  }
}

class TimeSelector extends StatefulWidget {
  final Function(String) onTimeSelected;
  const TimeSelector({super.key, required this.onTimeSelected});

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  String selectedTime = 'Chọn giờ khám';

  void updateSelectedTime(String time) {
    setState(() {
      selectedTime = time;
    });
    widget.onTimeSelected(time); // Truyền giờ lên ExamInfoBooking
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: SelectItemWidget(
        image: AppIcons.clock,
        text: selectedTime,
        bottomSheet: SelectTimeWidget(onTimeSelected: updateSelectedTime),
      ),
    );
  }
}
