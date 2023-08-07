// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_mobile_app/controller/register_controller.dart';
import 'package:keyboard_mobile_app/model/account_model.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import '../api/account_api.dart';
import '../model/account_respone.dart';
import '../widgets/custom_widgets/message.dart';
import 'account_controller.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  // TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final accountApi = Get.find<AccountApi>();
  final registerController = Get.find<RegisterController>();
  final auth = FirebaseAuth.instance;
  var isValidEmail = false.obs;
  var isValidPassword = false.obs;

  @override
  void onClose() {
    super.onClose();
    isValidEmail.value = isValidPassword.value = false;
    emailController.clear();
    passwordController.clear();
  }

  //Kiểm tra email hợp lệ
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      isValidEmail.value = false;
      return 'Email không được trống';
    }
    //Đây là Regex cho đa số trường hợp email, tuy nhiên vẫn có một số ngoại lệ như sau:
    //huynhphuocdat.siu@résumé.com đây là trường hợp email hợp lệ nhưng sẽ không match được regex này vì không hỗ trợ các ký tự nằm ngoài bảng mã ASCII
    //Thêm 1 trường hợp nữa là <datcute2711@yahoo.com> đây vẫn là 1 email hợp lệ nhưng cũng không match regex vì không hỗ trợ dấu < và >
    // RegExp emailRegex =
    //     RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    //Còn đây là regex cho riêng gmail
    RegExp gmailRegex = RegExp(
        r'[\w]*@*[a-z]*\.*[\w]{5,}(\.)*(com)*(@gmail\.com)',
        multiLine: true);
    if (!gmailRegex.hasMatch(email)) {
      isValidEmail.value = false;
      return 'Email không đúng định dạng';
    }

    isValidEmail.value = true;

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      isValidPassword.value = false;
      return 'Mật khẩu không được trống';
    }

    isValidPassword.value = true;

    return null;
  }

  Future<String> logIn(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // ignore: unused_local_variable
      User? user = auth.currentUser;
      user = userCredential.user;

      auth.authStateChanges();
      auth.userChanges();
      return 'Success';
    } on FirebaseAuthException catch (error) {
      String errorMessage = getErrorMessage(error.code);
      return errorMessage;
    }
  }

  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case "invalid-email":
        return "Email không hợp lệ!";
      case "wrong-password":
        return "Sai mật khẩu hoặc tài khoản không có mật khẩu\nNếu tài khoản của bạn đã liên kết với google hãy dùng chức năng bên dưới .";
      case "user-not-found":
        return "Tài khoản không tồn tại.";
      case "user-disabled":
        return "Tài khoản bị khoá.";
      case "too-many-requests":
        return "Sai mật khẩu quá nhiều lần vui lòng đợi 30 giây";
      case "requires-recent-login":
        return "Yêu cầu đăng nhập gần đây để thực hiện thao tác nhạy cảm.";
      case "operation-not-allowed":
        return "Không thể đăng nhập vui lòng liên hệ người phát triển.";
      default:
        return "Lỗi chưa xác định.";
    }
  }

  Future<String?> signInWithGoogle() async {
    GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().onError((error, stackTrace) {
      CustomErrorMessage.showMessage('$error');
      return null;
    });
    if (googleUser == null) {
      return 'CancelSignIn';
    }

    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    var newUserId = userCredential.user?.uid;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    AccountModel account = AccountModel();
    account.accountId = newUserId;
    account.email = userCredential.user?.email;
    account.fullName = userCredential.user?.displayName;
    return await firebaseFirestore
        .collection("accounts")
        .doc(newUserId)
        .get()
        .then((value) async {
      if (!value.exists) {
        await registerController.passAccountSigninWithGoogle(account);
        return 'SigninSuccess';
      } else {
        await accountApi.login(newUserId);
        return 'LoginSuccess';
      }
    });
  }

  Future<String> authenticatedWithFingerPrint() async {
    AccountResponse? accountResponseResult =
        await AccountController().getUserFromSharedPreferences();
    if (accountResponseResult != null) {
      accountApi.accountRespone.value = accountResponseResult;
      return 'Success';
    }
    return 'NotFound';
  }

  Future<ResponseBaseModel> forgotPassword(String email) async {
    ResponseBaseModel respone = ResponseBaseModel();
    if (email.isEmpty || isValidEmail.value == false) {
      respone.message = 'InvalidEmail';
      return respone;
    }
    respone = await accountApi.forgotPassword(email);
    return respone;
  }
}
