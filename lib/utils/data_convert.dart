import 'dart:convert';

import 'package:logger/logger.dart';

import '../model/category_model.dart';

class DataConvert {
  List<CategoryModel> parseCategoryList(dynamic responseBody) {
    final List<dynamic> categoryList = responseBody['data'];
    return categoryList.map((json) => CategoryModel.fromJson(json)).toList();
  }

  List<String> encodeListImages(String imagesList) {
    List<String> result = [];
    String encode = jsonEncode(imagesList);
    String str = encode
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '')
        .replaceAll('\\', '')
        .replaceAll('altu003dmedia', 'alt=media');

    result = str.split(',');
    return result;
  }
}
