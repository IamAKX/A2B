import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/Offer/bloc/promo_model.dart';
import 'package:singlestore/widgets/utility_widget.dart';

part 'offer_event.dart';
part 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  @override
  OfferState get initialState => InitialState();

  @override
  Stream<OfferState> mapEventToState(
    OfferEvent event,
  ) async* {
    if (event is FetchPromoCode) {
      yield* _processPromoCOde();
    } else {
      yield InitialState();
    }
  }

  Stream<OfferState> _processPromoCOde() async* {
    yield InitialState();
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    var response;
    try {
      response = await Dio().get(
        API.FETCH_ALL_PROMOCODE,
        queryParameters: {"storeKey": API.STORE_KEY},
        options: Options(headers: HEADER_MAP),
      );
    } catch (e) {
      print(e);
    }
    StandardResponse res = StandardResponse.fromMap(response.data);
    if (res.message != null && res.message.isNotEmpty) showToast(res.message);
    PromoModel promoMode;

    print(res.data);
    if (response.statusCode == 200) {
      promoMode = PromoModel.fromMap(res.data);
      res.data = promoMode;
      yield SuccessState(res);
    } else
      yield ErrorState(res);
  }
}
