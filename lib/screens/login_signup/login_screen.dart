// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/controller/login_controller.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';
import 'package:keyboard_mobile_app/screens/login_signup/register_screen.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/centered_text_with_linebar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_input.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

import '../../api/fingerprint_api/local_auth_api.dart';
import '../../widgets/custom_widgets/forgot_password_alertdialog.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        title: 'Đăng nhập',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              SizedBox(
                height: size.height / 25,
              ),
              Container(
                width: size.height / 2.7,
                height: size.height / 6.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/images/login.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: size.height / 20),
              CustomInputTextField(
                controller: loginController.usernameController,
                labelText: 'Tên đăng nhập',
                hintText: 'Nhập tên đăng nhập...',
              ),
              SizedBox(
                height: size.height / 60,
              ),
              CustomPasswordTextfield(
                controller: loginController.passwordController,
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu...',
              ),
              SizedBox(
                height: size.height / 40,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width / 1.45,
                    child: StyledGradienButton(
                        onPressed: () {}, buttonText: 'Đăng nhập'),
                  ),
                  const Spacer(),
                  CircleIconButton(
                    icon: Icons.fingerprint,
                    onPressed: () async {
                      if (loginController.enableFingerprint.value) {
                        final isAuthenticated =
                            await LocalAuthApi.authenticate();
                        if (isAuthenticated) {
                          final result = await loginController
                              .authenticatedWithFingerPrint();
                          switch (result) {
                            case 'Success':
                              CustomSuccessMessage.showMessage(
                                  'Xác thực thành công!');
                              fadeInTransitionReplacement(
                                  context, HomeScreen());
                              break;
                            case 'NotFound':
                              CustomErrorMessage.showMessage(
                                  'Không tìm thấy tài khoản!');
                              break;
                            default:
                              break;
                          }
                        }
                      } else {
                        CustomErrorMessage.showMessage(
                            'Vui lòng đăng nhập để bật tính năng này!');
                        return;
                      }
                    },
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const CenteredTextWithLineBars(
                  text: 'hoặc',
                  textFlex: 1,
                ),
              ),
              LoginWithSocialButton(
                  onPressed: () async {
                    final result = await loginController.signInWithGoogle();
                    if (result == 'SigninSuccess') {
                      CustomSuccessMessage.showMessage('Đăng ký thành công!');
                      slideInTransition(context, HomeScreen());
                    } else if (result == 'LoginSuccess') {
                      CustomSuccessMessage.showMessage('Đăng nhập thành công!');
                      slideInTransition(context, HomeScreen());
                    } else if (result == 'CancelSignIn') {
                      CustomSuccessMessage.showMessage('Đã huỷ đăng nhập!');
                    } else {
                      CustomErrorMessage.showMessage('Đăng nhập thất bại!');
                    }
                  },
                  buttonText: 'Tiếp tục với Google',
                  buttonIconAssets: 'assets/icons/google.png'),
              SizedBox(
                height: size.height / 25,
              ),
              RichText(
                text: TextSpan(
                  text: 'Bạn chưa có tài khoản? ',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'Đăng ký',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          slideInTransition(context, RegisterScreen());
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PasswordRecoveryDialog();
                        },
                      );
                    },
                    child: Text(
                      'Quên mật khẩu',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
