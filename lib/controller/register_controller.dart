import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/model/account_model.dart';

class RegisterController extends GetxController {
  var isValidEmail = false.obs;
  var isValidPassword = false.obs;
  var isValidReenter = false.obs;
  var isValidFullname = false.obs;
  var isValidPhonenumber = false.obs;
  var isValidAddress = false.obs;
  DateTime? date;
  String? selectedGender;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  final accountApi = Get.find<AccountApi>();
  Rx<AccountModel?> signInWithGoogleAccount = Rx<AccountModel?>(null);
  @override
  void onClose() {
    super.onClose();
    isValidEmail.value = isValidPassword.value = isValidReenter.value =
        isValidFullname.value =
            isValidPhonenumber.value = isValidAddress.value = false;
    emailController.clear();
    otpController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    fullnameController.clear();
    phonenumberController.clear();
    date = selectedGender = null;
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
    if (reenterpassword != passwordController.text) {
      isValidReenter.value = false;
      return 'Mật khẩu không khớp!';
    }
    isValidReenter.value = true;
    return null;
  }

  String? validateFullname(String? fullname) {
    if (fullname == null || fullname.isEmpty) {
      isValidFullname.value = false;
      return 'Họ tên không được trống!';
    }
    isValidFullname.value = true;
    return null;
  }

  String? validatePhonenumber(String? phonenumber) {
    if (phonenumber == null || phonenumber.isEmpty) {
      isValidPhonenumber.value = false;
      return 'Số điện thoại không được trống!';
    }
    isValidPhonenumber.value = true;
    return null;
  }

  String? validateAddress(String? address) {
    if (address == null || address.isEmpty) {
      isValidAddress.value = false;
      return 'Địa chỉ không được trống!';
    }
    isValidAddress.value = true;
    return null;
  }

  Future passAccountSigninWithGoogle(AccountModel receivedAccount) async {
    AccountModel newAccount = AccountModel();
    newAccount.accountId = receivedAccount.accountId;
    newAccount.fullName = receivedAccount.fullName;
    newAccount.email = receivedAccount.email;
    signInWithGoogleAccount.value = newAccount;
  }

  Future<String> signUpwithGoogle() async {
    if (signInWithGoogleAccount.value != null) {
      signInWithGoogleAccount.value!.birthday = date;
      signInWithGoogleAccount.value!.gender = selectedGender;
      signInWithGoogleAccount.value!.phone = phonenumberController.text;
      signInWithGoogleAccount.value!.imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/keyboard-mobile-app.appspot.com/o/default_avatar.png?alt=media&token=125fef63-2e77-45d7-aedd-effdda210fbd';
      print(signInWithGoogleAccount.value!.toMap());
      await accountApi.register(signInWithGoogleAccount.value!);
      return 'Success';
    }
    return 'NoAccount';
  }

  Future<String?> signUp() async {
    if (selectedGender == null) {
      return 'Bạn chưa chọn giới tính';
    }
    if (date == null) {
      return 'Vui lòng kiểm tra ngày sinh!';
    }
    final auth = FirebaseAuth.instance;
    try {
      return await auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        return pushDataToFirestore(value);
      });
    } on FirebaseAuthException catch (error) {
      String? errorMessage;
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Email không đúng định dạng.";
          break;
        case "email-already-in-use":
          errorMessage =
              "Địa chỉ email đã được sử dụng bởi một tài khoản khác.";
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
    // return 'Success';
    // snackBarPopUp(context, "Đang kiểm tra thông tin vui lòng đợi...");
  }

  Future<String> pushDataToFirestore(UserCredential userCredential) async {
    User? user = userCredential.user;
    AccountModel account = AccountModel();
    // String imageUrl = await uploadAvatar(user!.uid);
    account.accountId = user?.uid;
    account.email = user?.email;
    account.phone = phonenumberController.text;
    account.fullName = fullnameController.text;
    account.imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/keyboard-mobile-app.appspot.com/o/default_avatar.png?alt=media&token=125fef63-2e77-45d7-aedd-effdda210fbd';
    account.gender = selectedGender;
    account.birthday = date;
    await accountApi.register(account);
    return 'Success';
  }
}
