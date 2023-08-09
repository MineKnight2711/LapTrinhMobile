import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_mobile_app/controller/main_controller.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';
import 'package:keyboard_mobile_app/screens/login_signup/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MainController.initializeControllers();
  await initializeDateFormatting('vi_VN', null);
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
