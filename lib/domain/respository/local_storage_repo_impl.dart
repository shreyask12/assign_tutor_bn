import 'dart:collection';

import 'package:assignmenttbn/domain/respository/local_storage_repository.dart';
import 'package:hive/hive.dart';

import '../../place_order_page/models/category_model.dart';

class LocalStorageRepoImpl extends LocalStorageRepository {
  String boxName = "popular_items";

  @override
  Future<Box> openBox() async {
    Box box = await Hive.openBox<CategoryModel>(boxName);
    return box;
  }

  @override
  List<CategoryModel> getPopularItems(Box box) {
    return box.values.toList() as List<CategoryModel>;
  }

  @override
  Future<void> addtoPopularItems(
      Box box, HashMap<String?, CategoryModel> model) async {
    await box.putAll(model);
  }
}
