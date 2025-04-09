// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class OTPPopup extends StatefulWidget {
//   final String email;
//   const OTPPopup({super.key, required this.email});

//   @override
//   State<OTPPopup> createState() => _OTPPopupState();
// }

// class _OTPPopupState extends State<OTPPopup> {
//   final TextEditingController otpController =
//       TextEditingController(); // Bộ điều khiển cho mã OTP

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.black.withOpacity(0.5),
//       body: Center(
//         child: Container(
//           width: double.infinity,
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Tiêu đề
//               Text(
//                 'Xác thực OTP',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Mô tả
//               // Text(
//               //   'Vui lòng nhập mã OTP được gửi về email $email',
//               //   textAlign: TextAlign.center,
//               //   style: TextStyle(
//               //     fontSize: 14,
//               //     color: Colors.black.withOpacity(0.7),
//               //   ),
//               // ),
//               const SizedBox(height: 20),

//               // Input mã OTP
//               PinCodeTextField(
//                 controller: otpController,
//                 appContext: context,
//                 length: 6,
//                 animationType: AnimationType.none,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 pinTheme: PinTheme(
//                   shape: PinCodeFieldShape.underline,
//                   activeColor: Colors.green,
//                   selectedColor: Colors.grey,
//                   inactiveColor: Colors.grey,
//                   activeFillColor: Colors.transparent,
//                   inactiveFillColor: Colors.transparent,
//                 ),
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 10),

//               // // Đồng hồ đếm giờ (hiển thị cố định trong ví dụ)
//               // Text(
//               //   '01:13',
//               //   style: TextStyle(
//               //     fontSize: 14,
//               //     color: Colors.black.withOpacity(0.7),
//               //   ),
//               // ),
//               // const SizedBox(height: 10),

//               // Nút "Bỏ qua" và "Xác nhận"
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   // Nút Bỏ qua
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Quay lại màn hình trước đó
//                     },
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 30,
//                       ),
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text(
//                       'Hủy',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),

//                   // Nút Xác nhận
//                   TextButton(
//                     onPressed: () {},
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 30,
//                       ),
//                       backgroundColor: Colors.green,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text(
//                       'Xác nhận',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
