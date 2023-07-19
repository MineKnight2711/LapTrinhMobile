import 'package:flutter/material.dart';

void slideInTransition(BuildContext context, Widget nextScreen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
              Tween<Offset>(begin: const Offset(2, 0.0), end: Offset.zero)),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
    ),
  );
}
