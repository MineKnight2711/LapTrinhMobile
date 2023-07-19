import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/model/account_model.dart';

class RegisterController extends GetxController {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final accountApi = Get.find<AccountApi>();
  Future register() async {
    AccountModel newAccount = AccountModel();
    newAccount.fullName = fullnameController.text;
    newAccount.email = emailController.text;
    newAccount.password = passwordController.text;
    await accountApi.register(newAccount);
  }
}
