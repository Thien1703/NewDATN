import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/common/app_icons.dart';
import 'package:health_care/models/clinic.dart';

class ClinicDetailScreen extends StatelessWidget {
  const ClinicDetailScreen({super.key, required this.clinic});
  final Clinic clinic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLocationRow(),
                      _buildSectionTitle('Dịch vụ', top: 20, bottom: 10),
                      _buildBookingOption('Đặt khám tại bệnh viện', () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => AppointmentScreen()));
                      }),
                      _buildSectionTitle('Giới thiệu', top: 10, bottom: 5),
                      _buildDescription(),
                      _buildSectionTitle('Chuyên khoa', top: 30, bottom: 5),
                      _buildSpecialties(),
                      _buildSectionTitle(
                          'Một số bác sĩ tiêu biểu tại bệnh viện',
                          top: 30,
                          bottom: 5),
                      _buildText(
                          'Bệnh viện Nhân Dân Gia Định hiên sở hữu đội ngũ các y bác sĩ là những chuyên gia đầu ngành, có trình độ chuyên môn cao bao gồm Giáo sư, Tiến sĩ,... Một trong số đó có thể kể đến như:'),
                      _buildDoctors(),
                      _buildSectionTitle('Cơ sở vật chất tại bệnh viện',
                          top: 30, bottom: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.accent,
      expandedHeight: 210,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(clinic.image, fit: BoxFit.cover),
        centerTitle: true,
        titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        title: Text(
          clinic.name,
          style: TextStyle(
              color: AppColors.primary,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Image.asset(AppIcons.locationGreen),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            clinic.address,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.neutralDarkGreen2),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title,
      {required double top, required double bottom}) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accent),
      ),
    );
  }

  Widget _buildDescription() {
    return _buildText(clinic.description);
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.neutralGrey3),
    );
  }

  Widget _buildSpecialties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(
            '${clinic.name} hiện đang triển khai đa dạng các chuyên khoa nhằm đáp ứng nhu cầu khám bệnh ngày một tăng cao của người dân, bao gồm:'),
        Padding(
          padding: EdgeInsets.only(top: 15, bottom: 5),
          child: Text(
            'Thông tin Các khoa tại bệnh viện',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // children: List.generate(clinic.specialties.length, (index) {
            //   return Row(
            //     children: [
            //       Text(
            //         '${index + 1}. ',
            //         style: TextStyle(
            //             fontSize: 14,
            //             color: AppColors.neutralGrey3,
            //             fontWeight: FontWeight.bold),
            //       ),
            //       Expanded(child: _buildText(clinic.specialties[index])),
            //     ],
            //   );
            // }),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctors() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: clinic.notableDoctors.map((doctor) {
        //   return Row(
        //     children: [
        //       Icon(Icons.circle, size: 8, color: AppColors.neutralGrey3),
        //       SizedBox(width: 8),
        //       _buildText(doctor),
        //     ],
        //   );
        // }).toList(),
      ),
    );
  }

  Widget _buildBookingOption(String titleBooking, ontap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.neutralGrey3, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleBooking),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: InkWell(
                onTap: ontap,
                child: Row(
                  children: [
                    Text('Đặt lịch',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    SizedBox(width: 5),
                    Image.asset(AppIcons.rightArrow),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
