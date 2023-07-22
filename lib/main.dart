import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';
import 'package:keyboard_mobile_app/screens/login_signup/login_screen.dart';
import 'api/account_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AccountApi());
  // print(ip);
  runApp(
    MaterialApp(
      initialRoute: 'home_screen',
      debugShowCheckedModeBanner: false,
      routes: {
        'login_screen': (context) => LoginScreen(),
        'home_screen': (context) => HomeScreen(),
      },
    ),
  );
}
