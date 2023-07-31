import 'dart:convert';

class CategoryModel {
  String? id;
  String? categoryName;

  CategoryModel({
    this.id,
    this.categoryName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['categoryId'],
      categoryName: json['categoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': id,
      'categoryName': categoryName,
    };
  }

  List<CategoryModel> parseCategoryList(String responseBody) {
    final parsed = json.decode(responseBody);
    final List<dynamic> categoryList = parsed['data'];
    return categoryList.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
