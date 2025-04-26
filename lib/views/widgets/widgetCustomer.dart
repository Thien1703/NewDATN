import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:intl/intl.dart';

class WidgetCustomer extends StatefulWidget {
  const WidgetCustomer({super.key, required this.customerId});
  final int customerId;
  @override
  WidgetCustomerProfileState createState() => WidgetCustomerProfileState();
}

class WidgetCustomerProfileState extends State<WidgetCustomer> {
  Customer? customer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    Customer? result = await CustomerApi.getCustomer(widget.customerId);
    if (!mounted) return;
    setState(() {
      customer = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Card(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _customRow(
                      icon: Icons.person,
                      label: customer?.fullName ?? 'Chưa có'),
                  _customRow(
                      icon: Icons.phone,
                      label: customer?.phoneNumber ?? 'Chưa có'),
                  _customRow(
                      icon: Icons.date_range,
                      label: _formatDate(customer?.birthDate)),
                  _customRow(
                      icon: Icons.location_on,
                      label: customer?.address ?? 'Chưa có'),
                ],
              ),
            ),
          );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'Chưa có';
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return rawDate;
    }
  }
}

Widget _customRow({
  required IconData icon,
  required String label,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(
          icon,
          size: 25,
          color: AppColors.deepBlue,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.deepBlue),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    ),
  );
}
