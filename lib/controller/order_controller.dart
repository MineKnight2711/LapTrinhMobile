import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/order_api.dart';
import 'package:keyboard_mobile_app/model/order_model.dart';
import 'package:logger/logger.dart';

import '../api/account_api.dart';
import '../model/account_respone.dart';
import '../model/cart_model.dart';
import '../model/query_order_model.dart';

class OrderController extends GetxController {
  late OrderApi orderApi;
  final acccountApi = Get.find<AccountApi>();

  @override
  void onInit() {
    super.onInit();
    orderApi = Get.put(OrderApi());
    getAllOrder();
  }

  //Chờ thông tin người dùng hiện tại
  Future<AccountResponse?> awaitCurrentAccount() async {
    return await acccountApi.fetchCurrent().then((currentAccount) {
      if (currentAccount != null) {
        return currentAccount;
      }
      return null;
    });
  }

  Future<String> getAllOrder() async {
    final currentAccount = await awaitCurrentAccount();
    if (currentAccount != null) {
      final respone =
          await orderApi.getAndFetchAllOrder("${currentAccount.accountId}");
      // Logger().i("${respone.data}  logggggggggggggg orderrrrrrrrrrrrrr");
      if (respone.message!.contains("Success")) {
        final queryOrderReceived = respone.data as List<dynamic>;

        List<QueryOrder> queryOrderList = queryOrderReceived
            .map(
              (orderMap) => QueryOrder.fromJson(orderMap),
            )
            .toList();
        Logger().i(
            "${queryOrderList.length}  orrrrrrrrderrrrrrr lenghttttttttttttt");
        return "Success";
      }
      return respone.message.toString();
    }
    return "NoUser";
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
