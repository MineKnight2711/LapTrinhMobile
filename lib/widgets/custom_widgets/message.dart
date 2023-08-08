// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/login_controller.dart';

class CustomErrorMessage {
  static Future<void> showMessage(String message) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class CustomSuccessMessage {
  static Future<void> showMessage(String message) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 0, 255, 55),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class CustomSnackBar {
  static void showCustomSnackBar(
      BuildContext context, String message, int duration,
      {Color backgroundColor = Colors.blue}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        duration: Duration(seconds: duration),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String content;
  final String? title;
  final Function()? onPressed;

  const CustomAlertDialog(
      {super.key, required this.content, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dialogBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[800],
          ),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      child: AlertDialog(
        title: Text(title ?? ''),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

void showResetLinkSentDialog(BuildContext context, String link) {
  final loginController = Get.find<LoginController>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reset Password Link Sent'),
      content: InkWell(
        onTap: () {
          launchURLLink(link);
          Navigator.pop(context);
          Navigator.pop(context);
          loginController.onClose();
        },
        child: const Text.rich(
          TextSpan(
            text: "Nhấn vào đây để đổi mật khẩu",
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Future launchURLLink(String link) async {
  Uri url = Uri.parse(link);
  if (await launchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
