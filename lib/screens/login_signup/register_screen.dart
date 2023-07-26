import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/register_controller.dart';
import 'package:keyboard_mobile_app/screens/login_signup/register_complete_screen.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/custom_input.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final registerController = Get.find<RegisterController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
            registerController.onClose();
          },
          title: 'Đăng ký'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          height: size.height,
          child: Column(children: [
            SizedBox(
              height: size.height / 25,
            ),
            CircleAvatar(
              radius: size.aspectRatio * 200,
              backgroundImage: Image.asset('assets/images/profile.png').image,
            ),
            SizedBox(height: size.height / 20),
            CustomInputTextField(
              onChanged: registerController.validateFullname,
              controller: registerController.fullnameController,
              labelText: 'Họ tên',
              hintText: 'Nhập họ và tên...',
            ),
            SizedBox(height: size.height / 25),
            CustomInputTextField(
              onChanged: registerController.validateEmail,
              controller: registerController.emailController,
              labelText: 'Email',
              hintText: 'Nhập email...',
            ),
            SizedBox(height: size.height / 20),
            CustomPasswordTextfield(
              onChanged: registerController.validatePassword,
              controller: registerController.passwordController,
              labelText: 'Mật khẩu',
              hintText: 'Nhập mật khẩu...',
            ),
            SizedBox(height: size.height / 25),
            CustomPasswordTextfield(
              onChanged: registerController.validateReenterPassword,
              controller: registerController.confirmPasswordController,
              labelText: 'Xác nhận mật khẩu',
              hintText: 'Nhập lại mật khẩu...',
            ),
            SizedBox(height: size.height / 25),
            Obx(
              () => DefaultButton(
                enabled: registerController.isValidFullname.value &&
                    registerController.isValidEmail.value &&
                    registerController.isValidPassword.value &&
                    registerController.isValidReenter.value,
                text: 'Tiếp tục',
                press: () {
                  slideInTransitionReplacement(
                      context, RegisterCompleteScreen());
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
