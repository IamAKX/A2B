part of 'offer_bloc.dart';

abstract class OfferEvent extends Equatable {
  const OfferEvent();
}

class FetchPromoCode extends OfferEvent {
  @override
  List<Object> get props => [];
}
