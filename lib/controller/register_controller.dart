import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/model/account_model.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

class RegisterController extends GetxController {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final accountApi = Get.find<AccountApi>();
  // Future register() async {
  //   AccountModel newAccount = AccountModel();
  //   newAccount.fullName = fullnameController.text;
  //   newAccount.email = emailController.text;
  //   newAccount.password = passwordController.text;
  //   await accountApi.register(newAccount);
  // }

  String? errorMessage;
  Future<String?> signUp() async {
    final auth = FirebaseAuth.instance;
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => {pushDataToFirestore(auth)});
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Email không đúng định dạng.";
          break;

        case "too-many-requests":
          errorMessage = "Quá nhiều yêu cầu (thử lại sau 30s)";
          break;
        case "operation-not-allowed":
          errorMessage =
              "Không thể đăng nhập vì nhà phát triển đang tạm tắt chức năng này vì lý do kỹ thuật.";
          break;
        default:
          errorMessage = "Lỗi chưa xác định.";
      }
      return errorMessage;
    }
    return 'Đăng ký thành công!';
    // snackBarPopUp(context, "Đang kiểm tra thông tin vui lòng đợi...");
  }

  Future pushDataToFirestore(FirebaseAuth auth) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    AccountModel account = AccountModel();
    // String imageUrl = await uploadAvatar(user!.uid);
    account.id = user?.uid;
    account.email = user?.email;
    // userModel.Avatar = imageUrl;
    account.fullName = fullnameController.text;
    account.accountType = "Customer";
    // await firebaseFirestore
    //     .collection("user")
    //     .doc(user?.uid)
    //     .set(account.toMap());
    await accountApi.register(account);
    CustomSuccessMessage.showMessage(
        "Đăng ký thành công vui lòng đăng nhập tài khoản của bạn");
  }
}
