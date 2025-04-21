import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/appointment/appointment_service.dart';
import 'package:health_care/models/customerProfile.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/views/screens/clinic/clinic_screen.dart';
import 'package:health_care/views/screens/home/home_screens.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';
import 'package:health_care/views/widgets/bottomSheet/showCustomer.dart';
import 'package:health_care/views/widgets/bottomSheet/showCustomerProfile.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaidDetailScreen extends StatefulWidget {
  final int appointmentId;
  final String status;

  const PaidDetailScreen(
      {super.key, required this.appointmentId, required this.status});

  @override
  State<PaidDetailScreen> createState() => _PaidDetailScreenState();
}

class _PaidDetailScreenState extends State<PaidDetailScreen> {
  List<AppointmentService>? appointmentServices;
  @override
  void initState() {
    super.initState();
    fetchAppointmentServices();
  }

  void fetchAppointmentServices() async {
    appointmentServices =
        await AppointmentserviceApi.getByAppointment(widget.appointmentId);
    setState(() {});
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(amount)}VNĐ";
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetHeaderBody(
        iconBack: true,
        title: "Thông tin phiếu khám",
        body: appointmentServices == null
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: const Color(0xFFECECEC),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              _buildClinicInfo(),
                              _sectionTitle('Thông tin bệnh nhân'),
                              _buildPatientInfo(),
                              // _sectionTitle('Thông tin dịch vụ'),
                              // _buildSelectedServices(),
                              _sectionTitle('Thông tin đăng ký khám'),
                              _buildInfoClinic(),
                              Column(
                                children: appointmentServices!.map((item) {
                                  return _buildContainer(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        _buildInfoRow(
                                          "Dịch vụ",
                                          item.service?.name ??
                                              "Không có dịch vụ",
                                          Colors.black,
                                        ),
                                        _buildInfoRow(
                                            'Chuyên khoa',
                                            item.service?.specialty.name ??
                                                'Không có dịch vụ',
                                            Colors.black),
                                        _buildInfoRow(
                                          "Giá",
                                          formatCurrency(
                                              item.service?.price.toInt() ?? 0),
                                          Colors.green,
                                        ),
                                        _buildInfoRow(
                                          "Bác sĩ",
                                          item.employee?.fullName ??
                                              "Đang cập nhật",
                                          Colors.black,
                                        ),
                                        // appointmentServices!
                                        //             .first.appointment.status ==
                                        //         'COMPLETED'
                                        //     ? OutlinedButton(
                                        //         onPressed: () {
                                        //           Navigator.push(
                                        //               context,
                                        //               MaterialPageRoute(
                                        //                 builder: (context) =>
                                        //                     StarScreen(
                                        //                   customerId:
                                        //                       appointmentServices!
                                        //                               .first
                                        //                               .appointment
                                        //                               .customer
                                        //                               ?.id ??
                                        //                           0,
                                        //                   serviceId: item
                                        //                           .service
                                        //                           ?.id ??
                                        //                       0,
                                        //                 ),
                                        //               ));
                                        //         },
                                        //         child: Text('Đánh giá'),
                                        //       )
                                        //     : Container(),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    appointmentServices!.first.appointment.status ==
                                'CANCELLED' ||
                            appointmentServices!.first.appointment.status ==
                                'ARRIVED' ||
                            appointmentServices!.first.appointment.status ==
                                'COMPLETED'
                        ? _buildSelectedSelected()
                        : _buildSelectedCancel()
                  ],
                ),
              ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildClinicInfo() {
    final appointment = appointmentServices!.first.appointment;

    return _buildContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            appointment.clinic.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Mã phiếu khám',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                  Text(appointment.id.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                ],
              ),
              QrImageView(data: appointment.id.toString(), size: 120),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusBadge(
              getStatusText(widget.status), getStatusColor(widget.status)),
          appointment.status == 'CANCELLED'
              ? Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Đã hủy. Lịch khám đã được hủy bởi bạn. Để được hộ trợ vui lòng liên hệ ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : SizedBox.shrink(),
          const WidgetLineBold(),
          _buildInfoRow(
              'Mã phiếu khám', appointment.id.toString(), Colors.black),
          _buildInfoRow(
              'Ngày khám', formatDate(appointment.date), Colors.black),
          _buildInfoRow('Giờ khám dự kiến', appointment.time.substring(0, 5),
              Colors.green),
        ],
      ),
    );
  }

// Hàm chuyển đổi trạng thái
  String getStatusText(String status) {
    const statusMap = {
      'PENDING': 'Đã đặt lịch',
      'CONFIRM': 'Đã xác nhận',
      'ARRIVED': 'Đã tới khám',
      'COMPLETED': 'Đã khám',
      'CANCELLED': 'Đã hủy'
    };
    return statusMap[status] ?? status;
  }

// Hàm lấy màu theo trạng thái
  Color getStatusColor(String status) {
    const statusColors = {
      'PENDING': Colors.blueAccent,
      'CONFIRM': Colors.orangeAccent,
      'ARRIVED': Colors.teal,
      'COMPLETED': Colors.green,
      'CANCELLED': Colors.redAccent
    };
    return statusColors[status] ?? Colors.black;
  }

  Widget _buildPatientInfo() {
    final customer = appointmentServices!.first.appointment.customer;
    final customerProfile =
        appointmentServices!.first.appointment.customerProfile;

    // Kiểm tra nếu customerProfile là null, hiển thị thông tin của customer
    return _buildContainer(
      Column(
        children: [
          // Hiển thị thông tin của customer nếu customerProfile là null
          if (customerProfile == null) ...[
            _buildInfoRow(
                'Mã bệnh nhân', customer.id.toString(), AppColors.deepBlue),
            _buildInfoRow('Họ và tên', customer.fullName, Colors.black),
            _buildInfoRow('Số điện thoại', customer.phoneNumber, Colors.black),
            const WidgetLineBold(),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Showcustomer(),
                );
              },
              child: const Text('Chi tiết',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepBlue)),
            ),
          ]
          // Nếu customerProfile không phải null, hiển thị thông tin của customerProfile
          else ...[
            _buildInfoRow('Mã bệnh nhân', customerProfile.id.toString(),
                AppColors.deepBlue),
            _buildInfoRow('Họ và tên', customerProfile.fullName, Colors.black),
            _buildInfoRow(
                'Số điện thoại', customerProfile.phoneNumber, Colors.black),
            const WidgetLineBold(),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ShowcustomerProfile(
                      customerProfileId: customerProfile.id),
                );
              },
              child: const Text('Chi tiết',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepBlue)),
            ),
          ],
        ],
      ),
    );
  }

  // Widget _buildSelectedServices() {
  //   return _buildContainer(
  //     Column(
  //       children: appointmentServices!.map((item) {
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             _buildInfoRow(
  //               "Dịch vụ",
  //               item.service?.name ?? "Không có dịch vụ",
  //               Colors.black,
  //             ),
  //             _buildInfoRow(
  //               "Giá",
  //               formatCurrency(item.service?.price?.toInt() ?? 0),
  //               Colors.green,
  //             ),
  //             _buildInfoRow(
  //               "Bác sĩ",
  //               item.employee?.fullName ?? "Đang cập nhật",
  //               Colors.black,
  //             ),
  //           ],
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _buildContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoClinic() {
    return _buildContainer(Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                appointmentServices!.first.appointment.clinic.name,
                softWrap: true,
              ),
            ),
            Image.network(
              appointmentServices!.first.appointment.clinic.image,
              width: 70,
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.location_on_sharp,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                appointmentServices!.first.appointment.clinic.address,
                softWrap: true,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ],
    ));
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          SizedBox(
            width: 30,
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: color),
              softWrap: true,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedSelected() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClinicScreen(
                iconBack: true,
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: AppColors.deepBlue,
              border: Border.all(color: AppColors.deepBlue, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Đạt lịch khám khác',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCancel() {
    String? tempSelectedValue;
    bool isLoading = false;
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setStateModal) {
                return HeaderBottomSheet(
                  title: 'Lý Do Hủy',
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<String>(
                        value: 'Tôi bận, không thể đến khám',
                        groupValue: tempSelectedValue,
                        title: const Text(
                          'Tôi bận, không thể đến khám',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setStateModal(() {
                            tempSelectedValue = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        value: 'Tôi muốn đổi lịch khám',
                        groupValue: tempSelectedValue,
                        title: const Text(
                          'Tôi muốn đổi lịch khám',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setStateModal(() {
                            tempSelectedValue = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        value: 'Tôi không còn triệu chứng',
                        groupValue: tempSelectedValue,
                        title: const Text(
                          'Tôi không còn triệu chứng',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setStateModal(() {
                            tempSelectedValue = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        value: 'Tôi đặt nhầm lịch',
                        groupValue: tempSelectedValue,
                        title: const Text(
                          'Tôi đặt nhầm lịch',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setStateModal(() {
                            tempSelectedValue = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        value: 'Tôi không có nhu cầu đặt nữa',
                        groupValue: tempSelectedValue,
                        title: const Text(
                          'Tôi không có nhu cầu đặt nữa',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setStateModal(() {
                            tempSelectedValue = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        value: 'Tôi không tìm thấy lý do hủy phù hợp',
                        groupValue: tempSelectedValue,
                        title: const Text(
                          'Tôi không tìm thấy lý do hủy phù hợp',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setStateModal(() {
                            tempSelectedValue = value!;
                          });
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: (tempSelectedValue == null || isLoading)
                              ? null
                              : () async {
                                  setStateModal(() {
                                    isLoading = true;
                                  });
                                  bool? success =
                                      await AppointmentApi.updateAppointment(
                                    appointmentServices!.first.appointment.id,
                                    tempSelectedValue!,
                                  );

                                  setStateModal(() {
                                    isLoading = false;
                                  });
                                  if (mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreens(),
                                      ),
                                    );
                                  }
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: Text(success == true
                                  //         ? 'Hủy lịch thành công'
                                  //         : 'Hủy lịch thất bại. Vui lòng thử lại'),
                                  //     backgroundColor: success == true
                                  //         ? Colors.grey
                                  //         : Colors.red,
                                  //   ),
                                  // );
                                },
                          style: OutlinedButton.styleFrom(
                              foregroundColor: tempSelectedValue == null
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: tempSelectedValue == null
                                  ? Colors.grey
                                  : AppColors.deepBlue),
                          child: isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text('Xác nhận'),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Hủy lịch',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          CircleAvatar(
              radius: 8,
              backgroundColor: color,
              child: const Icon(Icons.check, size: 10, color: Colors.white)),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildAlertDialog({
    required String label,
    VoidCallback? onTap,
    Color? colorBackground,
    Color? colorText,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
            minWidth: 100, maxWidth: 200), // Đảm bảo kích thước phù hợp
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: colorBackground,
          border: Border.all(color: colorBackground ?? Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: colorText, fontSize: 16), // Font to hơn chút cho dễ đọc
        ),
      ),
    );
  }
}
