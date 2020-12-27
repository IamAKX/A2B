part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class PrepareOrder extends CartEvent {
  List<CartItem> cart;
  PrepareOrder(this.cart) : super();

  List<CartItem> get getStoreKey => cart;

  @override
  List<Object> get props => [cart];
}
