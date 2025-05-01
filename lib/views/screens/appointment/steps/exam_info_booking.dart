import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/views/screens/appointment/steps/selectedSteps/selected_Service.dart';
import 'package:health_care/views/screens/appointment/steps/selectedSteps/selected_Specialty.dart';
import 'package:health_care/views/widgets/appointment/widget_hospital_info_card.dart';
import 'package:health_care/views/widgets/widget_select_item.dart';
import 'package:health_care/views/widgets/appointment/widget_customButton.dart';
import 'package:health_care/views/widgets/bottomSheet/select_day_widget.dart';
import 'package:health_care/views/widgets/bottomSheet/select_time_widget.dart';
import 'package:health_care/models/clinic.dart';
import 'package:intl/intl.dart';

class ExamInfoBooking extends StatefulWidget {
  const ExamInfoBooking({
    super.key,
    required this.onNavigateToScreen,
    required this.clinic,
  });

  final void Function(
    int,
    String, {
    Clinic clinic,
    List<int>? serviceIds,
    String? date,
    String? time,
  }) onNavigateToScreen;
  final Clinic clinic;

  @override
  State<ExamInfoBooking> createState() => _ExamInfoBooking();
}

class _ExamInfoBooking extends State<ExamInfoBooking> {
  Clinic? clinices;
  int? selectedSpecialtyId = 0;
  List<int> selectedServiceId = [];
  DateTime? selectedDate; // Lưu ngày
  String? selectedTime; // Lưu giờ

  void updateSelectedSpecialty(int id) {
    setState(() {
      selectedSpecialtyId = id;
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
    bool isServiceSelected = selectedServiceId.isNotEmpty;
    bool isDateSelected = selectedDate != null;
    bool isTimeSelected = selectedTime != null;
    bool isButtonEnabled =
        isServiceSelected && isDateSelected && isTimeSelected;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                HospitalInfoWidget(
                  clinic: widget.clinic,
                ),
                SectionTitle(title: 'Chuyên khoa'),
                SelectedSpecialty(
                  onSelected: updateSelectedSpecialty,
                ),
                SectionTitle(title: 'Dịch vụ'),
                IgnorePointer(
                  ignoring: selectedSpecialtyId == 0,
                  child: Opacity(
                    opacity: selectedSpecialtyId != 0 ? 1 : 0.5,
                    child: SelectedService(
                      specialtyId: selectedSpecialtyId!,
                      onServiceSelected: (ids) {
                        setState(() {
                          selectedServiceId = ids;
                        });
                      },
                    ),
                  ),
                ),
                SectionTitle(title: 'Ngày khám'),
                IgnorePointer(
                  ignoring: !isServiceSelected,
                  child: Opacity(
                    opacity: isServiceSelected ? 1 : 0.5,
                    child: DateSelector(
                      onDateSelected: updateSelectedDate,
                      clinicId: widget.clinic.id,
                    ),
                  ),
                ),
                SectionTitle(title: 'Giờ khám'),
                IgnorePointer(
                  ignoring: !isDateSelected,
                  child: Opacity(
                    opacity: isDateSelected ? 1 : 0.5,
                    child: TimeSelector(
                      onTimeSelected: updateSelectedTime,
                      selectedDate: selectedDate,
                      clinicId: widget.clinic.id,
                      specialtyId: selectedSpecialtyId!,
                    ),
                  ),
                ),
              ],
            ),
          ),
          WidgetCustombutton(
            onTap: isButtonEnabled
                ? () {
                    widget.onNavigateToScreen(
                      1,
                      'Chọn hồ sơ',
                      clinic: widget.clinic,
                      serviceIds: selectedServiceId,
                      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                      time: selectedTime!,
                    );
                  }
                : null, // Vô hiệu hóa nút nếu chưa chọn đủ
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

class DateSelector extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final int clinicId;
  const DateSelector(
      {super.key, required this.onDateSelected, required this.clinicId});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime? _selectedDate;

  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true, // Quan trọng để tự động co giãn
      builder: (context) => SelectDayWidget(
        clinicId: widget.clinicId,
      ),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });

      widget.onDateSelected(pickedDate);
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
      color:
          _selectedDate != null ? AppColors.deepBlue : const Color(0xFF484848),
      colorIcon:
          _selectedDate != null ? AppColors.deepBlue : const Color(0xFF484848),
    );
  }
}

class TimeSelector extends StatefulWidget {
  final Function(String) onTimeSelected;
  final DateTime? selectedDate;
  final int clinicId;
  final int? specialtyId;
  const TimeSelector({
    super.key,
    required this.onTimeSelected,
    this.selectedDate,
    required this.clinicId,
    required this.specialtyId,
  });

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
    // Kiểm tra và khởi tạo các giá trị mặc định nếu là null
    DateTime date = widget.selectedDate ??
        DateTime.now(); // Sử dụng DateTime hiện tại nếu selectedDate là null
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    int specialtyId =
        widget.specialtyId ?? 0; // Sử dụng 0 nếu specialtyId là null

    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: SelectItemWidget(
        image: AppIcons.clock,
        text: selectedTime,
        bottomSheet: SelectTimeWidget(
          onTimeSelected: updateSelectedTime,
          selectedDate: formattedDate,
          clinicId: widget.clinicId,
          specialtyId:
              specialtyId, // Truyền specialtyId đã được khởi tạo giá trị
        ),
        color: selectedTime != 'Chọn giờ khám'
            ? AppColors.deepBlue
            : Color(0xFF484848),
        colorIcon: selectedTime != 'Chọn giờ khám'
            ? AppColors.deepBlue
            : Color(0xFF484848),
      ),
    );
  }
}
