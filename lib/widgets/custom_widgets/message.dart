import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomErrorMessage {
  static void showMessage(String message) {
    Fluttertoast.showToast(
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
  static void showMessage(String message) {
    Fluttertoast.showToast(
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

void showResetLinkSentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reset Password Link Sent'),
      content: const Text(''),
      actions: [
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
