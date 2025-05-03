import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointmentOnline_Create.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
import 'package:health_care/views/screens/apoointment_online/payment_listener_screen.dart';
import 'package:intl/intl.dart';
import 'package:health_care/models/service.dart';

class ConfirmappointmentOnlineScreen extends StatefulWidget {
  const ConfirmappointmentOnlineScreen({
    super.key,
    required this.clinicId,
    required this.customerId,
    this.customeProfileId = 0,
    required this.date,
    required this.time,
    this.isOnline = 1,
    required this.employeeId,
    required this.serviceIds,
    required this.doctor,
    required this.specialtyName,
    required this.customer,
    required this.specialtyId,
  });
  final int clinicId;
  final int customerId;
  final int customeProfileId;
  final DateTime date;
  final String time;
  final int isOnline;
  final int employeeId;
  final List<int> serviceIds;
  final Doctor doctor;
  final String specialtyName;
  final Customer? customer;
  final int specialtyId;

  @override
  State<ConfirmappointmentOnlineScreen> createState() =>
      _ConfirmappointmentOnlineScreenState();
}

class _ConfirmappointmentOnlineScreenState
    extends State<ConfirmappointmentOnlineScreen> {
  bool isLoading = false;

  String _formatAppointmentDate(DateTime date) {
    final dayOfWeek = DateFormat('EEE', 'vi_VN').format(date); // T2, T3, CN
    final dateFormatted = DateFormat('dd/MM/yyyy').format(date); // 08/09/2000
    return '$dayOfWeek - $dateFormatted'; // T2 - 08/09/2000
  }

  String _formatBirthDate(DateTime? date) {
    if (date == null) {
      return "..."; // Trả về giá trị mặc định nếu date là null
    }
    return DateFormat('dd/MM/yyyy').format(date);
  }

  DateTime? _parseBirthDate(String? birthDateString) {
    if (birthDateString == null || birthDateString.isEmpty) {
      return null; // Nếu không có giá trị, trả về null
    }
    return DateTime.tryParse(
        birthDateString); // Chuyển đổi String sang DateTime
  }

  List<Service>? services;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  double totalPrice = 0;
  String formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '', // bỏ ký hiệu ₫ nếu bạn muốn tự thêm 'đ' sau
      decimalDigits: 0,
    );
    return formatCurrency.format(amount) + 'đ';
  }

  void fetchData() async {
    int serviceId = widget.serviceIds.isNotEmpty ? widget.serviceIds[0] : 0;
    print(serviceId);
    List<Service>? fetchedServices =
        await ServiceApi.getOnlineServeById(widget.specialtyId); // Sửa ở đây

    double total = 0;
    if (fetchedServices != null) {
      for (var service in fetchedServices) {
        total += service.price ?? 0; // nhớ kiểm tra null nếu price có thể null
      }
    }

    setState(() {
      services = fetchedServices;
      totalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? birthDateString = widget.customer?.birthDate;
    DateTime? birthDate = _parseBirthDate(birthDateString);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Xác nhận thông tin'),
        centerTitle: true,
        backgroundColor: AppColors.deepBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: AppColors.ghostWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[400]!,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 1),
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
                  child: Row(
                    children: [
                      _buildTItleRow('1', 'Chọn lịch khám', Colors.green, true),
                      _buildTItleRow('2', 'Xác nhận', AppColors.deepBlue, true),
                      _buildTItleRow(
                          '3', 'Nhận lịch hẹn', Color(0xFF656565), false),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleHeader(),
                        _buildTitle('THÔNG TIN ĐĂNG KÝ'),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 1,
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
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle, // 👈 hình tròn hoàn toàn
                                        border: Border.all(
                                          color: Colors.blue, // viền xanh
                                          width: 2, // độ dày viền
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              widget.doctor.avatar),
                                          fit: BoxFit.cover, // ảnh vừa khít
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Flexible(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.doctor.qualification,
                                            style: TextStyle(fontSize: 15)),
                                        Text(widget.doctor.fullName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17)),
                                        Text(
                                          'Chuyên khoa: ${widget.doctor.specialties.isNotEmpty ? widget.doctor.specialties.map((e) => e.name).join(', ') : "Chưa có chuyên khoa"}',
                                          style: const TextStyle(fontSize: 15),
                                          softWrap: true,
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey[300]),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    _buildColumn('Giờ khám', '${widget.time} '),
                                    SizedBox(width: 80),
                                    _buildColumn('Ngày khám',
                                        '${_formatAppointmentDate(widget.date)}')
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: _buildRowValue(
                                    'Chuyên khoa', widget.specialtyName),
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
                                      child: Column(
                                        children: [
                                          _buildRowValue(
                                              'Dịch vụ', service.name),
                                        ],
                                      ));
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
                                child: _buildColumn('Họ và tên',
                                    widget.customer?.fullName ?? '...'
                                    // widget.customerProfileId == 0
                                    //     ? customer?.fullName ?? '..'
                                    //     : customerProfile?.fullName ?? '..'
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    _buildColumn('Giới tính',
                                        widget.customer?.gender ?? "..."
                                        // widget.customerProfileId == 0
                                        //     ? customer?.gender ?? '...'
                                        //     : customerProfile?.gender ?? '..'
                                        ),
                                    SizedBox(width: 70),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: _buildColumn('Ngày sinh',
                                          _formatBirthDate(birthDate)
                                          // widget.customerProfileId == 0
                                          //     ? _formatDate(customer?.birthDate)
                                          //     : _formatDate(
                                          //         customerProfile?.birthDate
                                          //         ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: _buildColumn('Số điện thoại',
                                    widget.customer?.phoneNumber ?? "..."
                                    // widget.customerProfileId == 0
                                    //     ? customer?.phoneNumber ?? '...'
                                    //     : customerProfile?.phoneNumber ?? '..'
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: _buildColumn(
                                    'Địa chỉ', widget.customer?.address ?? "..."
                                    // widget.customerProfileId == 0
                                    //     ? customer?.address ?? '...'
                                    //     : customerProfile?.address ?? '..'
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, top: 10, right: 15),
                          child: _buildTitle('CHI TIẾT THANH TOÁN'),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ]),
                          child: Column(
                            children: [
                              _buildRowValue('Phí khám', '0đ'),
                              Divider(),
                              _buildRowValue('Phí tiện ích', 'Miễn phí'),
                              Divider(),
                              _buildRowValue('Tổng thanh toán',
                                  formatCurrency(totalPrice)),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                      ]),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[400]!,
              child: Container(
                margin: EdgeInsets.only(top: 1),
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            // disable nút khi đang loading
                            setState(() {
                              isLoading = true;
                            });

                            final appointment = AppointmentCreateOnline(
                              clinicId: widget.clinicId,
                              customerId: widget.customerId,
                              customerProfileId: widget.customeProfileId == 0
                                  ? null
                                  : widget.customeProfileId,
                              date:
                                  DateFormat('yyyy-MM-dd').format(widget.date),
                              time: widget.time,
                              isOnline: widget.isOnline,
                              employeeId: widget.employeeId,
                              serviceIds: widget.serviceIds,
                            );
                            print(widget.clinicId);
                            print(widget.customerId);
                            print(widget.customeProfileId);
                            print(widget.date);
                            print(widget.time);
                            print(widget.isOnline);
                            print(widget.employeeId);
                            print(widget.serviceIds);

                            final response =
                                await AppointmentApi.getBookingOnline(
                                    appointment);

                            if (response != null) {
                              if (response.statusCode == 200 ||
                                  response.statusCode == 0) {
                                final bookingInfo = response.data;
                                if (bookingInfo != null) {
                                  final token =
                                      await LocalStorageService.getToken() ??
                                          '';

                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: Text('Đặt lịch thành công!'),
                                  //     backgroundColor: Colors.green,
                                  //   ),
                                  // );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentListenerScreen(
                                        qrCode: bookingInfo.qrCode,
                                        checkoutUrl: bookingInfo.checkoutUrl,
                                        userId: widget.customerId,
                                        jwtToken: token,
                                      ),
                                    ),
                                  );
                                }
                              } else if (response.statusCode == 409 ||
                                  response.statusCode == 3005) {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: const BorderSide(
                                          color: Colors.grey, width: 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Center(
                                            child: Text(
                                              'Đặt lịch thất bại',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            'Bệnh nhân này đã đặt lịch trước đó, nếu bạn muốn đặt lịch khám mới, '
                                            'vui lòng hủy khám hiện tại và thử lại',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          const SizedBox(height: 15),
                                          Center(
                                            child: Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.deepBlue,
                                                  side: const BorderSide(
                                                      color: Colors.blue),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text(
                                                  'Đồng ý',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else if (response.statusCode == 500) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Lỗi hệ thống'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Không kết nối được tới máy chủ!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }

                            setState(() {
                              isLoading = false;
                            });
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Xác nhận đặt lịch",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 237, 172),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 4,
            color: Colors.red,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              'Hãy kiểm tra các thông tin trước khi xác nhận. Nếu bạn cần hộ trợ, vui lòng chat với CSKH hoặc liên hệ tổng đài',
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String value) {
    return Padding(
      padding: EdgeInsets.only(left: 30, bottom: 10, top: 5),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTItleRow(String value, String label, Color colors, bool icon) {
    return Row(
      children: [
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            color: colors, // màu nền hình tròn
            shape: BoxShape.circle, // tạo hình tròn
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: colors,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 5),
        icon == true
            ? Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: const Color(0xFF656565),
              )
            : SizedBox.shrink(),
        SizedBox(width: 10),
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
}
