part of 'menulist_bloc.dart';

abstract class MenulistState extends Equatable {
  const MenulistState();
}

class MenulistInitial extends MenulistState {
  @override
  List<Object> get props => [];
}

class ProcessingState extends MenulistState {
  @override
  List<Object> get props => [];
}

class SuccessState extends MenulistState {
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

class ErrorState extends MenulistState {
  StandardResponse _resModel;
  ErrorState(this._resModel) : super();
  StandardResponse get getResponse => _resModel;

  @override
  String toString() {
    return "Failed ";
  }

  @override
  List<Object> get props => [];
}
