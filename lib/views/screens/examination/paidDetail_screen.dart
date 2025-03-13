// import 'package:flutter/material.dart';
// import 'package:health_care/common/app_colors.dart';
// import 'package:health_care/views/widgets/widget_header_body.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:health_care/models/clinic/examination.dart';
// import 'package:health_care/views/widgets/bottomSheet/select_day_widget.dart';

// class PaidDetailScreen extends StatefulWidget {
//   final Examination examination;
//   const PaidDetailScreen({super.key, required this.examination});
//   @override
//   State<PaidDetailScreen> createState() => _PaidDetailScreen();
// }

// class _PaidDetailScreen extends State<PaidDetailScreen> {
//   final String data = 'fsfsdf';
//   @override
//   Widget build(BuildContext context) {
//     return WidgetHeaderBody(
//         iconBack: true,
//         title: 'Thông tin phiếu khám',
//         body: Container(
//           color: AppColors.grey,
//           child: Card(
//             elevation: 5,
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//               side: BorderSide(color: Colors.white, width: 1),
//             ),
//             margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//             child: Column(
//               children: [
//                 SizedBox(height: 30),
//                 _customRowlabelandvalue(
//                     label: 'Mã dịch vụ:', value: widget.examination.maDatLich),
//                 _customRowlabelandvalue(
//                     label: 'Chuyên khoa:',
//                     value: widget.examination.chuyenKhoa),
//                 _customRowlabelandvalue(
//                     label: 'Dịch vụ:', value: widget.examination.service),
//                 _customRowlabelandvalue(
//                     label: 'Thời gian:', value: widget.examination.time),
//                 _customRowlabelandvalue(
//                     label: 'Địa điểm:', value: widget.examination.address),
//                 _customQrList(data),
//                 _customeButton(context),
//               ],
//             ),
//           ),
//         ));
//   }
// }

// Widget _customRowlabelandvalue({required String label, required String value}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 12),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//               color: AppColors.neutralDarkGreen2),
//           softWrap: true,
//         ),
//         SizedBox(width: 10),
//         Flexible(
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//             softWrap: true,
//           ),
//         )
//       ],
//     ),
//   );
// }

// Widget _customQrList(String data) {
//   return Padding(
//       padding: EdgeInsets.only(top: 20, bottom: 40),
//       child: Column(
//         children: [
//           QrImageView(
//             data: data,
//             version: QrVersions.auto,
//             size: 170,
//             gapless: false,
//             backgroundColor: Colors.white,
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Chụp màn hình để lưu giữ',
//             style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFFFEAD6D)),
//           ),
//         ],
//       ));
// }

// Widget _customeButton(BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       OutlinedButton(
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: AppColors.accent, width: 1),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//           ),
//           backgroundColor: AppColors.accent,
//           padding: EdgeInsets.symmetric(horizontal: 35),
//         ),
//         onPressed: () {
//           _showAlertDialog(context);
//         },
//         child: Text(
//           'Hủy lịch',
//           style: TextStyle(
//               fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
//         ),
//       ),
//       OutlinedButton(
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: AppColors.accent, width: 1),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//           ),
//           backgroundColor: AppColors.accent,
//           padding: EdgeInsets.symmetric(horizontal: 35),
//         ),
//         onPressed: () {
//           // SelectTimeWidget();
//           showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return Container(
//                   color: Colors.white,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: SizedBox(
//                       child: SelectDayWidget(),
//                     ),
//                   ),
//                 );
//               });
//         },
//         child: Text(
//           'Đổi lịch',
//           style: TextStyle(
//               fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
//         ),
//       ),
//     ],
//   );
// }

// void _showAlertDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(15))),
//         child: Container(
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//             width: double.infinity,
//             height: 160,
//             child: Column(
//               children: [
//                 Text('Xác nhận',
//                     style: TextStyle(
//                         fontSize: 19,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.neutralDarkGreen1)),
//                 Padding(
//                   padding: EdgeInsets.only(top: 10, bottom: 15),
//                   child: Text('Bạn có chắc muốn hủy lịch đặt này không',
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.neutralGrey3)),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 120,
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: AppColors.accent, width: 1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(8)),
//                           ),
//                           backgroundColor: Colors.white,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Hủy',
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.accent),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 120,
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: AppColors.accent, width: 1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(8)),
//                           ),
//                           backgroundColor: AppColors.accent,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Xác nhận',
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white),
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             )),
//       );
//     },
//   );
// }
