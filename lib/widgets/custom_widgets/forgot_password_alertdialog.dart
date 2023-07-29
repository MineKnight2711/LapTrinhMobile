// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/login_controller.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_input.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

class AlertDialogShape extends RoundedRectangleBorder {
  AlertDialogShape({
    double radius = 16,
  }) : super(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        );
}

class PasswordRecoveryDialog extends StatelessWidget {
  PasswordRecoveryDialog({super.key});
  final loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: AlertDialogShape(),
      title: Center(
          child: Text(
        'Khôi phục mật khẩu',
        style: GoogleFonts.nunito(fontSize: 20),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomInputTextField(
            onChanged: loginController.validateEmail,
            controller: loginController.emailController,
            labelText: 'Email khôi phục',
            hintText: 'Nhập email...',
          )
        ],
      ),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Huỷ',
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.red),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: mediaWidth(context, 3),
              height: mediaHeight(context, 17),
              child: DefaultButton(
                text: 'Gửi',
                press: () async {
                  ResponseBaseModel result = await loginController
                      .forgotPassword(loginController.emailController.text);

                  showResetLinkSentDialog(
                      context, result.message ?? 'Có lỗi xảy ra');
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
