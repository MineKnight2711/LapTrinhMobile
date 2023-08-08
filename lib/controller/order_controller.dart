import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/order_api.dart';
import 'package:keyboard_mobile_app/model/order_model.dart';

import '../model/cart_model.dart';

class OrderController extends GetxController {
  late OrderApi orderApi;
  @override
  void onInit() {
    super.onInit();
    orderApi = Get.put(OrderApi());
  }

  Future<String> saveOrder(
      OrderModel newOrder, List<CartModel> chosenItems) async {
    final respone = await orderApi.saveOrder(newOrder, chosenItems);
    if (respone.message == "Success") {
      return "Success";
    }
    return respone.message.toString();
  }
}
