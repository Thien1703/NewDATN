import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/viewmodels/api/clinic_api.dart';
import 'package:health_care/views/screens/chat/chat_screen.dart';
import 'package:marquee/marquee.dart';

class ClinicDetailScreen extends StatefulWidget {
  const ClinicDetailScreen({super.key, required this.clinicId});
  final int clinicId;

  @override
  State<ClinicDetailScreen> createState() => _ClinicDetailScreenState();
}

class _ClinicDetailScreenState extends State<ClinicDetailScreen> {
  Clinic? clinices;
  @override
  void initState() {
    super.initState();
    fetchClinics();
  }

  void fetchClinics() async {
    Clinic? data = await ClinicApi.getClinicById(widget.clinicId);
    if (data != null) {
      setState(() {
        clinices = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: clinices == null
          ? Container(
              width: double.infinity,
              height: 700,
              alignment: Alignment.center,
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.deepBlue,
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: SizedBox(
                      height: 20, // Đảm bảo không bị cắt chữ
                      child: Marquee(
                        text: clinices?.name ?? 'Không xác định',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        scrollAxis: Axis.horizontal,
                        blankSpace: 50.0,
                        velocity: 30.0,
                        pauseAfterRound: Duration(seconds: 1),
                        startPadding: 10.0,
                        accelerationDuration: Duration(seconds: 1),
                        decelerationDuration: Duration(seconds: 1),
                      ),
                    ),
                    background: Image.network(
                      clinices?.image ?? 'Không xác định',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 30,
                              color: AppColors.deepBlue,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                clinices?.address ?? 'Không xác định',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Đặt khám theo chuyên khoa',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  clinicId: clinices!.id,
                                  clinicName: clinices!.name,
                                ),
                              )),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 7),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'Nhắn với phòng khám',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        _buildLabel('Giới thiệu'),
                        _buildIndocue(),
                        _buildLabel('Chuyên khoa'),
                        Text(
                            'Bệnh viện Nhân Dân Gia Định hiên đang triển khai da dạng các chuyên khoa nhằm đáp ứng nhu cầu khám bệnh ngày một tăng cao của người dân, bao gồm:'),
                        Text('Thông tin các Chuyên Khoa'),
                        _buildLabel('Một số bác sĩ tiêu biểu tại phòng khám'),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 5),
      child: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildIndocue() {
    return Text(
        'Chuỗi Phòng khám Đa khoa FPT là hệ thống cơ sở y tế đạt tiêu chuẩn cao, trực thuộc Sở Y tế TP.HCM. Với đội ngũ y bác sĩ giàu kinh nghiệm và trang thiết bị hiện đại, chúng tôi cung cấp dịch vụ khám chữa bệnh chất lượng, đáp ứng nhu cầu chăm sóc sức khỏe trên khắp các địa điểm trong hệ thống. Cam kết mang đến trải nghiệm y tế an toàn, chuyên nghiệp và tận tâm cho mọi khách hàng');
  }
}