import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_care/viewmodels/toast_helper.dart';
import 'package:health_care/viewmodels/user_provider.dart';
import 'package:health_care/views/screens/auth/Login/login_screen.dart';
import 'package:provider/provider.dart';
import '../services/local_storage_service.dart';
import '../views/screens/home/home_screens.dart';
import '../config/app_config.dart';

class AuthViewModel with ChangeNotifier {
  /// Đăng nhập
  Future<void> login(
      BuildContext context, String phoneNumber, String password) async {
    String? errorMessage = await AppConfig.login(phoneNumber, password);

    if (!context.mounted) return; // 🔹 Kiểm tra State còn tồn tại không

    if (errorMessage == null) {
      // Hiển thị thông báo thành công
      showToastSuccess("Đăng nhập thành công!");
      // Lấy token đã lưu
      String? token = await LocalStorageService.getToken();
      print("Token đã lưu sau khi đăng nhập: $token");

// 🔹 Lấy customerId từ API
      int? customerId = await AppConfig.getMyUserId();
      if (customerId != null) {
        await LocalStorageService.saveUserId(customerId);
        if (!context.mounted) return;

        // 🔹 Lưu customerId vào Provider
        Provider.of<UserProvider>(context, listen: false)
            .setCustomerId(customerId);
        print("Đã lưu customerId vào Provider: $customerId");
      } else {
        showToastError("Không thể lấy ID người dùng!");
        return;
      }
      // Chuyển sang màn hình Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreens()),
      );
    } else {
      showToastError(errorMessage);
    }
  }

  /// Đăng ký + Xác thực OTP
  Future<void> register(
    BuildContext context,
    String fullName,
    String phoneNumber,
    String email,
    String password,
  ) async {
    // Gọi API đăng ký từ AppConfig
    String? errorMessage = await AppConfig.register(
        context, fullName, phoneNumber, email, password);

    if (!context.mounted) return; // 🔹 Kiểm tra State còn tồn tại không

    if (errorMessage == null) {
      // Hiển thị thông báo OTP đã gửi
      showToastSuccess("Đăng ký tài khoản thành công!");
      // Chuyển sang màn hình Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreens()),
      );
    } else {
      showToastError(errorMessage);
    }
  }

  /// Quên mật khẩu: Gửi OTP và xác thực
  Future<String?> forgotPassword(BuildContext context, String email) async {
    String? result = await AppConfig.forgotPassword(context, email);

    if (!context.mounted) return null;

    if (result == "cancelled") {
      Fluttertoast.showToast(
        msg: "Bạn đã hủy xác thực OTP.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return null; // Hủy thì không trả về OTP
    } else if (result != null) {
      showToastSuccess("Xác thực OTP thành công!");
      return result; // OTP hợp lệ
    } else {
      showToastError("Xác thực OTP thất bại!");
      return null;
    }
  }

  /// Đặt lại mật khẩu mới
  Future<void> resetPassword(
    BuildContext context,
    String email,
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    String? result = await AppConfig.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (!context.mounted) return;

    if (result == null) {
      showToastSuccess("Đặt lại mật khẩu thành công!");

      // Quay về màn hình đăng nhập
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      showToastError(result);
    }
  }

  /// Cập nhật hồ sơ
  Future<bool> updateProfile(
      BuildContext context, Map<String, dynamic> profileData) async {
    // 🔹 Lấy userId từ local storage
    int? userId = await LocalStorageService.getUserId();

    // 🔹 Nếu chưa có, gọi API lấy userId
    if (userId == null) {
      userId = await AppConfig.getMyUserId();
      if (userId != null) {
        await LocalStorageService.saveUserId(userId); // Lưu lại để dùng sau
      }
    }

    // 🔹 Nếu vẫn không có userId, báo lỗi
    if (userId == null) {
      showToastError("Không thể cập nhật hồ sơ! Vui lòng đăng nhập trước.");
      return false; // ❌ Cập nhật thất bại
    }

    // 🔹 Đảm bảo `profileData` có chứa `id`
    profileData['id'] = userId;

    String? errorMessage = await AppConfig.updateProfile(profileData);

    if (!context.mounted) return false;

    if (errorMessage == null) {
      showToastSuccess("Cập nhật hồ sơ thành công!");
      Navigator.pop(context); // Quay lại màn hình trước đó
      return true; // ✅ Cập nhật thành công
    } else {
      showToastError(errorMessage);
      return false; // ❌ Cập nhật thất bại
    }
  }

  /// Upload ảnh đại diện
  Future<void> uploadAvatar(BuildContext context, File imageFile) async {
    int? userId = await LocalStorageService.getUserId();

    if (userId == null) {
      showToastError("Không tìm thấy ID người dùng, vui lòng đăng nhập lại!");
      return;
    }

    // Gọi API upload
    String? result = await AppConfig.uploadAvatar(imageFile, userId);

    if (!context.mounted) return;

    if (result != null) {
      showToastSuccess("Cập nhật ảnh đại diện thành công!");
      notifyListeners(); // Cập nhật giao diện
    } else {
      showToastError("Cập nhật ảnh đại diện thất bại. Vui lòng thử lại!");
    }
  }

  /// Đổi mật khẩu
  Future<void> changePassword(BuildContext context, String oldPassword,
      String newPassword, String confirmNewPassword) async {
    // Lấy token người dùng từ local storage
    String? token = await LocalStorageService.getToken();
    int? customerId = await LocalStorageService.getUserId();

    if (token == null || customerId == null) {
      showToastError(
          "Không tìm thấy thông tin đăng nhập, vui lòng đăng nhập lại!");
      return;
    }

    // Gọi API đổi mật khẩu
    String? errorMessage = await AppConfig.changePassword(
        customerId, oldPassword, newPassword, confirmNewPassword);

    if (!context.mounted) return;

    if (errorMessage == null) {
      showToastSuccess("Đổi mật khẩu thành công!");
      Navigator.pop(context); // Quay lại màn hình trước đó
    } else {
      showToastError(errorMessage);
    }
  }

  /// Đăng xuất
  Future<void> signOut(BuildContext context) async {
    String? errorMessage = await AppConfig.logout();

    if (!context.mounted) return; // 🔹 Kiểm tra State còn tồn tại không

    if (errorMessage == null) {
      print("Token đã bị xóa thành công!");
      await LocalStorageService.logOut(); // Xóa token

      showToastSuccess("Đăng xuất thành công!");

      // Chuyển về màn hình Splash
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      showToastError("Lỗi khi đăng xuất: $errorMessage");
    }
  }
}
