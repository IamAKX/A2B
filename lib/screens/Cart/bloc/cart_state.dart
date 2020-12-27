part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitialState extends CartState {
  @override
  List<Object> get props => [];
}

class ProcessingState extends CartState {
  @override
  List<Object> get props => [];
}

class SuccessState extends CartState {
  @override
  List<Object> get props => [];

  StandardResponse _resModel;
  SuccessState(this._resModel) : super();
  StandardResponse get getResponse => _resModel;

  @override
  String toString() {
    return "successful";
  }
}

class ErrorState extends CartState {
  StandardResponse _resModel;
  ErrorState(this._resModel) : super();
  StandardResponse get getResponse => _resModel;

  @override
  String toString() {
    return "Registration Failed ";
  }

  @override
  List<Object> get props => [];
}
