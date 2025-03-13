// import 'package:flutter/material.dart';
// import 'package:health_care/common/app_colors.dart';
// import 'dart:math' as math;

// class WidgetInfoPatient extends StatefulWidget {
//   const WidgetInfoPatient({
//     super.key,
//     required this.image,
//     required this.text,
//   });

//   final String image;
//   final String text;

//   @override
//   State<WidgetInfoPatient> createState() => _WidgetInfoPatientState();
// }

// class _WidgetInfoPatientState extends State<WidgetInfoPatient> {
//   bool isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           isExpanded = !isExpanded;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         width: double.infinity,
//         height: isExpanded ? 150 : 50,
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.only(top: 5),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(
//             color: const Color.fromARGB(255, 161, 161, 161),
//             width: 1,
//           ),
//           borderRadius: const BorderRadius.all(
//             Radius.circular(15),
//           ),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Transform(
//                       transform: Matrix4.rotationY(math.pi),
//                       alignment: Alignment.center,
//                       child: Image.asset(
//                         widget.image,
//                         width: 20,
//                         color: AppColors.accent,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       widget.text,
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.neutralGrey3,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Icon(isExpanded
//                     ? Icons.keyboard_arrow_up
//                     : Icons.keyboard_arrow_down),
//               ],
//             ),
//             if (isExpanded)
//               Expanded(
//                   child: Column(
//                 children: [
//                   _customeRow(image: Icons.phone, value: '0979591276'),
//                   _customeRow(image: Icons.cake, value: '07/10/2004'),
//                   _customeRow(
//                       image: Icons.location_on, value: 'Thành phố Hồ Chí Minh'),
//                 ],
//               )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget _customeRow({required IconData image, required String value}) {
//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: 5),
//     child: Row(
//       children: [
//         Icon(
//           image,
//           weight: 20,
//           color: AppColors.accent,
//         ),
//         const SizedBox(width: 10),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.w500,
//             color: AppColors.neutralGrey3,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// import 'package:flutter/material.dart';
// import 'package:health_care/common/app_colors.dart';
// import 'dart:math' as math;

// import 'package:health_care/viewmodels/api_service.dart';

// class WidgetInfoPatient extends StatefulWidget {
//   const WidgetInfoPatient({
//     super.key,
//     required this.image,
//     required this.text,
//   });

//   final String image;
//   final String text;

//   @override
//   State<WidgetInfoPatient> createState() => _WidgetInfoPatientState();
// }

// class _WidgetInfoPatientState extends State<WidgetInfoPatient> {
//   bool isExpanded = false;
//   Map<String, dynamic>? userInfo;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserProfile();
//   }

//   Future<void> _fetchUserProfile() async {
//     final data = await ApiService.getUserProfile();
//     if (mounted) {
//       setState(() {
//         userInfo = data;
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           isExpanded = !isExpanded;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         width: double.infinity,
//         height: isExpanded ? 150 : 50,
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.only(top: 5),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(
//             color: const Color.fromARGB(255, 161, 161, 161),
//             width: 1,
//           ),
//           borderRadius: const BorderRadius.all(Radius.circular(15)),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Transform(
//                       transform: Matrix4.rotationY(math.pi),
//                       alignment: Alignment.center,
//                       child: Image.asset(
//                         widget.image,
//                         width: 20,
//                         color: AppColors.accent,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       widget.text,
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.neutralGrey3,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Icon(isExpanded
//                     ? Icons.keyboard_arrow_up
//                     : Icons.keyboard_arrow_down),
//               ],
//             ),
//             if (isExpanded)
//               isLoading
//                   ? const Center(child: CircularProgressIndicator()) // Hiển thị vòng tròn tải dữ liệu
//                   : userInfo == null
//                       ? const Center(child: Text("Không có dữ liệu"))
//                       : Expanded(
//                           child: Column(
//                             children: [
//                               _customeRow(
//                                   image: Icons.person,
//                                   value: userInfo!['fullName'] ?? 'Chưa có tên'),
//                               _customeRow(
//                                   image: Icons.phone,
//                                   value: userInfo!['phoneNumber'] ?? 'Chưa có SĐT'),
//                               _customeRow(
//                                   image: Icons.cake,
//                                   value: userInfo!['birthDate'] ?? 'Chưa có ngày sinh'),
//                               _customeRow(
//                                   image: Icons.location_on,
//                                   value: userInfo!['address'] ?? 'Chưa có địa chỉ'),
//                             ],
//                           ),
//                         ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget _customeRow({required IconData image, required String value}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 5),
//     child: Row(
//       children: [
//         Icon(
//           image,
//           size: 20,
//           color: AppColors.accent,
//         ),
//         const SizedBox(width: 10),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.w500,
//             color: AppColors.neutralGrey3,
//           ),
//         ),
//       ],
//     ),
//   );
// }
