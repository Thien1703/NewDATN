import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/models/clinic/clinic.dart';

class ClinicDetailScreen extends StatelessWidget {
const ClinicDetailScreen({super.key});
// final Clinic clinic;
@override
Widget build(BuildContext context) {
return Scaffold(
body: ListView(
children: [
Stack(
children: [
Image.asset(
'assets/images/img_hospital.png',
width: double.infinity,
height: 250,
fit: BoxFit.cover,
),
Positioned(
top: 40,
left: 10,
child: IconButton(
icon: Icon(
Icons.arrow_back,
color: Colors.white,
),
onPressed: () {
Navigator.pop(context);
},
)),
Positioned(
top: 204,
left: 0,
right: 0,
child: Container(
padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
decoration: BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(14)),
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [
Color(0xFFD9D9D9).withOpacity(0.7),
Color(0xFF585858)
],
)),
child: Text(
"Bệnh viện Nhân Dân Gia Định",
style: TextStyle(
color: AppColors.neutralWhite,
fontSize: 18,
fontWeight: FontWeight.w700,
),
),
))
],
),
Expanded(
child: Padding(
padding: EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(children: [
Image.asset(AppIcons.locationGreen),
SizedBox(width: 10),
Expanded(
child: Text(
'Địa chỉ Số 1 Nơ Trang Long, Phương 7, Quận Bình Thạnh, Tp.HCM',
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w500,
color: AppColors.neutralDarkGreen2)))
]),
Padding(
padding: EdgeInsets.only(top: 20, bottom: 10),
child: Text('Dịch vụ',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: AppColors.accent))),
customBookingExaming(
titleBooking: 'Đặt khám theo chuyên khoa'),
SizedBox(height: 10),
customBookingExaming(
titleBooking: 'Đặt khám theo chuyên gia'),
Padding(
padding: EdgeInsets.only(top: 10, bottom: 5),
child: Text('Giới thiệu',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: AppColors.accent))),
Text(
'Bệnh viện Nhân dân Gia Định là một trong những Bệnh viện Đa khoa loại I trực thuộc Sở Y tế TP.HCM. Với đội ngũ Y, Bác sĩ chuyên môn cao, dày dạn kinh nghiệm, Bệnh viện có đủ các chuyên khoa lớn, nhiều phân khoa sâu, trang bị đầy đủ trang thiết bị y tế nhằm nâng cao chất lượng chẩn đoán, điều trị và chăm sóc bệnh nhân, đáp ứng nhu cầu khám chữa bệnh ngày càng cao của nhân dân',
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w500,
color: AppColors.neutralGrey3,
)),
Padding(
padding: EdgeInsets.only(top: 30, bottom: 5),
child: Text('Chuyên khoa',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: AppColors.accent))),
Text(
'Bệnh viện Nhân Dân Gia Định hiên đang triển khai da dạng các chuyên khoa nhằm đáp ứng nhu cầu khám bệnh ngày một tăng cao của người dân, bao gồm:',
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w500,
color: AppColors.neutralGrey3,
),
),
Text('Thông tin Các khoa Lâm Sàng'),
Text('1. Nội Tổng Quát'),
Text('2. Đông Y'),
Text('3. Da Liễu'),
Text('4. Hô Hấp'),
Text('5. Cơ Xương Khớp'),
Text('6. Nội Tiết'),
Text('7. Nội Thần Kinh'),
Text('8. Ngoại Thần Kinh'),
Text('9. Lão Khoa'),
Text('Một số bác sĩ tiêu biểu tại bệnh viện'),
Text(
'Bệnh viện Nhân Dân Gia Định hiên sở hữu đội ngũ các y bác sĩ là những chuyên gia đầu ngành, có trình độ chuyên môn cao bao gồm Giáo sư, Tiến sĩ, Thạc sĩ,... Một trong số đó có thể kể đến như:'),
Text(
'TS.BS Nguyễn Hoàng Hải: Giám đốc bệnh viện Nhân dân Gia Định;'),
Text(
'TS.BS Võ Hồng Minh Công: Phó Giám đốc Bệnh viện Nhân dân Gia Định;'),
Text(
'Bác sĩ Chuyên khoa II Lê Nguyễn Thụy Khương: Trưởng khoa Nội Tiết Thận Bệnh viện Nhân dân Gia Định;'),
Text(
'Phó Giáo sư Tiến sĩ Bác sĩ Nguyễn Thy Khuê: Phó Chủ tịch thường trực Hội Nội tiết TP.HCM;'),
Text('Cơ sở vật chất tại bệnh viện'),
Text(
'Hiện nay, bệnh viện cung cấp quy mô lớn với 1.500 giường bệnh. Hàng ngày, bệnh viện tiếp đón khoảng 1.500 bệnh nhân nội trú, hơn 4.000 lượt bệnh nhân đến khám bệnh và hơn 300 lượt bệnh nhân cấp cứu. Bên cạnh viếc khám chữa bệnh cho người dân sống tại khu vực nội thành, bệnh vienj còn thực hiện khám chữa và điều trị cho các tỉnh thành lân cận như Biên Hòa, Đồng Nai, Vũng Tàu,...'),
SizedBox(height: 50),
],
),
),
),
],
),
);
}
}

Widget customBookingExaming({required String titleBooking}) {
return Container(
padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
decoration: BoxDecoration(
border: Border.all(color: AppColors.neutralGrey3, width: 1),
borderRadius: BorderRadius.all(Radius.circular(16))),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(titleBooking),
Container(
padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
decoration: BoxDecoration(
color: AppColors.accent,
borderRadius: BorderRadius.all(Radius.circular(16))),
child: Row(
children: [
Text(
'Đăt lịch',
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w500,
color: Colors.white),
),
Image.asset(AppIcons.rightArrow),
],
),
)
],
),
);
}
