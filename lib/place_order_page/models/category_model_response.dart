import 'dart:collection';

import 'category_model.dart';

class CategoryModelResponse {
  Map<String, List<CategoryModel>>? data;

  CategoryModelResponse({this.data});

  CategoryModelResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final Map<String, List<CategoryModel>> newData =
        <String, List<CategoryModel>>{};

    final sorted =
        SplayTreeMap<String, dynamic>.from(json, (a, b) => a.compareTo(b));
    List<CategoryModel> model = [];
    sorted.forEach((key, value) {
      model = [
        ...value.map((item) => CategoryModel.fromJson(item, key)).toList()
      ];
      newData.putIfAbsent(key, () => model);
    });
    data = newData;
  }

  @override
  bool operator ==(other) {
    return (other is CategoryModelResponse) && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
