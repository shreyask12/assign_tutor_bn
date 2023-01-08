part of 'cart_place_order_cubit.dart';

abstract class CartPlaceOrderState extends Equatable {
  const CartPlaceOrderState._();

  @override
  List<Object> get props => [identityHashCode(this)];

  factory CartPlaceOrderState.onEmptyState({required final String message}) =>
      OnEmptyCartState._(message: message);

  factory CartPlaceOrderState.onSuccessState(
          {required final Map<String, List<CategoryModel>> data,
          final bool isFromOrders = false}) =>
      CartPlaceOrderPlaceOrderSuccessState._(
          data: data, isFromOrders: isFromOrders);

  factory CartPlaceOrderState.onAddToCartSuccessState({
    required final String totalPrice,
  }) =>
      CartOnAddProductSuccessState._(totalPrice: totalPrice);

  factory CartPlaceOrderState.onLoadingState() =>
      const CartPlaceOrderLoadingState._();

  factory CartPlaceOrderState.onFailedState() =>
      const CartPlaceOrderFailedState._();

  factory CartPlaceOrderState.onInitialState() =>
      const CartPlaceOrderInitial._();
}

class CartPlaceOrderInitial extends CartPlaceOrderState {
  const CartPlaceOrderInitial._() : super._();
}

class CartPlaceOrderLoadingState extends CartPlaceOrderState {
  const CartPlaceOrderLoadingState._() : super._();

  @override
  List<Object> get props => [identityHashCode(this) + Random().nextDouble()];
}

class CartPlaceOrderPlaceOrderSuccessState extends CartPlaceOrderState {
  final Map<String, List<CategoryModel>> data;
  final bool isFromOrders;
  const CartPlaceOrderPlaceOrderSuccessState._(
      {required this.data, this.isFromOrders = false})
      : super._();

  @override
  List<Object> get props => [data, isFromOrders];
}

class CartOnAddProductSuccessState extends CartPlaceOrderState {
  final String totalPrice;
  const CartOnAddProductSuccessState._({required this.totalPrice}) : super._();

  @override
  List<Object> get props => [totalPrice.hashCode + identityHashCode(this)];
}

class CartPlaceOrderFailedState extends CartPlaceOrderState {
  const CartPlaceOrderFailedState._() : super._();
}

class OnEmptyCartState extends CartPlaceOrderState {
  final String message;

  const OnEmptyCartState._({required this.message}) : super._();

  @override
  List<Object> get props => [message.hashCode + identityHashCode(this)];
}
