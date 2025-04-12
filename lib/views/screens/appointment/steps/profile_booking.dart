import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/profile_viewmodel.dart';
import 'package:health_care/views/screens/profile/add_profile.dart';
import 'package:health_care/views/screens/profile/widget_profile_card.dart';
import 'package:health_care/views/widgets/widget_customerInfor_card.dart';

class ProfileBooking extends StatefulWidget {
  final Function(
    int,
    String, {
    int? clinicId,
    List<int>? serviceIds,
    int? customerId,
    String? date, // ✅ Thêm ngày khám
    String? time, // ✅ Thêm giờ khám
  }) onNavigateToScreen;

  final int clinicId;
  final List<int> selectedServiceId;
  final String date; // Thêm ngày khám
  final String time; // Thêm giờ khám

  const ProfileBooking({
    super.key,
    required this.onNavigateToScreen,
    required this.clinicId,
    required this.selectedServiceId,
    required this.date,
    required this.time,
  });

  @override
  State<ProfileBooking> createState() => _ProfileBooking();
}

class _ProfileBooking extends State<ProfileBooking> {
  final GlobalKey<WidgetCustomerinforCardState> _profileCardKey = GlobalKey();
  late ProfileViewModel _profileViewModel;
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _profileViewModel = ProfileViewModel();
    _fetchAllProfiles();
  }

  Future<void> _fetchAllProfiles() async {
    final profiles = await _profileViewModel.getAllProfiles();
    if (mounted) {
      setState(() {
        _profiles = profiles ?? [];
        _isLoading = false;
      });
    }
  }

  /// Hàm cập nhật thông tin user
  // void _fetchUserProfile() {
  //   _profileCardKey.currentState?.fetchUserProfile();
  // }

  void _handleProfileTap(int customerId) {
    print("ID khách hàng: $customerId");
    print(
        "Dữ liệu nhận từ ExamInfoBooking: Clinic ID: ${widget.clinicId}, Dịch vụ: ${widget.selectedServiceId}");
    widget.onNavigateToScreen(
      2,
      'Xác nhận thông tin',
      customerId: customerId,
      clinicId: widget.clinicId,
      serviceIds: widget.selectedServiceId,
      date: widget.date,
      time: widget.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          // Text("Clinic ID: ${widget.clinicId}"),
          // Text("Danh sách dịch vụ đã chọn:${widget.selectedServiceId}"),
          // Text("Ngày khám: ${widget.date}"), // Hiển thị ngày khám
          // Text("Giờ khám: ${widget.time}"), // Hiển thị giờ khám
          // Text("Thanh toán: ${widget.paymentId}"),
          /// Tiêu đề và nút chỉnh sửa
          /// Tiêu đề và nút chỉnh sửa
          Padding(
            padding: const EdgeInsets.all(10), // Padding giống với Card
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Hồ sơ đặt khám",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      // MaterialPageRoute(
                      //   builder: (context) => EditProfileScreen(
                      //     onProfileUpdated:
                      //         _fetchUserProfile, // Gọi lại hàm này để cập nhật UI
                      //   ),
                      // ),
                      MaterialPageRoute(
                        builder: (context) => AddProfile(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text("Thêm"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent, // Màu nút
                    foregroundColor: Colors.white, // Màu chữ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          WidgetCustomerinforCard(
            key: _profileCardKey, // ✅ Thêm key để truy cập state
            onTap: _handleProfileTap,
          ),
          const SizedBox(height: 10),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Dùng khi bọc trong ListView lớn hơn
                  itemCount: _profiles.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final profile = _profiles[index];
                    return WidgetProfileCard(
                      profile: profile,
                      onTap: _handleProfileTap,
                    );
                  },
                ),
        ],
      ),
    );
  }
}
