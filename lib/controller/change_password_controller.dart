import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';

class ChangePasswordController extends GetxController {
  var isValidOldPassword = false.obs;
  var isValidPassword = false.obs;
  var isValidReenter = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newpassController = TextEditingController();
  TextEditingController reenterpassController = TextEditingController();
  final accountApi = Get.find<AccountApi>();
  //Pương thức onClose được định nghĩa lại từ lớp cha là GexController,
  //Khi phương thức này được thực thi các lớp TextEditingController khai báo bên trên sẽ được loại bỏ để giảm thiểu tài nguyên sử dụng
  User? user;
  @override
  void onClose() {
    super.onClose();
    isValidPassword.value =
        isValidReenter.value = isValidOldPassword.value = false;
    emailController.clear();
    oldPassController.clear();
    newpassController.clear();
    reenterpassController.clear();
  }

  //Kiểm tra mật khẩu hợp lệ
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      isValidPassword.value = false;
      return 'Mật khẩu không được trống';
    }
    RegExp regex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$');
    if (!regex.hasMatch(password)) {
      isValidPassword.value = false;
      return 'Mật khẩu phải chứa ít nhất:\n* 1 ký tự hoa,\n* 1 ký tự thường ,\n* 1 số,\n* 1 ký tự đặc biệt,\n* 8 ký tự';
    }

    isValidPassword.value = true;

    return null;
  }

  //Kiểm tra xác nhận mật khẩu hợp lệ
  String? validateReenterPassword(String? reenterpassword) {
    if (reenterpassword == null || reenterpassword.isEmpty) {
      isValidReenter.value = false;
      return 'Mật khẩu không được trống!';
    }
    if (reenterpassword != newpassController.text) {
      isValidReenter.value = false;
      return 'Mật khẩu không khớp!';
    }
    isValidReenter.value = true;
    return null;
  }

  bool checkUserAuthencation() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (final userInfo in user.providerData) {
        if (userInfo.providerId == "google.com") {
          return true;
        }
      }
    }
    return false;
  }

  //Kiểm tra xác nhận mật khẩu hợp lệ
  String? validateOldPassword(String? oldPassword) {
    if (oldPassword == null || oldPassword.isEmpty) {
      isValidOldPassword.value = false;
      return 'Mật khẩu không được trống!';
    }
    isValidOldPassword.value = true;
    return null;
  }

  Future<String?> createPassword(String email, String newPassword) async {
    ResponseBaseModel respone =
        await accountApi.changePassword(email, newPassword);
    return respone.message;
  }

  Future<String> changePassword(
      String email, String oldPassword, String newPassword) async {
    //Lấy user hiện tại từ FirebaseAuth
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      user = currentUser;
    });

    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: oldPassword);

    Map<String, String?> codeResponses = {
      //Mã exception để validate oldpassword và email
      "user-not-found": "Không tìm thấy tài khoản!",
      "wrong-password": "Mật khẩu cũ không đúng!",
      //Các exception không dùng đến nhưng có thể xảy ra
      //********* "user-mismatch": "Thông tin không đúng!", *********/
      //********* "invalid-credential": "Phiên không hợp lệ! Vui lòng thử lại sau!", *********/
      //********* "invalid-email": "Email không đúng! Vui lòng kiểm tra lại email!", *********/
      //Dùng trong các trường hợp xác thực bằng mã ví dụ OTP, ở đây ta cũng không dùng đến *********/
      //********* "invalid-verification-code": "", *********/
      //********* "invalid-verification-id": "", *********/
      // Các exceptin khác khi đổi mật khẩu
      //********* "weak-password": "Mật khẩu yếu", *********/
      //********* "requires-recent-login": "Yêu cầu đăng nhập gần đây" *********/
    };
    try {
      //Xác thực lại tài khoản hiện tại trước khi đổi mật khẩu
      await user?.reauthenticateWithCredential(credential);
      ResponseBaseModel respone =
          await accountApi.changePassword(email, newPassword);
      return respone.message ?? 'Unknown';
    } on FirebaseAuthException catch (error) {
      return codeResponses[error.code] ?? 'Unknown';
    }
  }
}
