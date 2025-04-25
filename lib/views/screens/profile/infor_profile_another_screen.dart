import 'package:flutter/material.dart';
import 'package:health_care/viewmodels/profile_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:health_care/views/widgets/widget_header_body.dart';

class InforProfileAnotherScreen extends StatefulWidget {
  final int profileId;
  const InforProfileAnotherScreen({super.key, required this.profileId});

  @override
  State<InforProfileAnotherScreen> createState() =>
      _InforProfileAnotherScreenState();
}

class _InforProfileAnotherScreenState extends State<InforProfileAnotherScreen> {
  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    final result = await profileVM.getProfileById(widget.profileId);
    if (mounted) {
      setState(() {
        profile = result;
        isLoading = false;
      });
    }
  }

  String formatBirthDate(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return 'Chưa có ngày sinh';
    try {
      DateTime date = DateTime.parse(birthDate);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (_) {
      return 'Sai định dạng';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetHeaderBody(
      iconBack: true,
      title: 'Chi tiết thông tin',
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
              ? const Center(child: Text("Không tìm thấy hồ sơ"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow(
                          'Họ và tên', profile!['fullName'] ?? 'Chưa cập nhật'),
                      _buildRow('Số điện thoại',
                          profile!['phoneNumber'] ?? 'Chưa cập nhật'),
                      _buildRow(
                          'Ngày sinh', formatBirthDate(profile!['birthDate'])),
                      _buildRow(
                          'Giới tính', profile!['gender'] ?? 'Chưa cập nhật'),
                      _buildRow(
                          'Địa chỉ', profile!['address'] ?? 'Chưa cập nhật'),
                    ],
                  ),
                ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 4,
              child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
              flex: 6,
              child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
