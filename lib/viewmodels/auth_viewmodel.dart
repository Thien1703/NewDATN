import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_care/views/screens/auth/Login/newLogin.dart';
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
      Fluttertoast.showToast(
        msg: "Đăng nhập thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      // Lấy token đã lưu
      String? token = await LocalStorageService.getToken();
      print("Token đã lưu sau khi đăng nhập: $token");

      // Chuyển sang màn hình Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreens()),
      );
    } else {
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
      Fluttertoast.showToast(
        msg: "Đăng ký tài khoản thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      // Chuyển sang màn hình Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreens()),
      );
    } else {
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // // Quên mật khẩu ==> Đặt lại mật khẩu
  // Future<void> forgotPassword(
  //   BuildContext context,
  //   String email,
  //   String newPassword,
  //   String confirmPassword,
  // ) async {
  //   // Bước 1: Gửi OTP tới email
  //   String? sendOtpError = await AppConfig.sendOtpForForgotPassword(email);

  //   if (!context.mounted) return;

  //   if (sendOtpError != null) {
  //     Fluttertoast.showToast(
  //       msg: sendOtpError,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //     return;
  //   }

  //   Fluttertoast.showToast(
  //     msg: "Đã gửi mã OTP tới email.",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.green,
  //     textColor: Colors.white,
  //   );

  //   // Bước 2: Hiển thị dialog nhập mã OTP
  //   final otp = await AppConfig.showOtpDialog(context);

  //   if (otp == null || otp.isEmpty) {
  //     Fluttertoast.showToast(
  //       msg: "Xác thực OTP đã bị huỷ.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.orange,
  //       textColor: Colors.white,
  //     );
  //     return;
  //   }

  //   // Bước 3: Xác thực OTP
  //   String? verifyError = await AppConfig.verifyForgotPasswordOtp(
  //     email: email,
  //     otp: otp,
  //   );

  //   if (verifyError != null) {
  //     Fluttertoast.showToast(
  //       msg: verifyError,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //     return;
  //   }

  //   // Bước 4: Gửi yêu cầu đặt lại mật khẩu
  //   String? resetError = await AppConfig.resetPassword(
  //     email: email,
  //     otp: otp,
  //     newPassword: newPassword,
  //     confirmPassword: confirmPassword,
  //   );

  //   if (resetError == null) {
  //     Fluttertoast.showToast(
  //       msg: "Đặt lại mật khẩu thành công!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //     );

  //     // Chuyển về màn hình đăng nhập
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (_) => LoginScreen()),
  //       (route) => false,
  //     );
  //   } else {
  //     Fluttertoast.showToast(
  //       msg: resetError,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   }
  // }

  /// Cập nhật hồ sơ
  Future<bool> updateProfile(BuildContext context,
      Map<String, dynamic> profileData, File? avatar) async {
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
      Fluttertoast.showToast(
        msg: "Lỗi: Không thể xác định ID người dùng.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false; // ❌ Cập nhật thất bại
    }

    // 🔹 Đảm bảo `profileData` có chứa `id`
    profileData['id'] = userId;

    String? errorMessage = await AppConfig.updateProfile(profileData);

    if (!context.mounted) return false;

    if (errorMessage == null) {
      Fluttertoast.showToast(
        msg: "Cập nhật hồ sơ thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pop(context); // Quay lại màn hình trước đó
      return true; // ✅ Cập nhật thành công
    } else {
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false; // ❌ Cập nhật thất bại
    }
  }

  /// Upload ảnh đại diện
  Future<void> uploadAvatar(BuildContext context, File imageFile) async {
    int? userId = await LocalStorageService.getUserId();

    if (userId == null) {
      Fluttertoast.showToast(
        msg: "Không tìm thấy ID người dùng, vui lòng đăng nhập lại.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Gọi API upload
    String? result = await AppConfig.uploadAvatar(imageFile, userId);

    if (!context.mounted) return;

    if (result != null) {
      Fluttertoast.showToast(
        msg: "Cập nhật ảnh đại diện thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      notifyListeners(); // Cập nhật giao diện
    } else {
      Fluttertoast.showToast(
        msg: "Upload ảnh thất bại!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Đổi mật khẩu
  Future<void> changePassword(BuildContext context, String oldPassword,
      String newPassword, String confirmNewPassword) async {
    // Lấy token người dùng từ local storage
    String? token = await LocalStorageService.getToken();
    int? customerId = await LocalStorageService.getUserId();

    if (token == null || customerId == null) {
      Fluttertoast.showToast(
        msg: "Lỗi: Không tìm thấy thông tin đăng nhập, vui lòng đăng nhập lại.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Gọi API đổi mật khẩu
    String? errorMessage = await AppConfig.changePassword(
        customerId, oldPassword, newPassword, confirmNewPassword);

    if (!context.mounted) return;

    if (errorMessage == null) {
      Fluttertoast.showToast(
        msg: "Đổi mật khẩu thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pop(context); // Quay lại màn hình trước đó
    } else {
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Đăng xuất
  Future<void> signOut(BuildContext context) async {
    String? errorMessage = await AppConfig.logout();

    if (!context.mounted) return; // 🔹 Kiểm tra State còn tồn tại không

    if (errorMessage == null) {
      print("Token đã bị xóa thành công!");
      await LocalStorageService.logOut(); // Xóa token

      Fluttertoast.showToast(
        msg: "Đăng xuất thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Chuyển về màn hình Splash
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Lỗi khi đăng xuất: $errorMessage",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
