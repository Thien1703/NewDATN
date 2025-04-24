import 'package:flutter/material.dart';
import 'package:health_care/models/appointment/appointment_Create.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/clinic_api.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/widgets/appointment/widget_customButton.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';

class ConfirmBooking extends StatefulWidget {
  const ConfirmBooking({
    super.key,
    required this.onNavigateToScreen,
    required this.customerId,
    required this.customerProfileId,
    required this.clinicId,
    required this.selectedServiceIds,
    required this.date,
    required this.time,
  });

  final Function(int, String) onNavigateToScreen;
  final int customerId;
  final int customerProfileId;
  final int clinicId;
  final List<int> selectedServiceIds;
  final String date;
  final String time;

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  Clinic? clinices;
  List<Service>? services;
  Customer? customer;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      List<Service>? fetchedServices =
          await ServiceApi.getServiceByIds(widget.selectedServiceIds);
      Clinic? data = await ClinicApi.getClinicById(widget.clinicId);
      Customer? dataCustomer = await CustomerApi.getCustomer(widget.customerId);

      if (fetchedServices != null && data != null && dataCustomer != null) {
        setState(() {
          services = fetchedServices;
          clinices = data;
          customer = dataCustomer;
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

    final appointmentCreate = AppointmentCreate(
      customerId: widget.customerId,
      customerProfileId:
          widget.customerProfileId == 0 ? null : widget.customerProfileId,
      clinicId: widget.clinicId,
      date: widget.date,
      time: widget.time,
      serviceIds: widget.selectedServiceIds,
    );

    final result = await AppointmentApi.getBooking(appointmentCreate);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đặt lịch thành công'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreens(),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                                  clinices?.image ?? '',
                                  width: 90,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    clinices?.name ?? '...',
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
                                _buildColumn('Ngày khám', 'T3 ${widget.date}'),
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
                                child: _buildRowValue('Dịch vụ', service.name),
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
                                'Họ và tên', customer?.fullName ?? '...'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              children: [
                                _buildColumn(
                                    'Giới tính', customer?.gender ?? '...'),
                                SizedBox(width: 70),
                                _buildColumn(
                                    'Ngày sinh', customer?.birthDate ?? '...'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              children: [
                                _buildColumn('Điện thoại liên hệ',
                                    customer?.phoneNumber ?? '...'),
                                SizedBox(width: 70),
                                _buildColumn('Mã căn cước công dân',
                                    customer?.birthDate ?? '...'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: _buildColumn(
                                'Địa chỉ', customer?.address ?? '...'),
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
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            BottomBar(onTap: _bookAppointment),
          ],
        ),
      ],
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
  final VoidCallback onTap;

  const BottomBar({super.key, required this.onTap});

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
        ),
      ),
    );
  }
}
