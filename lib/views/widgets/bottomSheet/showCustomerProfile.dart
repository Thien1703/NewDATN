import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/customerProfile.dart';
import 'package:health_care/viewmodels/api/customerProfile_api.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
import 'package:intl/intl.dart';

class ShowcustomerProfile extends StatefulWidget {
  const ShowcustomerProfile({super.key, required this.customerProfileId});
  final int customerProfileId;
  @override
  State<ShowcustomerProfile> createState() => _ShowcustomerProfile();
}

class _ShowcustomerProfile extends State<ShowcustomerProfile> {
  CustomerProfile? customerProfiles;
  @override
  void initState() {
    super.initState();
    fetchCustomerProfile();
  }

  void fetchCustomerProfile() async {
    CustomerProfile? result =
        await CustomerprofileApi.getCustomerProfile(widget.customerProfileId);
    setState(() {
      customerProfiles = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Thông tin bệnh nhân',
      body: customerProfiles == null
          ? CircularProgressIndicator()
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 1,
                          spreadRadius: 1,
                        )
                      ]),
                  child: Column(
                    children: [
                      _buildLabelRow('Mã bệnh nhân',
                          customerProfiles?.id.toString() ?? 'Chưa cập nhật'),
                      _buildLabelRow('Họ và tên',
                          customerProfiles?.fullName ?? 'Chưa cập nhật'),
                      _buildLabelRow('Điện thoại',
                          customerProfiles?.phoneNumber ?? 'Chưa cập nhật'),
                      _buildLabelRow(
                        'Ngày sinh',
                        customerProfiles?.birthDate != null &&
                                customerProfiles!.birthDate.isNotEmpty &&
                                customerProfiles!.birthDate.toLowerCase() !=
                                    'null'
                            ? DateFormat('dd/MM/yyyy').format(DateTime.tryParse(
                                    customerProfiles!.birthDate) ??
                                DateTime(1900))
                            : 'Chưa cập nhật',
                      ),
                      _buildLabelRow('Giới tính',
                          customerProfiles?.gender ?? 'Chưa cập nhật'),
                      _buildLabelRow('Địa chỉ',
                          customerProfiles?.address ?? 'Chưa cập nhật'),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.deepBlue,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 1,
                            spreadRadius: 1,
                          )
                        ]),
                    child: Text(
                      'Đóng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.neutralLightGreen2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLabelRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(255, 99, 99, 99),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: value == 'Chưa cập nhật' ? 15 : 17,
              fontWeight:
                  value == 'Chưa cập nhật' ? FontWeight.w400 : FontWeight.w600,
              color: value == 'Chưa cập nhật'
                  ? const Color.fromARGB(255, 163, 163, 163)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
