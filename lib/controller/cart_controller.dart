import 'package:get/get.dart';

import 'package:keyboard_mobile_app/api/cart_api.dart';
import 'package:keyboard_mobile_app/api/product_api.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import 'package:logger/logger.dart';

import '../api/account_api.dart';
import '../model/cart_model.dart';
import '../model/product_details_model.dart';

class CartController extends GetxController {
  final acccountApi = Get.find<AccountApi>();
  final productApi = Get.find<ProductApi>();
  List<CartModel> listCartItem = <CartModel>[].obs;
  List<CartModel> checkedItems = <CartModel>[].obs;

  late CartApi cartApi;
  final totalPrice = 0.0.obs;
  // final isCheckAll = false.obs;
  @override
  void onInit() {
    super.onInit();
    cartApi = Get.put(CartApi());
    awaitCurrentAccount();
  }

  @override
  void onClose() {
    super.onClose();
    totalPrice.value = 0.0;
    // isCheckAll.value = false;
    listCartItem = checkedItems = [];
  }

  //Chờ thông tin người dùng hiện tại
  Future awaitCurrentAccount() async {
    await acccountApi.fetchCurrent().then((currentAccount) {
      if (currentAccount != null) {
        getCartByAccountId(currentAccount.accountId);
      }
    });
  }

  Future getCartByAccountId(String? accountId) async {
    ResponseBaseModel respone = await cartApi.getCartByAccountId(accountId);
    if (respone.data != null) {
      final cartReceived = respone.data as List<dynamic>;

      List<CartModel> cartList = cartReceived
          .map(
            (cartMap) => CartModel.fromJson(cartMap),
          )
          .toList();
      listCartItem = cartList;
      Logger().i("${listCartItem.length} test cart");
      // isNoProduct.value = false;
    }
  }

  //Phương thức tick chọn từng item trong giỏ hàng
  // void checkPerItem(CartModel item) {
  //   print(queryChekedItemList(item));
  //   if (queryChekedItemList(item) != -1) {
  //     checkedItems.remove(item);
  //   } else {
  //     checkedItems.add(item);
  //     // updateTotalPrice();
  //   }
  //   print(checkedItems.length);
  // }

  // int queryChekedItemList(CartModel item) {
  //   return checkedItems.indexWhere(
  //     (element) =>
  //         element.productDetailId == item.productDetailId &&
  //         element.accountId == item.accountId &&
  //         element.quantity == item.quantity,
  //   );
  // }

  void addToCart(CartModel item) {
    //Kiểm tra đối tượng Cartitem giống phương thức bên dưới
  }
  void calculateCartTotal() async {
    double total = 0.0;
    if (checkedItems.isNotEmpty) {
      // Create a temporary list to avoid modifying checkedItems during iteration
      List<CartModel> tempCheckedItems = List.from(checkedItems);

      for (var item in tempCheckedItems) {
        total += await calculateItemTotal(item);
      }
      totalPrice.value = total;
    }
  }

  Future<double> calculateItemTotal(CartModel item) async {
    // Retrieve the product details from the listCartItem
    final respone =
        await productApi.getProductDetailsById(item.productDetailId);
    if (respone.data != null) {
      final productDetailFromCartItem =
          ProductDetailModel.fromJson(respone.data);
      return double.parse(item.quantity.toString()) *
          double.parse(productDetailFromCartItem.price.toString());
    }
    return 0.0;
  }

  Future<String> removeItem(CartModel item) async {
    //Delete in database
    ResponseBaseModel respone = await cartApi.deleteFromCart(
        acccountApi.accountRespone.value?.accountId, item.productDetailId);

    if (respone.message == "Success") {
      //Xoá trong listCartItem trước
      listCartItem.remove(item);
      //Check nếu item đó đã được chọn
      final index = checkedItems.indexOf(item);
      if (index != -1) {
        // Xoá item trong danh sách chọn
        checkedItems.removeAt(index);
        // Tính toán lại tổng giỏ hàng (nếu có item được chọn)
        // calculateCartTotal();
      }
      return "Success";
    }
    return "Fail";
  }
}
