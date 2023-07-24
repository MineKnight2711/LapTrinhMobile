import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_mobile_app/model/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/account_api.dart';
import '../model/account_respone.dart';
import '../widgets/custom_widgets/message.dart';
import 'account_controller.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final accountApi = Get.find<AccountApi>();
  final auth = FirebaseAuth.instance;
  var isValidEmail = false.obs;
  var enableFingerprint = false.obs;
  @override
  void onInit() {
    super.onInit();
    checkFingerPrint();
  }

  @override
  void onClose() {
    super.onClose();
    isValidEmail.value = false;
    emailController.clear();
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

  Future<String?> logIn(String email, String password) async {
    try {
      return await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        // ignore: unused_local_variable
        User? user = auth.currentUser;
        user = userCredential.user;
        auth.authStateChanges();
        auth.userChanges();
        return 'Success';
      });
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // preferences.setString('email', email);
    } on FirebaseAuthException catch (error) {
      String errorMessage = '';
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Email không hợp lệ!.";
          break;
        case "wrong-password":
          errorMessage = "Sai mật khẩu.";
          break;
        case "user-not-found":
          errorMessage = "Tài khoản không tồn tại.";
          break;
        case "user-disabled":
          errorMessage = "Tài khoản bị khoá.";
          break;
        case "too-many-requests":
          errorMessage = "Sai mật khẩu quá nhiều lần vui lòng đợi 30 giây";
          break;
        case "operation-not-allowed":
          errorMessage =
              "Không thể đăng nhập vui lòng liên hệ người phát triển.";
          break;
        default:
          errorMessage = "Lỗi chưa xác định.";
      }
      return errorMessage;
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
    account.id = newUserId;
    account.email = userCredential.user?.email;
    account.fullName = userCredential.user?.displayName;
    account.accountType = "Customer";
    return await firebaseFirestore
        .collection("users")
        .doc(newUserId)
        .get()
        .then((value) async {
      if (!value.exists) {
        //Upload hình mặc định

        // userModel.Avatar = await uploadAvatar(newUserId ?? "");
        // firebaseFirestore
        //     .collection("user")
        //     .doc(newUserId)
        //     .set(account.toMap());
        // print(account.toMap());
        await accountApi.register(account);
        // preferences.setString('email', userCredential.user!.email.toString());

        return 'SigninSuccess';
        // await getCurrentUser();
        // await convertToUserModel();
      } else {
        // preferences.setString('email', userCredential.user!.email.toString());
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

  Future setFingerPrintState(bool value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('finger_print_enable', value);
  }

  Future checkFingerPrint() async {
    final pref = await SharedPreferences.getInstance();
    var value = pref.getBool('finger_print_enable');
    if (value == null) {
      enableFingerprint.value = false;
    } else {
      enableFingerprint.value = value;
    }
  }
}
