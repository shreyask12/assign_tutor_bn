import 'dart:collection';

import 'package:hive_flutter/hive_flutter.dart';

import '../../place_order_page/models/category_model.dart';

abstract class LocalStorageRepository {
  Future<Box> openBox();

  List<CategoryModel> getPopularItems(Box box);

  Future<void> addtoPopularItems(
      Box box, HashMap<String?, CategoryModel> model);
}
