import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/models/clinic.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/clinic_api.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/viewmodels/profile_viewmodel.dart';
import 'package:health_care/views/screens/appointment/steps/notiSucefully_screen.dart';
import 'package:health_care/views/widgets/appointment/widget_hospital_info_card.dart';
import 'package:health_care/views/widgets/appointment/widget_customPricePayment.dart';
import 'package:health_care/views/widgets/appointment/widget_customButton.dart';
import 'package:health_care/views/widgets/widgetCustomerProfile.dart';
import 'package:health_care/views/widgets/widget_lineBold.dart';
import 'package:health_care/views/widgets/widget_customerInfor_card.dart';
import 'package:health_care/models/appointment/appointment_Create.dart';
import 'package:health_care/viewmodels/api/appointment_api.dart';
import 'package:health_care/viewmodels/api/appointmentService_api.dart';
import 'package:intl/intl.dart';

class ConfirmBooking extends StatefulWidget {
  const ConfirmBooking({
    super.key,
    required this.onNavigateToScreen,
    required this.customerId,
    required this.customerProfileId,
    required this.clinicId,
    required this.selectedServiceIds,
    required this.date,
    required this.time,
  });

  final Function(int, String) onNavigateToScreen;
  final int customerId;
  final int customerProfileId;
  final int clinicId;
  final List<int> selectedServiceIds;
  final String date;
  final String time;

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  Map<String, dynamic>? selectedProfile;
  bool isLoading = false;
  Clinic? clinices;
  List<Service>? services;

  @override
  void initState() {
    super.initState();
    fetchClinics();
    fetchServices();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileViewModel().getProfileById(widget.customerId);
    if (mounted) {
      setState(() {
        selectedProfile = profile;
        isLoading = false;
      });
    }
  }

  void fetchServices() async {
    List<Service>? fetchedServices =
        await ServiceApi.getServiceByIds(widget.selectedServiceIds);

    if (fetchedServices != null && mounted) {
      setState(() {
        services = fetchedServices;
      });
    }
  }

  void fetchClinics() async {
    Clinic? data = await ClinicApi.getClinicById(widget.clinicId);
    if (data != null && mounted) {
      setState(() {
        clinices = data;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    // Gửi yêu cầu tạo lịch hẹn
    AppointmentCreate newBooking = AppointmentCreate(
      id: 0,
      clinicId: widget.clinicId,
      customerId: widget.customerId,
      date: widget.date,
      time: widget.time,
      customerProfileId:
          widget.customerProfileId == 0 || widget.customerProfileId == null
              ? null
              : widget.customerProfileId,
      status: "pending",
    );
    if (!mounted) return;
    int? appointmentId = await AppointmentApi.createAppointment(newBooking);

    if (appointmentId == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Đặt lịch thất bại, vui lòng thử lại!")),
      );
      return;
    }
    print("✅ Đã tạo lịch hẹn với ID: $appointmentId");

    // Gửi yêu cầu thêm dịch vụ vào lịch hẹn
    bool serviceAdded = await AppointmentserviceApi.addServicesToAppointment(
      appointmentId,
      widget.selectedServiceIds,
    );
    if (!mounted) return;
    setState(() => isLoading = false);

    if (serviceAdded) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotiSucefully(
              appointmentId: appointmentId,
            ),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("❌ Thêm dịch vụ thất bại, vui lòng thử lại!")),
      );
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing asynchronous operations if needed.
    super.dispose();
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(amount)}đ";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: services == null
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
                : ListView(
                    children: [
                      HospitalInfoWidget(
                        clinicId: widget.clinicId,
                      ),
                      const SectionTitle(title: 'Thông tin bệnh nhân'),
                      widget.customerProfileId == null
                          ? WidgetCustomerinforCard()
                          : WidgetCustomerProfile(
                              customerProfileId: widget.customerProfileId),
                      const SectionTitle(title: 'Thông tin dịch vụ'),
                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: services == null
                              ? Text('Chưa có dịch vụ')
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: services!.length,
                                  itemBuilder: (context, index) {
                                    final service = services![index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Dịch vụ: ${service.name}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.deepBlue,
                                                ),
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Giá: ${NumberFormat('#,###', 'vi_VN').format(service.price ?? 0)} VNĐ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    );
                                  },
                                ),
                        ),
                      ),
                      WidgetLineBold(),
                      const CancellationNotice(),
                    ],
                  ),
          ),
        ),
        BottomBar(
          onContinue: isLoading ? null : _bookAppointment,
          isLoading: isLoading,
          services: services, // Truyền danh sách dịch vụ xuống
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.neutralDarkGreen1,
        ),
      ),
    );
  }
}

class BookingInfoRow extends StatelessWidget {
  final String image;
  final String text;
  final bool isTextBlack;

  const BookingInfoRow({
    super.key,
    required this.image,
    required this.text,
    this.isTextBlack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 23,
            color: AppColors.accent,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: isTextBlack ? 17 : 16,
              fontWeight: isTextBlack ? FontWeight.w700 : FontWeight.w500,
              color: isTextBlack ? Colors.black : AppColors.neutralDarkGreen2,
            ),
          ),
        ],
      ),
    );
  }
}

class CancellationNotice extends StatelessWidget {
  const CancellationNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 238, 206, 203),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.priority_high_rounded,
              color: Color.fromARGB(255, 216, 93, 84)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Trong thời gian quy định, nếu quý khách hủy phiếu khám sẽ được hoàn lại tiền khám và các dịch vụ đặt thêm (không bao gồm phí tiện ích)',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 216, 93, 84),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final VoidCallback? onContinue;
  final bool isLoading;
  final List<Service>? services;

  const BottomBar({
    super.key,
    required this.onContinue,
    required this.isLoading,
    required this.services,
  });

  String _calculateTotalPrice() {
    if (services == null || services!.isEmpty) return '0 VNĐ';
    double total = services!.fold(0, (sum, item) => sum + (item.price ?? 0));
    return '${NumberFormat('#,###', 'vi_VN').format(total)} VNĐ';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: WidgetCustomPricePayment(
              priceDetails: [
                {'title': 'Tiền khám', 'price': '0 VNĐ'},
                {
                  'title': 'Tiền dịch vụ',
                  'price': _calculateTotalPrice(),
                },
                {
                  'title': 'Tạm tính',
                  'price': _calculateTotalPrice(),
                  'isBold': true,
                },
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: WidgetCustombutton(
              onTap: onContinue,
              text: isLoading ? 'Đang xử lý...' : 'Đặt lịch khám',
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}
