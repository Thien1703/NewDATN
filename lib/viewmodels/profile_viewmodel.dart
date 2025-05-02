import 'package:flutter/material.dart';
import 'package:health_care/config/profile_config.dart';
import 'package:health_care/viewmodels/toast_helper.dart';

class ProfileViewModel with ChangeNotifier {
  /// Tạo hồ sơ mới
  Future<void> createProfile(
    BuildContext context, {
    required int customerId,
    required String fullName,
    required String phoneNumber,
    required String birthDate,
    required String gender,
    required String address,
    // String? avatar,
  }) async {
    String? errorMessage = await ProfileConfig.createProfile(
      customerId: customerId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      birthDate: birthDate,
      gender: gender,
      address: address,
      // avatar: avatar,
    );

    if (!context.mounted) return;

    if (errorMessage == null) {
      showToastSuccess("Tạo hồ sơ thành công!");
      Navigator.pop(context);
    } else {
      showToastError(errorMessage);
    }
  }

  /// Cập nhật hồ sơ
  Future<void> updateProfileById(
    BuildContext context, {
    required int id,
    required int customerId,
    required String fullName,
    required String phoneNumber,
    required String birthDate,
    required String gender,
    required String address,
    // String? avatar,
  }) async {
    String? errorMessage = await ProfileConfig.updateProfileById(
      id: id,
      customerId: customerId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      birthDate: birthDate,
      gender: gender,
      address: address,
      // avatar: avatar,
    );

    if (!context.mounted) return;

    if (errorMessage == null) {
      showToastSuccess("Cập nhật hồ sơ thành công!");
      Navigator.pop(context);
    } else {
      showToastError(errorMessage);
    }
  }

  /// Lấy thông tin hồ sơ theo ID
  Future<Map<String, dynamic>?> getProfileById(int id) async {
    return await ProfileConfig.getProfileById(id);
  }

  /// Lấy danh sách hồ sơ theo customerId
  Future<List<Map<String, dynamic>>?> getProfilesByCustomerId(
      int customerId) async {
    return await ProfileConfig.getProfilesByCustomerId(customerId);
  }

  /// Xóa hồ sơ theo ID
  Future<void> deleteProfileById(BuildContext context, int id) async {
    String? errorMessage = await ProfileConfig.deleteProfileById(id);

    if (!context.mounted) return;

    if (errorMessage == null) {
      showToastSuccess("Xóa hồ sơ thành công!");
      // Gọi notifyListeners() nếu bạn có ListView hoặc UI cần cập nhật lại
      notifyListeners();
    } else {
      showToastError(errorMessage);
    }
  }
}
