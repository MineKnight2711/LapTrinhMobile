// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/image_view.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';
import '../../controller/change_password_controller.dart';
import '../../widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/custom_input.dart';

class ChangePasswordScreen extends StatelessWidget {
  final String email;
  ChangePasswordScreen({super.key, required this.email});
  final changePassController = Get.find<ChangePasswordController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          changePassController.onClose();
          Navigator.pop(context);
        },
        title: changePassController.checkUserAuthencation()
            ? 'Tạo mật khẩu mới'
            : 'Đổi mật khẩu',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomImageView(
                  imageAssetUrl: 'assets/images/security.png', imageSize: 5),
              SizedBox(height: mediaHeight(context, 20)),
              // CustomInputTextField(
              //   controller: changePassController.emailController,
              //   hintText: 'Nhập email...',
              //   labelText: 'Email',
              //   onChanged: changePassController.validateEmail,
              // ),
              Row(
                children: [
                  Text('Email :'),
                  SizedBox(
                    width: mediaWidth(context, 16),
                  ),
                  EmailViewText(email),
                ],
              ),
              Visibility(
                visible: !changePassController.checkUserAuthencation(),
                child: Column(
                  children: [
                    SizedBox(height: mediaHeight(context, 40)),
                    CustomPasswordTextfield(
                      controller: changePassController.oldPassController,
                      hintText: 'Nhập mật khẩu cũ...',
                      labelText: 'Mật khẩu cũ',
                      onChanged: changePassController.validateOldPassword,
                    ),
                    SizedBox(height: mediaHeight(context, 40)),
                    CustomPasswordTextfield(
                      controller: changePassController.newpassController,
                      hintText: 'Nhập mật khẩu mới...',
                      labelText: 'Cập nhập mật khẩu',
                      onChanged: changePassController.validatePassword,
                    ),
                    SizedBox(height: mediaHeight(context, 40)),
                    CustomPasswordTextfield(
                      controller: changePassController.reenterpassController,
                      hintText: 'Xác nhận mật khẩu...',
                      labelText: 'Nhập lại mật khẩu',
                      onChanged: changePassController.validateReenterPassword,
                    ),
                    SizedBox(height: mediaHeight(context, 20)),
                    Obx(
                      () => DefaultButton(
                        enabled: changePassController.isValidPassword.value &&
                            changePassController.isValidReenter.value &&
                            changePassController.isValidOldPassword.value,
                        press: () async {
                          String result =
                              await changePassController.changePassword(
                                  email,
                                  changePassController.oldPassController.text,
                                  changePassController.newpassController.text);
                          if (result == 'Success') {
                            CustomSnackBar.showCustomSnackBar(
                                context, 'Đổi mật khẩu thành công!', 2);
                            changePassController.onClose();
                            Navigator.pop(context);
                          } else {
                            CustomSnackBar.showCustomSnackBar(
                                context, result, 2,
                                backgroundColor: Colors.red);
                          }
                        },
                        text: 'Đổi mật khẩu',
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: changePassController.checkUserAuthencation(),
                  child: Column(
                    children: [
                      SizedBox(height: mediaHeight(context, 40)),
                      CustomPasswordTextfield(
                        controller: changePassController.newpassController,
                        hintText: 'Nhập mật khẩu mới...',
                        labelText: 'Mật khẩu mới',
                        onChanged: changePassController.validatePassword,
                      ),
                      SizedBox(height: mediaHeight(context, 40)),
                      CustomPasswordTextfield(
                        controller: changePassController.reenterpassController,
                        hintText: 'Xác nhận mật khẩu...',
                        labelText: 'Nhập lại mật khẩu',
                        onChanged: changePassController.validateReenterPassword,
                      ),
                      SizedBox(height: mediaHeight(context, 20)),
                      Obx(
                        () => DefaultButton(
                          enabled: changePassController.isValidPassword.value &&
                              changePassController.isValidReenter.value,
                          press: () async {
                            String? result =
                                await changePassController.createPassword(
                                    email,
                                    changePassController
                                        .newpassController.text);
                            if (result == 'Success') {
                              CustomSnackBar.showCustomSnackBar(
                                  context, 'Tạo mật khẩu mới thành công!', 2);
                              changePassController.onClose();
                              Navigator.pop(context);
                            } else {
                              CustomSnackBar.showCustomSnackBar(
                                  context, result ?? 'Unknown', 2,
                                  backgroundColor: Colors.red);
                            }
                          },
                          text: 'Tạo mật khẩu mới',
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailViewText extends StatelessWidget {
  final String email;

  const EmailViewText(this.email, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Text(
        email,
        style: TextStyle(
          color: Colors.black, // You can set your preferred text color here
          fontSize: 16.0,
        ),
      ),
    );
  }
}
