import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/config/app_config.dart';
import 'package:health_care/models/customerProfile.dart';
import 'package:health_care/viewmodels/api/customerProfile_api.dart';
import 'package:health_care/views/screens/profile/editProfile_screen.dart';
import 'package:intl/intl.dart';

class WidgetCustomerProfile extends StatefulWidget {
  const WidgetCustomerProfile({super.key, required this.customerProfileId});
  final int customerProfileId;

  @override
  WidgetCustomerProfileState createState() => WidgetCustomerProfileState();
}

class WidgetCustomerProfileState extends State<WidgetCustomerProfile> {
  CustomerProfile? customerProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    CustomerProfile? result =
        await CustomerprofileApi.getCustomerProfile(widget.customerProfileId);
    setState(() {
      customerProfile = result;
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
                      label: customerProfile?.fullName ?? 'Chưa có'),
                  _customRow(
                      icon: Icons.phone,
                      label: customerProfile?.phoneNumber ?? 'Chưa có'),
                  _customRow(
                      icon: Icons.date_range,
                      label: _formatDate(customerProfile?.birthDate)),
                  _customRow(
                      icon: Icons.location_on,
                      label: customerProfile?.address ?? 'Chưa có'),
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
