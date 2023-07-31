import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import '../base_url_api.dart';
import '../model/category_model.dart';

class CategoryApi extends GetxController {
  Rx<List<CategoryModel>?> listCategory = Rx<List<CategoryModel>?>([]);
  @override
  void onInit() {
    super.onInit();
    getAllCategory();
  }

  Future<ResponseBaseModel> getAllCategory() async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse(ApiUrl.apiGetAllCategory);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      responseBaseModel = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      // final categoryReceived = jsonDecode(utf8.decode(response.bodyBytes));

      // List<CategoryModel> categoriesList =DataConvert().parseCategoryList(categoryReceived);
      //     dataMap.map((data) => CategoryModel.fromJson(responseBaseModel.data!)).toList();

      // listCategory.value = categoriesList;
      // print(listCategory.value?.length);
      responseBaseModel.message = "Success";
      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }
}
