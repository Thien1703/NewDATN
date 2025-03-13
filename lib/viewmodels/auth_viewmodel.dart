import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_care/views/screens/auth/login/login_screen.dart';
import '../services/local_storage_service.dart';
import '../views/screens/home/home_screens.dart';
import 'api/api_service.dart';

class AuthViewModel with ChangeNotifier {
  /// Đăng nhập
  Future<void> login(
      BuildContext context, String phone, String password) async {
    String? errorMessage = await ApiService.login(phone, password);

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
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Đăng ký
  Future<void> register(BuildContext context, String fullName,
      String phoneNumber, String password) async {
    String? errorMessage =
        await ApiService.register(fullName, phoneNumber, password);

    if (!context.mounted) return; // 🔹 Kiểm tra State còn tồn tại không

    if (errorMessage == null) {
      // Hiển thị thông báo đăng ký thành công
      Fluttertoast.showToast(
        msg: "Đăng ký thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      // Lấy token đã lưu
      String? token = await LocalStorageService.getToken();
      print("Token đã lưu sau khi đăng ký: $token");

      // Chuyển sang màn hình Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreens()),
      );
    } else {
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Cập nhật hồ sơ
  Future<void> updateProfile(
      BuildContext context, Map<String, dynamic> profileData, File? avatar) async {
    // 🔹 Lấy userId từ local storage
    int? userId = await LocalStorageService.getUserId();

    // 🔹 Nếu chưa có, gọi API lấy userId
    if (userId == null) {
      userId = await ApiService.getMyUserId();
      if (userId != null) {
        await LocalStorageService.saveUserId(userId); // Lưu lại để dùng sau
      }
    }

    // 🔹 Nếu vẫn không có userId, báo lỗi
    if (userId == null) {
      Fluttertoast.showToast(
        msg: "Lỗi: Không thể xác định ID người dùng.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // 🔹 Đảm bảo `profileData` có chứa `id`
    profileData['id'] = userId;

    String? errorMessage = await ApiService.updateProfile(profileData);

    if (!context.mounted) return;

    if (errorMessage == null) {
      Fluttertoast.showToast(
        msg: "Cập nhật hồ sơ thành công!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pop(context); // Quay lại màn hình trước đó
    } else {
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }


  /// Đăng xuất
  Future<void> signOut(BuildContext context) async {
    String? errorMessage = await ApiService.logout();

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
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Lỗi khi đăng xuất: $errorMessage",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
