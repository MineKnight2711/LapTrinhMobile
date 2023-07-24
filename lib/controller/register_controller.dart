import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/model/account_model.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

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
  TextEditingController nickNameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final accountApi = Get.find<AccountApi>();
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
    nickNameController.clear();
    fullnameController.clear();
    phonenumberController.clear();
    addressController.clear();
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
    return 'Success';
    // snackBarPopUp(context, "Đang kiểm tra thông tin vui lòng đợi...");
  }

  Future pushDataToFirestore(FirebaseAuth auth) async {
    User? user = auth.currentUser;

    AccountModel account = AccountModel();
    // String imageUrl = await uploadAvatar(user!.uid);
    account.id = user?.uid;
    account.email = user?.email;
    account.phone = phonenumberController.text;
    account.address = addressController.text;
    account.fullName = fullnameController.text;
    account.nickname = nickNameController.text;
    account.accountType = "Customer";
    if (selectedGender != null) {
      account.gender = selectedGender;
    } else {
      CustomErrorMessage.showMessage('Bạn chưa chọn giới tính');
      return;
    }
    if (date != null) {
      account.birthday = date;
    } else {
      CustomErrorMessage.showMessage('Vui lòng kiểm tra ngày sinh!');
      return;
    }
    await accountApi.register(account);
    CustomSuccessMessage.showMessage(
        "Đăng ký thành công vui lòng đăng nhập tài khoản của bạn");
  }
}
