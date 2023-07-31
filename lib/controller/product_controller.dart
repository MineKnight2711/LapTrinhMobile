import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/product_controller.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import '../model/respone_base_model.dart';

class ProductController extends GetxController {
  late ProductApi productApi;
  Rx<List<ProductModel>?> listProduct = Rx<List<ProductModel>?>([]);
  var isNoProduct = true.obs;
  @override
  void onInit() {
    super.onInit();
    productApi = Get.put(ProductApi());
  }

  Future getProductByCategory(String? categoryId) async {
    ResponseBaseModel respone =
        await productApi.getProductByCategory(categoryId);

    if (respone.data != null &&
        respone.data.toString().isNotEmpty &&
        respone.data.toString() != 'null') {
      final productReceived = respone.data as List<dynamic>;

      List<ProductModel> productsList = productReceived
          .map(
            (productMap) => ProductModel.fromJson(productMap),
          )
          .toList();
      listProduct.value = productsList;
      isNoProduct.value = false;
    } else {
      isNoProduct.value = true;
    }
  }
}
