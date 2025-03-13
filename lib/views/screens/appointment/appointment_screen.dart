import 'package:flutter/material.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/views/screens/appointment/steps/confirm_booking.dart';
import 'package:health_care/views/screens/appointment/steps/exam_info_booking.dart';
import 'package:health_care/views/screens/appointment/steps/payment_method_booking.dart';
import 'package:health_care/views/screens/appointment/steps/profile_booking.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({
    super.key,
    required this.clinicId,
  });
  final int clinicId;
  @override
  State<AppointmentScreen> createState() => _AppointmentScreen();
}

class _AppointmentScreen extends State<AppointmentScreen> {
  int _currentIndex = 0;
  String _showTitleScreen = 'Chọn thông tin khám';
  int? customerId; // Thêm biến customerId
  late final List<Widget> _screens;
  late List<bool> _isSelected;
  @override
  void initState() {
    super.initState();
    _isSelected = [true, false, false, false];
    _screens = [
      ExamInfoBooking(
        onNavigateToScreen: navigateToScreen,
        clinicId: widget.clinicId,
      ),
      ProfileBooking(
        onNavigateToScreen: navigateToScreen,
        clinicId: widget.clinicId,
        selectedServiceId: [],
        date: 'Chưa chọn ngày', // Giá trị mặc định
        time: 'Chưa chọn giờ', // Giá trị mặc định
      ),
      ConfirmBooking(
        onNavigateToScreen: navigateToScreen,
        customerId: customerId ?? 0,
        clinicId: widget.clinicId,
        selectedServiceIds: [],
        date: 'Chưa chọn ngày', // Giá trị mặc định
        time: 'Chưa chọn giờ', // Giá trị mặc định
        paymentId: 1,
      ),
      PaymentMethodBooking(),
    ];
  }

  void navigateToScreen(
    int index,
    String title, {
    int? clinicId,
    String? date,
    String? time,
    List<int>? serviceIds,
    int? customerId, // ✅ Thêm customerId
    int? paymentId, // ✅ Thêm paymentId
  }) {
    setState(() {
      _currentIndex = index;
      _showTitleScreen = title;
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = i <= index;
      }

      if (index == 1) {
        _screens[index] = ProfileBooking(
          onNavigateToScreen: navigateToScreen,
          clinicId: clinicId ?? widget.clinicId,
          selectedServiceId: serviceIds ?? [],
          date: date ?? 'Chưa chọn ngày',
          time: time ?? 'Chưa chọn giờ',
          paymentId: paymentId ?? 1, // ✅ Lưu paymentId khi chọn hồ sơ
        );
      }

      if (index == 2) {
        _screens[index] = ConfirmBooking(
          onNavigateToScreen: navigateToScreen,
          customerId: customerId ?? this.customerId ?? 0,
          clinicId: clinicId ?? widget.clinicId,
          selectedServiceIds: serviceIds ?? [],
          date: date ?? 'Chưa chọn ngày',
          time: time ?? 'Chưa chọn giờ',
          paymentId: paymentId ?? 1, // ✅ Đảm bảo truyền paymentId
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: _showTitleScreen,
      headerHeight: 0.2,
      selectedIcon: StepIndicator(
        currentIndex: _currentIndex,
        isSelected: _isSelected,
        onNavigateToScreen: navigateToScreen,
      ),
      body: Container(
        width: double.infinity,
        color: AppColors.neutralGrey,
        child: _screens[_currentIndex],
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int currentIndex;
  final List<bool> isSelected;
  final void Function(int, String) onNavigateToScreen;

  const StepIndicator({
    super.key,
    required this.currentIndex,
    required this.isSelected,
    required this.onNavigateToScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.accent,
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StepItem(
            onTap: () => onNavigateToScreen(0, 'Chọn thông tin khám'),
            border: isSelected[0]
                ? Border.all(color: AppColors.primary, width: 1)
                : null,
            background: isSelected[0] ? Colors.white : AppColors.accent,
            image: AppIcons.specialty,
            color: isSelected[0] ? AppColors.accent : AppColors.neutralGrey2,
          ),
          StepLine(),
          StepItem(
            onTap: currentIndex == 0
                ? null
                : () => onNavigateToScreen(1, 'Chọn hồ sơ'),
            border: isSelected[1]
                ? Border.all(color: AppColors.primary, width: 1)
                : null,
            background: isSelected[1] ? Colors.white : AppColors.accent,
            image: AppIcons.user1,
            color: isSelected[1] ? AppColors.accent : AppColors.neutralGrey2,
          ),
          StepLine(),
          StepItem(
            onTap: currentIndex <= 1
                ? null
                : () => onNavigateToScreen(2, 'Xác nhận thông tin'),
            border: isSelected[2]
                ? Border.all(color: AppColors.primary, width: 1)
                : null,
            background: isSelected[2] ? Colors.white : AppColors.accent,
            image: AppIcons.checkmark,
            color: isSelected[2] ? AppColors.accent : AppColors.neutralGrey2,
          ),
          StepLine(),
          StepItem(
            onTap: currentIndex <= 2
                ? null
                : () => onNavigateToScreen(3, 'Thông tin thanh toán'),
            border: isSelected[3]
                ? Border.all(color: AppColors.primary, width: 1)
                : null,
            background: isSelected[3] ? Colors.white : AppColors.accent,
            image: AppIcons.payment,
            color: isSelected[3] ? AppColors.accent : AppColors.neutralGrey2,
          ),
        ],
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final void Function()? onTap;
  final Border? border;
  final String image;
  final Color color;
  final Color background;

  const StepItem({
    super.key,
    required this.onTap,
    required this.border,
    required this.image,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: background,
          border: border,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.asset(
          image,
          width: 25,
          color: color,
        ),
      ),
    );
  }
}

class StepLine extends StatelessWidget {
  const StepLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }
}
