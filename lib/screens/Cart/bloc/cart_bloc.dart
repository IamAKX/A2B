import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/models/availableDateTimings.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/cart_save.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_model.dart';
import 'package:singlestore/widgets/utility_widget.dart';

part 'cart_event.dart';
part 'cart_state.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class CartBloc extends Bloc<CartEvent, CartState> {
  @override
  CartState get initialState => CartInitialState();

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is PrepareOrder) {
      yield* _processPrepareOrder(event.cart);
    } else {
      yield CartInitialState();
    }
  }

  Stream<CartState> _processPrepareOrder(List<CartItem> cart) async* {
    yield ProcessingState();

    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (CartItem ci in cart) ci.quantity = 1;
    CartSave cartSave = CartSave();
    cartSave.id = prefs.getInt('orderID');
    cartSave.orderType = prefs.getInt('orderType');
    cartSave.orderLineItems = cart;

    var response;
    try {
      response = await Dio().post(
        API.SAVE_TO_CART,
        data: cartSave.toJson(),
        queryParameters: {"storeKey": API.STORE_KEY},
        options: Options(
          headers: HEADER_MAP,
          receiveTimeout: 60000,
          sendTimeout: 30000,
        ),
      );
    } catch (e) {
      print(e);
    }
    logger.e(response.data);
    StandardResponse res = StandardResponse.fromMap(response.data);
    if (res.message != null && res.message.isNotEmpty) showToast(res.message);
    // final timings = json.decode(res.data.toJSON());
    OrderDateTimes odt = OrderDateTimes.fromMap(res.data['orderDateTimes']);

    if (response.statusCode == 200) {
      PrepareOrderModel prepareOrderModel = PrepareOrderModel.fromMap(res.data);
      prepareOrderModel.orderDateTimes = odt;

      res.data = prepareOrderModel;
      yield SuccessState(res);
    } else
      // showToast(res.message);
      yield ErrorState(res);
  }
}
