// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:health_care/common/app_icons.dart';
// import 'package:health_care/models/service.dart';
// import 'package:health_care/viewmodels/api/service_api.dart';
// import 'package:health_care/views/screens/examination/ratingStar/comment_screen.dart';

// class StarScreen extends StatefulWidget {
//   const StarScreen({
//     super.key,
//     required this.customerId,
//     required this.serviceId,
//   });

//   final int customerId;
//   final int serviceId;

//   @override
//   State<StarScreen> createState() => _StarScreen();
// }

// class _StarScreen extends State<StarScreen> {
//   Service? service; // Sử dụng biến Service thay vì List<Service>
//   double _rating = 0;
//   bool _isLoading = true; // Để theo dõi trạng thái loading

//   @override
//   void initState() {
//     super.initState();
//     fetchServiceDetails(); // Gọi API khi màn hình được tải
//   }

//   // Hàm lấy thông tin dịch vụ
//   void fetchServiceDetails() async {
//     Service? fetchedService = await ServiceApi.getServiceById(widget.serviceId);
//     if (mounted) {
//       setState(() {
//         service = fetchedService; // Lưu dịch vụ đã lấy được
//         _isLoading = false; // Dừng loading khi lấy xong dữ liệu
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: InkWell(
//         onTap: () => Navigator.pop(context),
//         child: Image.asset(
//           AppIcons.cancel,
//         ),
//       )),
//       body: _isLoading
//           ? Center(
//               child:
//                   CircularProgressIndicator()) // Hiển thị loading khi đang lấy dữ liệu
//           : service != null
//               ? Container(
//                   margin: EdgeInsets.symmetric(horizontal: 30),
//                   child: Column(
//                     children: [
//                       SizedBox(height: 100),
//                       // Text(widget.serviceId.toString()),
//                       // Hiển thị tên dịch vụ
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(
//                             15), // Tùy chỉnh bán kính bo tròn
//                         child: Image.network(
//                           service!.image,
//                           width: 150,
//                           height: 130,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         "Cảm nhận của bạn về dịch vụ: ${service!.name} thế nào?",
//                         style: TextStyle(
//                           fontSize: 22,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 5),

//                       Text(
//                         'Hãy đánh giá và nhận xét để giúp người dùng khác có thêm thông tin khi lựa chọn',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 13,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       RatingBar.builder(
//                         initialRating: 0,
//                         minRating: 1,
//                         direction: Axis.horizontal,
//                         allowHalfRating: false,
//                         itemCount: 5,
//                         itemPadding:
//                             const EdgeInsets.symmetric(horizontal: 4.0),
//                         itemBuilder: (context, _) => const Icon(
//                           Icons.star,
//                           color: Colors.amber,
//                         ),
//                         onRatingUpdate: (rating) {
//                           int intRating = rating.toInt();
//                           setState(() {
//                             _rating = rating;
//                           });
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CommentScreen(
//                                 customerId: widget.customerId,
//                                 serviceId: widget.serviceId,
//                                 stars: intRating,
//                               ),
//                             ),
//                           );
//                           print('Người dùng đánh giá: $rating sao');
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 )
//               : Center(
//                   child: Text("Không có dịch vụ nào.")), // Nếu không có dịch vụ
//     );
//   }
// }
