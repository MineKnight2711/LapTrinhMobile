// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/order_api.dart';
import 'package:keyboard_mobile_app/model/order_model.dart';

import '../api/account_api.dart';
import '../model/account_respone.dart';
import '../model/cart_model.dart';
import '../model/query_order_model.dart';

enum SortByPrice { highToLow, lowToHigh }

enum SortByOrderStatus {
  order_status_unconfirmed,
  order_status_ondeliver,
  order_status_delivered,
  order_status_canceled
}

class OrderController extends GetxController {
  late OrderApi orderApi;
  final acccountApi = Get.find<AccountApi>();

  @override
  void onInit() {
    super.onInit();
    orderApi = Get.put(OrderApi());
    getAllOrder();
  }

  final sortByPriceController = Rx<SortByPrice?>(null);
  final sortByOrderStatusController = Rx<SortByOrderStatus?>(null);

  //Chờ thông tin người dùng hiện tại
  Future<AccountResponse?> awaitCurrentAccount() async {
    return await acccountApi.fetchCurrent().then((currentAccount) {
      if (currentAccount != null) {
        return currentAccount;
      }
      return null;
    });
  }

  final listQueryOrder = <QueryOrder>[].obs;
  final storedListQueryOrder = <QueryOrder>[].obs;
  Future<String> getAllOrder() async {
    final currentAccount = await awaitCurrentAccount();
    if (currentAccount != null) {
      final respone =
          await orderApi.getAndFetchAllOrder("${currentAccount.accountId}");
      // Logger().i("${respone.data}  logggggggggggggg orderrrrrrrrrrrrrr");
      if (respone.message!.contains("Success")) {
        final queryOrderReceived = respone.data as List<dynamic>;

        listQueryOrder.value = storedListQueryOrder.value = queryOrderReceived
            .map(
              (orderMap) => QueryOrder.fromJson(orderMap),
            )
            .toList();
        listQueryOrder.sort((a, b) => b.orderDate.compareTo(a.orderDate));
        return "Success";
      }
      return respone.message.toString();
    }
    return "NoUser";
  }

  // ignore: annotate_overrides
  Future<void> refresh() async {
    await getAllOrder();
  }

  Future<String> saveOrder(
      OrderModel newOrder, List<CartModel> chosenItems) async {
    final respone = await orderApi.saveOrder(newOrder, chosenItems);
    if (respone.message == "Success") {
      return "Success";
    }
    return respone.message.toString();
  }

  RxDouble caculateTotal(QueryOrder order) {
    double itemTotal = order.listOrderDetail.fold(0.0,
        (double total, QueryOrderDetail orderDetail) {
      double itemTotal = orderDetail.productDetail.price * orderDetail.quantity;
      return total + itemTotal;
    });
    order.total = itemTotal;
    return RxDouble(itemTotal);
  }

  void sortListOrder() {
    //Sắp xếp theo tổng tiền của đơn
    if (sortByPriceController.value != null) {
      switch (sortByPriceController.value) {
        case SortByPrice.highToLow:
          listQueryOrder.sort((a, b) => b.total.compareTo(a.total));
          break;
        case SortByPrice.lowToHigh:
          listQueryOrder.sort((a, b) => a.total.compareTo(b.total));
          break;
        case null:
          break;
      }
    }
    //Lọc theo tình trạng đơn
    else if (sortByOrderStatusController.value != null) {
      switch (sortByOrderStatusController.value) {
        case SortByOrderStatus.order_status_unconfirmed:
          listQueryOrder.value = List.from(storedListQueryOrder);
          listQueryOrder.removeWhere((order) => order.status != 'Chờ xác nhận');
          break;
        case SortByOrderStatus.order_status_ondeliver:
          listQueryOrder.value = List.from(storedListQueryOrder);
          listQueryOrder.removeWhere((order) => order.status != 'Đang giao');
          break;
        case SortByOrderStatus.order_status_delivered:
          listQueryOrder.value = List.from(storedListQueryOrder);
          listQueryOrder.removeWhere((order) => order.status != 'Đã giao');
          break;
        case SortByOrderStatus.order_status_canceled:
          listQueryOrder.value = List.from(storedListQueryOrder);
          listQueryOrder.removeWhere((order) => order.status != 'Đã huỷ');
          break;
        case null:
          break;
      }
    }
  }

  Future<String> updateStatus(String orderId, String status) async {
    final respone = await orderApi.updateOrderStatus(orderId, status);
    if (respone.message == "Success") {
      return "Success";
    }
    return respone.message.toString();
  }
}
