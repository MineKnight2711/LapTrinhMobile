import 'package:get/get.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';

import '../api/category_api.dart';
import '../model/category_model.dart';

class CategoryController extends GetxController {
  late CategoryApi categoryApi;
  Rx<List<CategoryModel>?> listCategory = Rx<List<CategoryModel>?>([]);
  @override
  void onInit() {
    super.onInit();
    categoryApi = Get.put(CategoryApi());
    getAllCategory();
  }

  Future getAllCategory() async {
    ResponseBaseModel respone = await categoryApi.getAllCategory();
    final categoryReceived = respone.data as List<dynamic>;

    List<CategoryModel> categoriesList = categoryReceived
        .map(
          (categoryMap) => CategoryModel.fromJson(categoryMap),
        )
        .toList();
    listCategory.value = categoriesList;
  }
}
