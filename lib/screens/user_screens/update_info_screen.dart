// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/update_profile_controller.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/screens/user_screens/components/body.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';

class ChangeInfo extends StatelessWidget {
  final AccountResponse account;
  ChangeInfo({super.key, required this.account});
  final profileController = Get.find<UpdateProfileController>();
  @override
  Widget build(BuildContext context) {
    profileController.fetchCurrent();
    return Scaffold(
        appBar: CustomAppBar(
          onPressed: () {
            profileController.onClose();
            Navigator.pop(context);
          },
          title: 'Cập nhật thông tin',
        ),
        body: BodyAccount(account: account));
  }
}
