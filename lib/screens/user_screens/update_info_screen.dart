// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/update_profile_controller.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/gender_chose.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';
import '../../configs/mediaquery.dart';
import '../../widgets/custom_widgets/custom_input.dart';
import '../../widgets/custom_widgets/datetime_picker.dart';

class ChangeInfo extends StatelessWidget {
  final AccountResponse account;
  ChangeInfo({super.key, required this.account});
  final profileController = Get.find<UpdateProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          profileController.onClose();
          Navigator.pop(context);
        },
        title: 'Cập nhật thông tin',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mediaHeight(context, 23),
            ),
            SizedBox(
              height: mediaHeight(context, 23),
            ),
            BirthdayDatePickerWidget(
              initialDate: account.birthday,
              onChanged: (value) {
                profileController.date = value;
              },
            ),
            SizedBox(
              height: mediaHeight(context, 40),
            ),
            GenderSelectionWidget(
              gender: account.gender,
              onChanged: (value) {
                profileController.selectedGender = value;
              },
              size: 2,
            ),
            SizedBox(
              height: mediaHeight(context, 50),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  CustomInputTextField(
                    controller: profileController.fullNameController,
                    hintText: 'Nhập họ tên...',
                    labelText: 'Họ và tên...',
                    onChanged: profileController.validateFullname,
                  ),
                  SizedBox(
                    height: mediaHeight(context, 40),
                  ),
                  CustomInputTextField(
                    controller: profileController.phoneNumberController,
                    hintText: 'Nhập số điện thoại...',
                    labelText: 'Số điện thoại',
                    onChanged: profileController.validatePhonenumber,
                    textInputType: TextInputType.number,
                  ),
                  SizedBox(
                    height: mediaHeight(context, 40),
                  ),
                  Obx(
                    () => DefaultButton(
                      enabled: profileController.isValidFullname.value &&
                          profileController.isValidPhonenumber.value,
                      text: 'Cập nhật',
                      press: () async {
                        String result = await profileController.updateAccount();
                        print(result);
                        if (result == "Success") {
                          return CustomSnackBar.showCustomSnackBar(
                              context, 'Cập nhật thành công!', 2);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
