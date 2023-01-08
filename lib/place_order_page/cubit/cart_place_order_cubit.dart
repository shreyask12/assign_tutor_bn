import 'dart:collection';
import 'dart:math';

import 'package:assignmenttbn/domain/respository/local_storage_repository.dart';
import 'package:assignmenttbn/place_order_page/models/category_model.dart';
import 'package:assignmenttbn/resources/json_retriever.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/category_model_response.dart';

part 'cart_place_order_state.dart';

class CartPlaceOrderCubit extends Cubit<CartPlaceOrderState> {
  final LocalStorageRepository _localStorageRepository;
  final JsonDataRetriever jsonDataRetriever;
  CartPlaceOrderCubit(
      {required this.jsonDataRetriever,
      required LocalStorageRepository localStorageRepository})
      : _localStorageRepository = localStorageRepository,
        super(CartPlaceOrderState.onLoadingState());

  Map<String, dynamic> jsonMap = {};
  HashMap<String?, CategoryModel> orderPlacedLists =
      HashMap<String?, CategoryModel>();

  Map<String, List<CategoryModel>> displayList = {};

  void fetchData() async {
    emit(CartPlaceOrderState.onLoadingState());
    try {
      Box box = await _localStorageRepository.openBox();
      List<CategoryModel> model = _localStorageRepository
          .getPopularItems(box)
          .unique((x) => x.id)
          .take(3)
          .toList();
      jsonMap = await jsonDataRetriever.loadJson();
      Map<String, List<CategoryModel>> newMap = {};

      CategoryModelResponse? response;

      response = CategoryModelResponse.fromJson(jsonMap);

      final sortedList = response.data;
      if (model.isNotEmpty) {
        newMap = {"Popular Items": model, ...sortedList ?? {}};
      } else {
        newMap = sortedList ?? {};
      }
      displayList = newMap;
      emit(CartPlaceOrderState.onSuccessState(data: newMap));
    } catch (e) {
      emit(CartPlaceOrderState.onFailedState());
    }
  }

  void onAddProduct(CategoryModel model) {
    if (orderPlacedLists.containsKey(model.id)) {
      if (model.quantity == 0) {
        orderPlacedLists.remove(model.id);
      } else {
        orderPlacedLists.update(model.id, (value) => model);
      }
    } else {
      orderPlacedLists[model.id] = model;
    }

    double price = 0;

    for (var element in orderPlacedLists.values) {
      price += element.price! * element.quantity!;
    }
    if (orderPlacedLists.isEmpty) {
      price = 0;
    }
    emit(CartPlaceOrderState.onAddToCartSuccessState(
        totalPrice: price == 0 ? '' : price.toString()));
  }

  Future<void> placeOrder() async {
    if (orderPlacedLists.isNotEmpty) {
      Box box = await _localStorageRepository.openBox();
      emit(CartPlaceOrderState.onLoadingState());

      await _localStorageRepository.addtoPopularItems(box, orderPlacedLists);

      List<CategoryModel> popularItems =
          _localStorageRepository.getPopularItems(box);

      for (final elem in popularItems) {
        elem.isBestSeller = true;
        elem.quantity = 0;
      }

      final products = popularItems.unique((x) => x.id).take(3).toList();

      Map<String, List<CategoryModel>> newMap = {};

      CategoryModelResponse resp = CategoryModelResponse.fromJson(jsonMap);

      final sortedList = resp.data;

      newMap = {"Popular Items": products, ...sortedList ?? {}};
      displayList.clear();
      displayList = newMap;
      orderPlacedLists.clear();
      emit(
          CartPlaceOrderState.onSuccessState(data: newMap, isFromOrders: true));
    } else {
      String message = 'Please Add Items to Cart to Place orders';

      emit(CartPlaceOrderState.onEmptyState(message: message));
    }
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
