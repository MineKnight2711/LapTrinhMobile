import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/product_api.dart';
import 'package:keyboard_mobile_app/model/product_details_model.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import '../model/respone_base_model.dart';
import '../utils/data_convert.dart';

class ProductController extends GetxController {
  late ProductApi productApi;
  Rx<List<ProductModel>?> listProduct = Rx<List<ProductModel>?>([]);
  Rx<List<ProductDetailModel>?> listProductDetails =
      Rx<List<ProductDetailModel>?>([]);
  Rx<List<String>> listImageUrl = Rx<List<String>>([]);
  var isNoProduct = true.obs;

  final showMore = false.obs;

  var selected = 0.obs;

  @override
  void onInit() {
    super.onInit();
    productApi = Get.put(ProductApi());
  }

  var _listAllProduct = <ProductModel>[].obs;

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

  Future getProductDetails(String? productId) async {
    ResponseBaseModel respone = await productApi.getProductDetails(productId);

    if (respone.data != null &&
        respone.data.toString().isNotEmpty &&
        respone.data.toString() != 'null') {
      final productDetailsReceived = respone.data as List<dynamic>;

      List<ProductDetailModel> productDetailsList = productDetailsReceived
          .map(
            (productDetailsMap) =>
                ProductDetailModel.fromJson(productDetailsMap),
          )
          .toList();
      listProductDetails.value = productDetailsList;
      List<String> urlList = [];
      for (ProductDetailModel detail in productDetailsList) {
        List<String> individualUrlList =
            DataConvert().encodeListImages("${detail.imageUrl}");
        urlList.addAll(individualUrlList);
      }
      listImageUrl.value = urlList;
      isNoProduct.value = false;
    } else {
      isNoProduct.value = true;
    }
  }

  // Future loadListsProduct() async {
  //   final res = await ProductService.instance.getAllProduct();
  //   _listAllProduct.value = res!.data!;
  //   Logger().i("getX total Load product: ${_listAllProduct.value.length}");
  //   return;
  // }
}
