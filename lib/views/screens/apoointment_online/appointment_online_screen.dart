import 'dart:math';
import 'package:flutter/material.dart';
import 'package:health_care/models/customer.dart';
import 'package:health_care/models/employee.dart';
import 'package:health_care/models/specialty.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/viewmodels/api/customer_api.dart';
import 'package:health_care/views/screens/apoointment_online/appointment_online_api.dart';
import 'package:health_care/views/screens/apoointment_online/confirmAppointment_online_screen.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/selectedOnline/seleCustomerOnline.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/selectedOnline/seleServiceOnline.dart';
import 'package:health_care/views/screens/apoointment_online/doctor_online/selectedOnline/seleSpecialtyOnline.dart';
import 'package:health_care/views/screens/apoointment_online/payment_listener_screen.dart';
import 'package:health_care/views/widgets/widgetSelectedTimeOnline.dart';
import 'package:intl/intl.dart';

import 'package:health_care/common/app_colors.dart';

class AppointmentOnlineScreen extends StatefulWidget {
  final Doctor doctor;

  const AppointmentOnlineScreen({super.key, required this.doctor});

  @override
  State<AppointmentOnlineScreen> createState() =>
      _AppointmentOnlineScreenState();
}

class _AppointmentOnlineScreenState extends State<AppointmentOnlineScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Customer? customer;
  Specialty? _selectedSpecialty;
  String? _selectedSpecialtyId;
  String? _selectedServiceName;
  int? _selectedServiceId;
  String? selectedTimes;

  String generateRoomCode() {
    final random = Random();
    return random.nextInt(10000).toString().padLeft(4, '0');
  }

  Future<void> bookAppointment() async {
    if (selectedDate == null || selectedTime == null) return;

    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final timeStr =
        '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00';

    final customerId = await LocalStorageService.getUserId();
    final token = await LocalStorageService.getToken();

    if (customerId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("❌ Không tìm thấy thông tin người dùng."),
      ));
      return;
    }

    final result = await AppointmentOnlineApi.createOnlineAppointment(
      employeeId: widget.doctor.id,
      customerId: customerId,
      date: dateStr,
      time: timeStr,
    );

    if (result != null) {
      // ✅ Điều hướng sang màn hình hiển thị QR và theo dõi thanh toán
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentListenerScreen(
            qrCode: result['qrCode'],
            checkoutUrl: result['checkoutUrl'],
            userId: customerId,
            jwtToken: token,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("❌ Đặt lịch thất bại. Vui lòng thử lại."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Đặt lịch khám'),
        centerTitle: true, // Căn giữa title
        backgroundColor: AppColors.deepBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: AppColors.ghostWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTItleRow(
                        '1', 'Chọn lịch khám', AppColors.deepBlue, true),
                    _buildTItleRow('2', 'Xác nhận', Colors.grey, true),
                    _buildTItleRow('3', 'Nhận lịch hẹn', Colors.grey, false),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300]!,
                              blurRadius: 1,
                              spreadRadius: 1,
                            )
                          ]),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.deepBlue, width: 1),
                              shape: BoxShape.circle, // ✅ bo tròn viền
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(widget.doctor.avatar),
                              onBackgroundImageError: (_, __) {},
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            // Thêm cái này để Column có thể co giãn và không bị tràn
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bác sĩ',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  widget.doctor.fullName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                Text(
                                  'Chuyên khoa: ${widget.doctor.specialties.isNotEmpty ? widget.doctor.specialties.map((e) => e.name).join(', ') : "Chưa có chuyên khoa"}',
                                  style: TextStyle(fontSize: 15),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildTitle('Đặt lịch khám này cho: '),
                    Selecustomeronline(
                      onCustomerSelected: (value) {
                        setState(() {
                          customer = value;
                        });
                      },
                    ),
                    Text(
                        'customerId:${customer?.id.toString() ?? 'không lấy được'}'),
                    const SizedBox(height: 15),
                    _buildTitle('Chọn chuyên khoa'),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: InkWell(
                        onTap: () async {
                          final selected =
                              await showModalBottomSheet<Specialty>(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) => Selespecialtyonline(
                              specialties: widget.doctor.specialties,
                            ),
                          );

                          if (selected != null) {
                            setState(() {
                              _selectedSpecialty = selected;
                              _selectedSpecialtyId =
                                  selected.id.toString(); // Lưu id chuyên khoa
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ]),
                          child: Text(
                            _selectedSpecialty?.name ?? 'Chọn chuyên khoa',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _selectedSpecialtyId != null
                          ? 'SpecialtyId: $_selectedSpecialtyId'
                          : 'SpecialtyId: Chưa chọn',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    _buildTitle('Chọn dịch vụ'),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: InkWell(
                        onTap: () async {
                          final result =
                              await showModalBottomSheet<Map<String, dynamic>>(
                            context: context,
                            builder: (context) => Seleserviceonline(
                              serviceId: _selectedSpecialtyId.toString(),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _selectedServiceName = result['name'];
                              _selectedServiceId = result['id'];
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ]),
                          child: Text(
                            _selectedServiceName ?? 'Chọn dịch vụ',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Text(_selectedServiceId != null
                        ? 'ID dịch vụ: $_selectedServiceId'
                        : 'ID địch vụ: Chưa có'),
                    _buildTitle('Chọn ngày khám'),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : "Chọn ngày khám"),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    _buildTitle('Chọn giờ khám'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle('Chọn giờ khám'),
                        Widgetselectedtimeonline(
                          onTimeSelected: (time) {
                            setState(() {
                              selectedTimes = time;
                            });
                            print('Giờ đã chọn từ con: $time');
                          },
                        ),
                        if (selectedTimes != null)
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('Giờ đã chọn: $selectedTimes'),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ConfirmappointmentOnlineScreen(
                            clinicId: widget.doctor.clinic.id,
                            customerId: customer!.id,
                            date: selectedDate!,
                            employeeId: widget.doctor.id,
                            time: selectedTimes.toString(),
                            serviceIds: [_selectedServiceId ?? 0],
                          );
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                              position: offsetAnimation, child: child);
                        },
                      ),
                    );
                  },
                  child: const Text(
                    "Tiếp tục",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String value) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 10),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: AppColors.deepBlue,
            size: 20,
          ),
          SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
          )
        ],
      ),
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
            style: TextStyle(fontSize: 14),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTItleRow(String value, String label, Color colors, bool icon) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: colors, // màu nền hình tròn
            shape: BoxShape.circle, // tạo hình tròn
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
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
                color: const Color.fromARGB(255, 136, 136, 136),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:health_care/models/employee.dart';
// import 'package:health_care/services/local_storage_service.dart';
// import 'package:health_care/views/screens/apoointment_online/appointment_online_api.dart';
// import 'package:health_care/views/screens/apoointment_online/doctor_online/doctor_model.dart';
// import 'package:health_care/views/screens/apoointment_online/payment_listener_screen.dart';
// import 'package:intl/intl.dart';

// import 'package:health_care/common/app_colors.dart';

// class AppointmentOnlineScreen extends StatefulWidget {
//   final Employee doctor;

//   const AppointmentOnlineScreen({super.key, required this.doctor});

//   @override
//   State<AppointmentOnlineScreen> createState() =>
//       _AppointmentOnlineScreenState();
// }

// class _AppointmentOnlineScreenState extends State<AppointmentOnlineScreen> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   String generateRoomCode() {
//     final random = Random();
//     return random.nextInt(10000).toString().padLeft(4, '0');
//   }

//   Future<void> bookAppointment() async {
//     if (selectedDate == null || selectedTime == null) return;

//     final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate!);
//     final timeStr =
//         '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00';

//     final customerId = await LocalStorageService.getUserId();
//     final token = await LocalStorageService.getToken();

//     if (customerId == null || token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("❌ Không tìm thấy thông tin người dùng."),
//       ));
//       return;
//     }

//     final result = await AppointmentOnlineApi.createOnlineAppointment(
//       employeeId: widget.doctor.id,
//       customerId: customerId,
//       date: dateStr,
//       time: timeStr,
//     );

//     if (result != null) {
//       // ✅ Điều hướng sang màn hình hiển thị QR và theo dõi thanh toán
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => PaymentListenerScreen(
//             qrCode: result['qrCode'],
//             checkoutUrl: result['checkoutUrl'],
//             userId: customerId,
//             jwtToken: token,
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("❌ Đặt lịch thất bại. Vui lòng thử lại."),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//         title: Text('Chọn thông tin khám'),
//         centerTitle: true, // Căn giữa title
//         backgroundColor: AppColors.deepBlue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 45,
//               backgroundImage: NetworkImage(widget.doctor.avatar),
//               onBackgroundImageError: (_, __) {},
//             ),
//             const SizedBox(height: 12),
//             Text(
//               widget.doctor.clinic.name,
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//             Text(
//               widget.doctor.specialty.isNotEmpty
//                   ? widget.doctor.specialty.map((e) => e.name).join(', ')
//                   : "Chưa có chuyên khoa",
//             ),
//             Text('Dịch vụ'),
//             const SizedBox(height: 24),

//             /// Chọn ngày
//             ListTile(
//               leading: const Icon(Icons.calendar_today),
//               title: Text(selectedDate != null
//                   ? DateFormat('dd/MM/yyyy').format(selectedDate!)
//                   : "Chọn ngày khám"),
//               onTap: () async {
//                 final picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now().add(const Duration(days: 1)),
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime.now().add(const Duration(days: 30)),
//                 );
//                 if (picked != null) {
//                   setState(() {
//                     selectedDate = picked;
//                   });
//                 }
//               },
//             ),

//             /// Chọn giờ
//             ListTile(
//               leading: const Icon(Icons.access_time),
//               title: Text(selectedTime != null
//                   ? selectedTime!.format(context)
//                   : "Chọn giờ khám"),
//               onTap: () async {
//                 final picked = await showTimePicker(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 );
//                 if (picked != null) {
//                   setState(() {
//                     selectedTime = picked;
//                   });
//                 }
//               },
//             ),

//             const Spacer(),

//             /// Nút xác nhận
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: (selectedDate != null && selectedTime != null)
//                     ? bookAppointment
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.deepBlue,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 child: const Text(
//                   "Xác nhận đặt lịch",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
