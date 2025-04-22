import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:health_care/viewmodels/profile_viewmodel.dart';
import 'package:health_care/viewmodels/user_provider.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';
import 'package:health_care/views/widgets/widget_profile_card.dart';
import 'package:provider/provider.dart';

class PatientProfiles extends StatefulWidget {
  const PatientProfiles({super.key});

  @override
  State<PatientProfiles> createState() => _PatientProfilesState();
}

class _PatientProfilesState extends State<PatientProfiles> {
  final ProfileViewModel _profileViewModel = ProfileViewModel();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    final customerId =
        Provider.of<UserProvider>(context, listen: false).customerId;
    if (customerId == null) {
      print("❌ Không tìm thấy customerId trong Provider");
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

  void _handleProfileTap(int customerId, int? profileId) {
    // Tuỳ mục đích xử lý. Ví dụ: mở màn hình chỉnh sửa hoặc chỉ xem chi tiết
    print("📌 Tapped profileId: $profileId for customerId: $customerId");
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Hồ sơ đặt khám',
      body: Container(
        color: AppColors.neutralGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _profiles.isEmpty
                  ? const Center(child: Text("Bạn chưa có hồ sơ nào."))
                  : ListView.separated(
                      itemCount: _profiles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final profile = _profiles[index];
                        return WidgetProfileCard(
                          profile: profile,
                          onProfileUpdated:
                              _fetchProfiles, // Load lại khi cập nhật
                          onTap: (customerId, profileId) =>
                              _handleProfileTap(customerId, profileId),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
