import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/views/screens/auth/register/otp_popup.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Register a user with email and password
  // Future<User?> registerWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     throw Exception(e.message);
  //   }
  // }

  // Login a user with email and password
  // Future<User?> loginWithEmailAndPassword(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     throw Exception(e.message);
  //   }
  // }

  // Login with Google
  Future<User?> loginWithGoogle() async {
    try {
      // Bắt đầu quá trình đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception("Người dùng đã hủy đăng nhập Google");
      }

      // Lấy thông tin xác thực Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập Firebase với thông tin xác thực Google
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Lỗi đăng nhập: ${e.message}");
    } catch (e) {
      throw Exception("Đăng nhập Google thất bại: $e");
    }
  }

  // // Kiểm tra trạng thái đăng nhập Facebook
  // Future<bool> isFacebookLoggedIn() async {
  //   final accessToken = await FacebookAuth.instance.accessToken;
  //   return accessToken != null;
  // }

  // Future<void> checkAccessToken() async {
  //   final accessToken = await FacebookAuth.instance.accessToken;
  //   if (accessToken == null) {
  //     print("Access Token đã được xóa.");
  //   } else {
  //     print("Access Token vẫn tồn tại: ${accessToken.tokenString}");
  //   }
  // }

  // // Login with Facebook
  // Future<User?> loginWithFacebook() async {
  //   try {
  //     // Xóa cache và đăng xuất khỏi Facebook trước khi đăng nhập lại
  //     await FacebookAuth.instance.logOut();

  //     // Hiển thị màn hình đăng nhập Facebook
  //     final LoginResult loginResult = await FacebookAuth.instance.login();

  //     if (loginResult.status != LoginStatus.success ||
  //         loginResult.accessToken == null) {
  //       throw Exception('Đăng nhập Facebook thất bại: ${loginResult.message}');
  //     }

  //     // Lấy thông tin xác thực từ Facebook
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

  //     // Đăng nhập Firebase với thông tin xác thực
  //     final UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithCredential(facebookAuthCredential);

  //     return userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     throw Exception('Lỗi đăng nhập Firebase với Facebook: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Đăng nhập Facebook thất bại: $e');
  //   }
  // }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      // Đăng xuất khỏi Firebase
      await _auth.signOut();
    } catch (e) {
      print("Lỗi khi đăng xuất Firebase: $e");
    }

    try {
      // Đăng xuất Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
    } catch (e) {
      print("Lỗi khi đăng xuất Google: $e");
    }

    // try {
    //   // Đăng xuất Facebook
    //   await FacebookAuth.instance.logOut();
    // } catch (e) {
    //   print("Lỗi khi đăng xuất Facebook: $e");
    // }

    print("Hoàn tất quá trình đăng xuất.");
  }

  // Get the currently signed-in user
  User? get currentUser => _auth.currentUser;
}

phoneNumberVerification({
  required String phoneNumber,
  required BuildContext context,
}) async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {},
    verificationFailed: (FirebaseAuthException e) {},
    codeSent: (String verificationId, int? resendToken) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPPopup(verificationID: verificationId),));
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}
