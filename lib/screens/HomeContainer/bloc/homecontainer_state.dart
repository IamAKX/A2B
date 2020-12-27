part of 'homecontainer_bloc.dart';

abstract class HomecontainerState extends Equatable {
  const HomecontainerState();
}

class HomecontainerInitial extends HomecontainerState {
  @override
  List<Object> get props => [];
}

class ProcessingState extends HomecontainerState {
  @override
  List<Object> get props => [];
}

class SuccessState extends HomecontainerState {
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

class ErrorState extends HomecontainerState {
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
