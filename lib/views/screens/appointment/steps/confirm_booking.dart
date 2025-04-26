import 'package:flutter/material.dart';
import 'package:health_care/models/appointment/appointment_Create.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/models/customerProfile.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/customerProfile_api.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/widgets/appointment/widget_customButton.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:intl/intl.dart';

class ConfirmBooking extends StatefulWidget {
  const ConfirmBooking({
    super.key,
    required this.onNavigateToScreen,
    required this.customerId,
    required this.customerProfileId,
    required this.selectedServiceIds,
    required this.date,
    required this.time,
    required this.clinic,
  });

  final Function(int, String) onNavigateToScreen;
  final int customerId;
  final int customerProfileId;
  final List<int> selectedServiceIds;
  final String date;
  final String time;
  final Clinic clinic;

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  List<Service>? services;
  Customer? customer;
  CustomerProfile? customerProfile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      List<Service>? fetchedServices =
          await ServiceApi.getServiceByIds(widget.selectedServiceIds);
      Customer? dataCustomer = await CustomerApi.getCustomer(widget.customerId);
      CustomerProfile? dataCusProfile =
          await CustomerprofileApi.getCustomerProfile(widget.customerProfileId);

      if (fetchedServices != null && dataCustomer != null) {
        setState(() {
          services = fetchedServices;
          customer = dataCustomer;
          customerProfile = dataCusProfile;
        });
      } else {
        print('Error: Data is null');
      }
    } catch (e) {
      print("API error: $e");
    }
  }

  void _bookAppointment() async {
    if (services == null || services!.isEmpty) {
      print('Chưa có dịch vụ');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final appointmentCreate = AppointmentCreate(
      customerId: widget.customerId,
      customerProfileId:
          widget.customerProfileId == 0 ? null : widget.customerProfileId,
      clinicId: widget.clinic.id,
      date: widget.date,
      time: widget.time,
      serviceIds: widget.selectedServiceIds,
    );
    print(widget.customerProfileId);
    print(widget.customerId);

    final result = await AppointmentApi.getBooking(appointmentCreate);

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đặt lịch thành công'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreens()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đặt lịch thất bại. Vui lòng thử lại.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '...';

    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow(),
                      Padding(
                        padding: EdgeInsets.only(left: 30, bottom: 10, top: 5),
                        child: Text(
                          'THÔNG TIN ĐĂNG KÝ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300]!,
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: Row(
                                children: [
                                  Image.network(
                                    widget.clinic.image,
                                    width: 90,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      widget.clinic.name,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey[300]),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  _buildColumn(
                                      'Giờ khám', '${widget.time} - 07:30'),
                                  SizedBox(width: 80),
                                  _buildColumn(
                                      'Ngày khám', 'T3 ${widget.date}'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: _buildRowValue('Chuyên khoa',
                                  services?.first.specialty.name ?? '...'),
                            ),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: services?.length ?? 0,
                              itemBuilder: (context, index) {
                                final service = services![index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 3),
                                  child:
                                      _buildRowValue('Dịch vụ', service.name),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Row(
                                children: [
                                  Text('Thông tin bệnh nhân'),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Divider(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: _buildColumn(
                                  'Họ và tên',
                                  widget.customerProfileId == 0
                                      ? customer?.fullName ?? '..'
                                      : customerProfile?.fullName ?? '..'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  _buildColumn(
                                      'Giới tính',
                                      widget.customerProfileId == 0
                                          ? customer?.gender ?? '...'
                                          : customerProfile?.gender ?? '..'),
                                  SizedBox(width: 70),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: _buildColumn(
                                      'Ngày sinh',
                                      widget.customerProfileId == 0
                                          ? _formatDate(customer?.birthDate)
                                          : _formatDate(
                                              customerProfile?.birthDate),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: _buildColumn(
                                  'Số điện thoại',
                                  widget.customerProfileId == 0
                                      ? customer?.phoneNumber ?? '...'
                                      : customerProfile?.phoneNumber ?? '..'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: _buildColumn(
                                  'Địa chỉ',
                                  widget.customerProfileId == 0
                                      ? customer?.address ?? '...'
                                      : customerProfile?.address ?? '..'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 30, bottom: 15, top: 10, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'CHI TIẾT THANH TOÁN',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text('Giải thích'),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.help_outline,
                                  size: 18,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300]!,
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]),
                        child: Column(
                          children: [
                            _buildRowValue('Phí khám', '0đ'),
                            Divider(),
                            _buildRowValue('Phí tiện ích', 'Miễn phí'),
                            Divider(),
                            _buildRowValue('Tổng thanh toán', '0đ'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, bottom: 10, top: 10),
                        child: Text(
                          'Hỗ trợ đặt khám',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.chat),
                          Text('Quy trình hủy lịch/ hoàn tiền'),
                          Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.security_rounded),
                          Text(
                            'fsfsfsdf',
                            // 'Bằng việc đăng ký / thanh toán bạn đã đọc và đồng ý với các điều khoản và điều kiện sử dụng của chúng tôi.',
                            softWrap: true,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              BottomBar(
                onTap: isLoading ? null : _bookAppointment,
                isLoading: isLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRowValue(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 237, 172),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Container(height: 70, width: 5, color: Colors.red),
          SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: Text(
                'Hãy kiểm tra các thông tin trước khi xác nhận. Nếu bạn cần hỗ trợ, vui lòng chat với CSKH hoặc liên hệ tổng đài',
                softWrap: true,
                style: TextStyle(fontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const BottomBar({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: WidgetCustombutton(
          onTap: onTap,
          text: 'Đặt lịch khám',
          isLoading: isLoading, // ✅ Truyền vào đây
        ),
      ),
    );
  }
}
