import '../model/category_model.dart';

class DataConvert {
  List<CategoryModel> parseCategoryList(dynamic responseBody) {
    final List<dynamic> categoryList = responseBody['data'];
    return categoryList.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
