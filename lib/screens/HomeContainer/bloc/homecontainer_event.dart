part of 'homecontainer_bloc.dart';

abstract class HomecontainerEvent extends Equatable {
  const HomecontainerEvent([List props = const []]) : super();
}

class FetchHomeData extends HomecontainerEvent {
  String storeKey;
  FetchHomeData(this.storeKey) : super();

  String get getStoreKey => storeKey;

  @override
  List<Object> get props => [storeKey];
}

class SaveCart extends HomecontainerEvent {
  List<CartItem> cart;
  SaveCart(this.cart) : super();

  List<CartItem> get cartList => cart;

  @override
  List<Object> get props => [cart];
}
