part of 'offer_bloc.dart';

abstract class OfferState extends Equatable {
  const OfferState();
}

class InitialState extends OfferState {
  @override
  List<Object> get props => [];
}

class ProcessingState extends OfferState {
  @override
  List<Object> get props => [];
}

class SuccessState extends OfferState {
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

class ErrorState extends OfferState {
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
