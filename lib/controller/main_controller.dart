import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/controller/cart_controller.dart';
import 'package:keyboard_mobile_app/controller/category_controller.dart';
import 'package:keyboard_mobile_app/controller/login_controller.dart';
import 'package:keyboard_mobile_app/controller/product_controller.dart';
import 'package:keyboard_mobile_app/controller/register_controller.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';

class MainController {
  static initializeControllers() {
    Get.put(HomeScreenController());
    Get.put(AccountApi());
    Get.put(CategoryController());
    Get.put(ProductController());
    Get.put(CartController());
    Get.put(RegisterController());
    Get.put(LoginController());
  }
}
