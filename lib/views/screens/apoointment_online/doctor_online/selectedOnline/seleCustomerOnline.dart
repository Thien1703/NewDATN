import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/views/widgets/bottomSheet/showCustomer.dart';
import 'package:intl/intl.dart';

class Selecustomeronline extends StatefulWidget {
  final Function(Customer) onCustomerSelected;

  const Selecustomeronline({super.key, required this.onCustomerSelected});

  @override
  State<Selecustomeronline> createState() => _Selecustomeronline();
}

class _Selecustomeronline extends State<Selecustomeronline> {
  Customer? customer;
  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  void fetchAllData() async {
    Customer? dataCustomer = await CustomerApi.getCustomerProfile();
    if (mounted && dataCustomer != null) {
      setState(() {
        customer = dataCustomer;
      });
      widget.onCustomerSelected(dataCustomer); // 👈 Gọi callback
    }
  }

  // Hàm để định dạng ngày tháng
  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy')
          .format(parsedDate); // Định dạng theo dạng ngày/tháng/năm
    } catch (e) {
      return date; // Trả về nguyên bản nếu không thể định dạng
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 25, right: 12, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 215, 227, 241),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500]!,
                  blurRadius: 1,
                  spreadRadius: 1,
                )
              ]),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 1,
                        spreadRadius: 1,
                      )
                    ]),
                child: Column(
                  children: [
                    _buildRow('Họ và tên', customer?.fullName ?? '...'),
                    _buildRow('Giới tính', customer?.gender ?? '...'),
                    _buildRow(
                        'Ngày sinh', formatDate(customer?.birthDate ?? '...')),
                    _buildRow('Điện thoại', customer?.phoneNumber ?? '...'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Showcustomer(),
                        );
                      },
                      child: Text(
                        'Xem chi tiết',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.all(5),
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Text(
                    //     'Sửa hồ sơ',
                    //     style: TextStyle(
                    //         fontSize: 14,
                    //         color: AppColors.deepBlue,
                    //         fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'Chọn hoặc tạo hồ sơ khác',
            //   style: TextStyle(
            //       color: AppColors.deepBlue,
            //       fontSize: 15.5,
            //       fontWeight: FontWeight.w500),
            // ),
            // Icon(
            //   Icons.arrow_forward,
            //   size: 17,
            //   color: AppColors.deepBlue,
            // )
          ],
        ),
      ],
    );
  }

  Widget _buildRow(String value, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 15),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
