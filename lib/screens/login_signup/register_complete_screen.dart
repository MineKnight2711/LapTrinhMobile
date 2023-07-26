// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/screens/login_signup/login_screen.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';
import '../../api/account_api.dart';
import '../../configs/mediaquery.dart';
import '../../controller/register_controller.dart';
import '../../widgets/custom_widgets/custom_appbar.dart';
import '../../widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/custom_input.dart';
import '../../widgets/custom_widgets/datetime_picker.dart';
import '../../widgets/custom_widgets/gender_chose.dart';

class RegisterCompleteScreen extends StatelessWidget {
  RegisterCompleteScreen({super.key});
  final controller = Get.find<AccountApi>();
  final registerController = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          title: 'Hoàn tất đăng ký'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: mediaWidth(context, 1),
          height: mediaHeight(context, 1),
          child: Obx(
            () => Form(
              child: Column(children: [
                CircleAvatar(
                  radius: mediaAspectRatio(context, 1 / 200),
                  backgroundImage:
                      Image.asset('assets/images/profile.png').image,
                ),
                BirthdayDatePickerWidget(
                  initialDate: DateTime.now(),
                  onChanged: (value) {
                    registerController.date = value;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputTextField(
                    onChanged: registerController.validatePhonenumber,
                    controller: registerController.phonenumberController,
                    labelText: 'Nhập số điện thoại',
                    hintText: 'Số điện thoại'),
                GenderSelectionWidget(
                  size: 1.7,
                  onChanged: (value) {
                    registerController.selectedGender = value;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                DefaultButton(
                  enabled: registerController.isValidPhonenumber.value,
                  text: 'Đăng ký',
                  press: () async {
                    // showLoadingAnimation(context);
                    String? result = await registerController.signUp();
                    if (result == "Success") {
                      CustomSuccessMessage.showMessage("Đăng ký thành công!");
                      slideInTransitionReplacement(context, LoginScreen());
                      registerController.onClose();
                    } else {
                      CustomErrorMessage.showMessage(
                          result ?? 'Không thể đăng ký');
                      return;
                    }
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
