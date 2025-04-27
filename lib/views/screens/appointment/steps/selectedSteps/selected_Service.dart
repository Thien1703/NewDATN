import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/views/screens/cartService/serviceCart_screen.dart';
import 'package:health_care/views/widgets/widget_select_item.dart';
import 'package:health_care/models/service.dart';

class SelectedService extends StatefulWidget {
  const SelectedService({
    super.key,
    required this.specialtyId,
    required this.onServiceSelected,
  });

  final int specialtyId;
  final Function(List<int>) onServiceSelected;

  @override
  State<SelectedService> createState() => _SelectedServiceState();
}

class _SelectedServiceState extends State<SelectedService> {
  List<Service> selectedServices = [];
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
          color: selectedServices.isNotEmpty
              ? AppColors.deepBlue
              : const Color(0xFF484848),
          colorIcon: selectedServices.isNotEmpty
              ? AppColors.deepBlue
              : const Color(0xFF484848),
          onTap: () async {
            final List<Service>? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceCartScreen(
                  specialtyId: widget.specialtyId,
                  previouslySelected: selectedServices,
                ),
              ),
            );

            if (result != null) {
              setState(() {
                selectedServices = result;
              });

              widget.onServiceSelected(
                selectedServices.map((service) => service.id).toList(),
              );
            }
          },
        ),

        const SizedBox(height: 8),

        // 🔹 Hiển thị danh sách tên dịch vụ
        if (selectedServices.isNotEmpty)
          ...selectedServices.map((service) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '• ${service.name}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              )),
      ],
    );
  }
}
