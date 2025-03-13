// import 'package:flutter/material.dart';
// import 'package:health_care/common/app_colors.dart';
// import 'package:health_care/views/widgets/widget_header_body.dart';
// class ThamkhamScreen extends StatefulWidget {
//   const ThamkhamScreen({super.key});

//   @override
//   State<ThamkhamScreen> createState() => _ThamkhamScreen();
// }

// class _ThamkhamScreen extends State<ThamkhamScreen> {
//   final List<String> _statuses = [
//     'Đã thanh toán',
//     'Chưa thanh toán',
//     'Đã khám',
//     'Đã hủy'
//   ];
//   String _selectedStatus = 'Đã thanh toán';
//   @override
//   Widget build(BuildContext context) {
//     return WidgetHeaderBody(
//       iconBack: true,
//       title: 'Thông tin phiếu khám',
//       body: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 15),
//             color: Colors.white,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: _statuses
//                     .map((status) => _customTitleThamKham(
//                           title: status,
//                           isSelected: _selectedStatus == status,
//                           onTap: () {
//                             setState(() {
//                               _selectedStatus = status;
//                             });
//                           },
//                         ))
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Widget _customTitleThamKham({
//   required String title,
//   required VoidCallback onTap,
//   required bool isSelected,
// }) {
//   return InkWell(
//     onTap: onTap,
//     child: Container(
//       margin: EdgeInsets.only(left: 15, right: 5),
//       padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(50),
//         color: isSelected ? AppColors.accent : AppColors.grey5,
//       ),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w500,
//           color: isSelected ? Colors.white : AppColors.neutralGrey3,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     ),
//   );
// }
