import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';

import '../../api/account_api.dart';
import '../../configs/mediaquery.dart';
import '../../controller/order_controller.dart';
import '../../controller/register_controller.dart';
import '../../transition_animation/screen_transition.dart';
import '../../widgets/custom_widgets/custom_appbar.dart';
import '../../widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/custom_input.dart';
import '../../widgets/custom_widgets/datetime_picker.dart';
import '../../widgets/custom_widgets/gender_chose.dart';
import '../../widgets/custom_widgets/message.dart';

class SignUpGoogleCompletedScreen extends StatelessWidget {
  SignUpGoogleCompletedScreen({super.key});
  final controller = Get.find<AccountApi>();
  final registerController = Get.find<RegisterController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            registerController.onClose();
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
                GenderSelectionWidget(
                  size: 1.7,
                  onChanged: (value) {
                    registerController.selectedGender = value;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputTextField(
                    onChanged: registerController.validatePhonenumber,
                    controller: registerController.phonenumberController,
                    textInputType: TextInputType.number,
                    labelText: 'Nhập số điện thoại',
                    hintText: 'Số điện thoại'),
                const SizedBox(
                  height: 30,
                ),
                DefaultButton(
                  enabled: registerController.isValidPhonenumber.value,
                  text: 'Đăng ký',
                  press: () async {
                    // showLoadingAnimation(context);
                    String? result =
                        await registerController.signUpwithGoogle();
                    if (result == "Success") {
                      CustomSuccessMessage.showMessage("Đăng ký thành công!")
                          .whenComplete(
                              () => controller.fetchCurrent().whenComplete(() {
                                    Get.put(OrderController());
                                  }));
                      // ignore: use_build_context_synchronously
                      replaceFadeInTransition(context, HomeScreen());
                      registerController.onClose();
                    } else {
                      CustomErrorMessage.showMessage(
                          'Có lỗi xảy ra vui lòng thử lại');
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
