import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/api/address_api.dart';
import 'package:keyboard_mobile_app/controller/address_controller.dart';
import 'package:keyboard_mobile_app/controller/cart_controller.dart';
import 'package:keyboard_mobile_app/controller/category_controller.dart';
import 'package:keyboard_mobile_app/controller/login_controller.dart';
import 'package:keyboard_mobile_app/controller/order_controller.dart';
import 'package:keyboard_mobile_app/controller/product_controller.dart';
import 'package:keyboard_mobile_app/controller/register_controller.dart';
import 'package:keyboard_mobile_app/controller/update_profile_controller.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';
import 'package:keyboard_mobile_app/utils/save_image.dart';

import '../api/cart_api.dart';
import '../api/order_api.dart';

class MainController {
  static initializeControllers() {
    Get.put(AccountApi());
    Get.put(HomeScreenController());
    Get.put(CategoryController());
    Get.put(ProductController());
    Get.put(CartController());
    Get.put(OrderController());
    Get.put(RegisterController());
    Get.put(LoginController());
  }

  static destroyControllers() {
    Get.delete<OrderController>();
    Get.delete<OrderApi>();
    Get.delete<ChangeImageController>();
    Get.delete<UpdateProfileController>();
    Get.delete<AddressController>();
    Get.delete<AddressApi>();
    Get.delete<CartApi>();
    Get.delete<CartController>();
  }
}
