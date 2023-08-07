import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/model/account_model.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';

import '../model/account_respone.dart';

class UpdateProfileController extends GetxController {
  // TextEditingController emailController = TextEditingController();
  final AccountResponse account;
  UpdateProfileController(this.account);

  var isValidFullname = true.obs;
  var isValidPhonenumber = true.obs;

  File? image;
  String? selectedGender;
  DateTime? date;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final accountApi = Get.find<AccountApi>();

  @override
  void onInit() {
    super.onInit();
    fetchCurrent();
  }

  void fetchCurrent() {
    fullNameController.text = account.fullName.toString();
    phoneNumberController.text = account.phoneNumber.toString();
    date = account.birthday;
    selectedGender = account.gender;
  }

  @override
  void onClose() {
    super.onClose();
    isValidFullname.value = isValidPhonenumber.value = true;
    fullNameController.clear();
    phoneNumberController.clear();
    image = date = selectedGender = null;
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
    RegExp regex = RegExp(r'^(84|0)[35789]([0-9]{8})$');
    if (!regex.hasMatch(phonenumber)) {
      return 'Số điện thoại không đúng định dạng!';
    }
    isValidPhonenumber.value = true;
    return null;
  }

  Future<String> updateAccount() async {
    AccountModel updatedAccount = account.toAccountModel();
    updatedAccount.birthday = date;
    updatedAccount.gender = selectedGender;
    updatedAccount.fullName = fullNameController.text;
    updatedAccount.phone = phoneNumberController.text;
    ResponseBaseModel respone = await accountApi.updateAccount(updatedAccount);
    if (respone.message == 'Success') {
      await accountApi.login(updatedAccount.accountId);
      return respone.message.toString();
    }
    return respone.message.toString();
  }
}
