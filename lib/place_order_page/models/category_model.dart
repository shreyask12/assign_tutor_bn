import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
// ignore: must_be_immutable
class CategoryModel extends Equatable {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? price;
  @HiveField(3)
  bool? inStock;
  @HiveField(4)
  int? quantity;
  @HiveField(5)
  bool? isBestSeller;
  @HiveField(6)
  String? categoryName;

  CategoryModel({
    this.id,
    this.name,
    this.price,
    this.inStock,
    this.quantity,
    this.isBestSeller,
    this.categoryName,
  });

  CategoryModel.fromJson(Map<String, dynamic> json, String catName) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    inStock = json['instock'];
    categoryName = json.putIfAbsent('categoryName', () => catName);
    quantity = json.putIfAbsent('quantity', () => 0);
    isBestSeller = json.putIfAbsent('isBestSeller', () => false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['instock'] = inStock;
    data['quantity'] = quantity;
    data['isBestSeller'] = isBestSeller;
    data['categoryName'] = categoryName;
    data['id'] = id;
    return data;
  }

  @override
  List<Object?> get props =>
      [id, name, price, inStock, categoryName, quantity, isBestSeller];
}
