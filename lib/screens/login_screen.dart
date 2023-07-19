import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/controller/login_controller.dart';
import 'package:keyboard_mobile_app/screens/register_screen.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/centered_text_with_linebar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final loginController = Get.put(LoginController());
  final accountApi = Get.put(AccountApi());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              SizedBox(
                height: size.height / 20,
              ),
              Text(
                'Đăng nhập',
                style: GoogleFonts.nunito(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
                height: size.height / 25,
              ),
              CustomInputTextField(
                controller: loginController.usernameController,
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu...',
              ),
              SizedBox(
                height: size.height / 25,
              ),
              StyledGradienButton(onPressed: () {}, buttonText: 'Đăng nhập'),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const CenteredTextWithLineBars(
                  text: 'hoặc',
                  textFlex: 1,
                ),
              ),
              LoginWithGoogleButton(
                  onPressed: () {},
                  buttonText: 'Tiếp tục với Google',
                  buttonIconAssets: 'assets/icons/google.png'),
              SizedBox(
                height: size.height / 25,
              ),
              RichText(
                text: TextSpan(
                  text: 'bạn chưa có tài khoản? ',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'Đăng ký',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          slideInTransition(context, RegisterScreen());
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
