import 'package:flutter/material.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';

class Showcustomer extends StatefulWidget {
  const Showcustomer({super.key});
  @override
  State<Showcustomer> createState() => _Showcustomer();
}

class _Showcustomer extends State<Showcustomer> {
  Customer? customers;
  @override
  void initState() {
    super.initState();
    fetchSpecialties();
  }

  void fetchSpecialties() async {
    Customer? result = await CustomerApi.getCustomerProfile();
    setState(() {
      customers = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Thông tin bệnh nhân',
      body: customers == null
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
                          customers?.id.toString() ?? 'Chưa cập nhật'),
                      _buildLabelRow(
                          'Họ và tên', customers?.fullName ?? 'Chưa cập nhật'),
                      _buildLabelRow('Điện thoại',
                          customers?.phoneNumber ?? 'Chưa cập nhật'),
                      _buildLabelRow(
                          'Ngày sinh', customers?.birthDate ?? 'Chưa cập nhật'),
                      _buildLabelRow(
                          'Giới tính', customers?.gender ?? 'Chưa cập nhật'),
                      _buildLabelRow(
                          'Địa chỉ', customers?.address ?? 'Chưa cập nhật'),
                      _buildLabelRow(
                          'Email', customers?.email ?? 'Chưa cập nhật'),
                      _buildLabelRow('Mã căn cước công dân', 'Chưa cập nhật'),
                      _buildLabelRow('Mã bảo hiểm y tế', 'Chưa cập nhật'),
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
                        color: Colors.white,
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
