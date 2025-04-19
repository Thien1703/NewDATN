import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/profile_viewmodel.dart';
import 'package:health_care/viewmodels/user_provider.dart';
import 'package:health_care/views/screens/profile/add_profile.dart';
import 'package:health_care/views/widgets/widget_profile_card.dart';
import 'package:health_care/views/widgets/widget_customerInfor_card.dart';
import 'package:provider/provider.dart';

class ProfileBooking extends StatefulWidget {
  final Function(
    int,
    String, {
    int? clinicId,
    List<int>? serviceIds,
    int? customerId,
    int? customerProfileId,
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
    _fetchAllProfileByCustomerId();
  }

  Future<void> _fetchAllProfileByCustomerId() async {
    final customerId =
        Provider.of<UserProvider>(context, listen: false).customerId;
    if (customerId == null) {
      print("Không tìm thấy customerId trong Provider");
      return;
    }
    final profiles =
        await _profileViewModel.getProfilesByCustomerId(customerId);
    if (mounted) {
      setState(() {
        _profiles = profiles ?? [];
        _isLoading = false;
      });
    }
  }

  /// Hàm cập nhật thông tin user
  void _fetchUserProfile() {
    _profileCardKey.currentState?.fetchUserProfile();
  }

  void _handleProfileTap(int customerId, int? customerProfileId) {
    print('customerId: $customerId');
    print('customerProfileId: $customerProfileId');

    final customerIdFromProvider =
        Provider.of<UserProvider>(context, listen: false).customerId;
    if (customerIdFromProvider == null) {
      print("Không tìm thấy customerId trong Provider");
      return;
    }

    widget.onNavigateToScreen(
      2,
      'Xác nhận thông tin',
      customerId: customerId,
      customerProfileId: customerProfileId,
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
          Padding(
            padding: const EdgeInsets.all(5), // Padding giống với Card
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
                      MaterialPageRoute(
                        builder: (context) => AddProfile(
                          onProfileAdded:
                              _fetchAllProfileByCustomerId, // Gọi lại để load danh sách mới
                        ),
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
            onTap: (customerId) {
              _handleProfileTap(customerId, null);
            },
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
                      onProfileUpdated: _fetchAllProfileByCustomerId,
                      onTap: (customerId, customerProfileId) {
                        _handleProfileTap(customerId, customerProfileId);
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}
