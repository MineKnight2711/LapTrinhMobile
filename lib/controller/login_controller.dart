import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_mobile_app/model/account_model.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import '../api/account_api.dart';
import '../widgets/custom_widgets/message.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final accountApi = Get.find<AccountApi>();
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
        .doc(userCredential.user?.uid)
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
        Fluttertoast.showToast(msg: "Đăng nhập thành công ");
        return 'LoginSuccess';
        // zoominTransition(context, AppHomeScreen());
        // await getCurrentUser();
        // await convertToUserModel();
      }
    });
  }

  // Future<String?> facebookSignIn() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       final AuthCredential credential =
  //           FacebookAuthProvider.credential(result.accessToken!.token);
  //       await FirebaseAuth.instance.signInWithCredential(credential);

  //       return 'Đăng nhập thành công';
  //     } else if (result.status == LoginStatus.failed) {
  //       return 'Đăng nhập thất bại';
  //     }
  //   } catch (e) {
  //     print('Có lỗi xảy ra: $e');
  //   }
  //   return null;
  // }
}
