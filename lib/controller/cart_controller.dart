import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:keyboard_mobile_app/api/cart_api.dart';
import 'package:keyboard_mobile_app/api/product_api.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import 'package:keyboard_mobile_app/utils/data_convert.dart';
import 'package:keyboard_mobile_app/utils/show_animations.dart';
import 'package:logger/logger.dart';

import '../api/account_api.dart';
import '../model/cart_model.dart';
import '../model/product_details_model.dart';
import '../model/product_model.dart';

class CartController extends GetxController {
  final acccountApi = Get.find<AccountApi>();
  final productApi = Get.find<ProductApi>();
  RxList<CartModel> listCartItem = <CartModel>[].obs;
  RxList<CartModel> checkedItems = <CartModel>[].obs;

  final listImageUrl = <String>[].obs;

  // bool isCheckAll = false;
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
    // isCheckAll = false;
    checkedItems.value = [];
  }

  void closeBottomSheet() {
    listImageUrl.value = [];
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

  Future getCartByAccountId() async {
    final currentAccount = await awaitCurrentAccount();
    ResponseBaseModel respone =
        await cartApi.getCartByAccountId("${currentAccount?.accountId}");
    if (respone.data != null) {
      final cartReceived = respone.data as List<dynamic>;
      List<CartModel> cartList = cartReceived
          .map(
            (cartMap) => CartModel.fromJson(cartMap),
          )
          .toList();
      listCartItem.value = cartList;

      // isNoProduct.value = false;
    }
  }

  Future<ProductModel?> getProductById(String productId) async {
    final respone = await productApi.getById(productId);
    if (respone.data != null) {
      final productModel = ProductModel.fromJson(respone.data);
      return productModel;
    }
    return null;
  }

  Future<ProductDetailModel?> getProductByDetail(String productDetailId) async {
    final respone = await productApi.getProductDetailsById(productDetailId);
    if (respone.data != null) {
      final productDetailModel = ProductDetailModel.fromJson(respone.data);
      listImageUrl.value =
          DataConvert().encodeListImages("${productDetailModel.imageUrl}");
      return productDetailModel;
    }
    return null;
  }

  void checkAll(bool isCheck) {
    if (isCheck) {
      checkedItems.assignAll(listCartItem);
      calculateCartTotal();
    } else {
      checkedItems.clear();
      calculateCartTotal();
    }
  }

  void checkPerItem(bool isCheck, CartModel item) {
    if (isCheck) {
      checkedItems.add(item);

      calculateCartTotal();
    } else {
      checkedItems.remove(item);
      calculateCartTotal();
    }
  }

  // //Phương thức kiểm tra đối tượng item trong List checkedItem
  // //Nếu kết quả trả về -1 -> đối tượng tồn tại, ngược lại thì đối tượng không tồn tại

  // int queryChekedItemList(CartModel item) {
  //   return checkedItems.indexWhere((element) =>
  //       element.accountId == item.accountId &&
  //       element.productDetailId == item.productDetailId &&
  //       element.quantity == item.quantity);
  // }

  Future<String> addToCart(CartModel cartItem) async {
    //Kiểm tra đối tượng Cartitem giống phương thức bên dưới
    if (acccountApi.accountRespone.value != null) {
      final respone = await cartApi.addToCart(cartItem);
      if (respone.message.toString().contains("Success")) {
        return "Success";
      } else if (respone.message.toString().contains("Update")) {
        return "Update";
      } else {
        return "Fail";
      }
    }
    return "NoUser";
  }

  Future<String> updateCart(CartModel cartItem) async {
    //Kiểm tra đối tượng Cartitem giống phương thức bên dưới
    if (acccountApi.accountRespone.value != null) {
      final respone = await cartApi.updateCart(cartItem);
      if (respone.message.toString().contains("Success")) {
        return "Success";
      } else {
        return "Fail";
      }
    }
    return "NoUser";
  }

  Future<String> clearCart(String accountId) async {
    //Kiểm tra đối tượng Cartitem giống phương thức bên dưới
    if (acccountApi.accountRespone.value != null) {
      final respone = await cartApi.clearCart(accountId);
      if (respone.message.toString().contains("Success")) {
        return "Success";
      } else {
        return "Fail";
      }
    }
    return "NoUser";
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
    } else {
      totalPrice.value = 0;
    }
  }

  Future<double> calculateItemTotal(CartModel item) async {
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
        calculateCartTotal();
      }
      calculateCartTotal();
      return "Success";
    }
    return "Fail";
  }

  Future<String> deleteManyItem() async {
    final currentAccount = await awaitCurrentAccount();
    if (currentAccount != null) {
      final respone =
          await cartApi.deleteManyItem(currentAccount.accountId, checkedItems);
      if (respone.message!.contains('Success')) {
        for (final item in checkedItems) {
          listCartItem.remove(item);
        }
        checkedItems.clear();
        return "Success";
      }
      return "Xoá thất bại\nCó lỗi xảy ra!";
    }
    return "Phiên đăng nhập không hợp lệ!";
  }
}
