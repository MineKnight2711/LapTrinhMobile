import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future showLoadingAnimation(BuildContext context, String animationPath,
    double widthHeightLong, int duration) {
  showDialog(
    context: context,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Lottie.asset(animationPath,
              width: widthHeightLong, height: widthHeightLong),
        ),
      );
    },
  );

  Future.delayed(Duration(seconds: duration), () {
    Navigator.of(context).pop();
  });

  return Future.delayed(Duration(seconds: duration));
}
