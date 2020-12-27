import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/cart_save.dart';
import 'package:singlestore/models/order.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/HomeContainer/bloc/homecontainer_model.dart';
import 'package:singlestore/widgets/utility_widget.dart';

part 'homecontainer_event.dart';
part 'homecontainer_state.dart';

class HomecontainerBloc extends Bloc<HomecontainerEvent, HomecontainerState> {
  @override
  HomecontainerState get initialState => HomecontainerInitial();

  @override
  Stream<HomecontainerState> mapEventToState(
    HomecontainerEvent event,
  ) async* {
    if (event is FetchHomeData) {
      yield* _processFetchHomeData(event.getStoreKey);
    } else if (event is SaveCart) {
      yield* _processSaveCart(event.cart);
    } else {
      yield HomecontainerInitial();
    }
  }

  Stream<HomecontainerState> _processFetchHomeData(String getStoreKey) async* {
    yield ProcessingState();
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response;
    try {
      response = await Dio().get(
        API.FETCH_HOME_DATA,
        queryParameters: {"storeKey": API.STORE_KEY},
        options: Options(headers: HEADER_MAP),
      );
    } catch (e) {
      print(e);
    }

    if (response == null)
      yield ErrorState(StandardResponse(
          data: 'JWT Expired', message: 'JWT Expired', status: '401'));

    if (response.statusCode == 200 &&
        StandardResponse.fromMap(response.data).status == 'success') {
      StandardResponse res = StandardResponse.fromMap(response.data);
      if (res.message != null && res.message.isNotEmpty) showToast(res.message);
      print(response.data);
      HomeContainerModel homeContainerModel =
          HomeContainerModel.fromMap(res.data);
      res.data = homeContainerModel;
      if (homeContainerModel != null)
        prefs.setInt('orderID', homeContainerModel.order.id);
      // prefs.setInt('orderType', homeContainerModel.order.orderType);
      yield SuccessState(res);
    } else {
      StandardResponse res = StandardResponse.fromMap(response.data);

      yield ErrorState(res);
    }
  }

  Stream<HomecontainerState> _processSaveCart(List<CartItem> cart) async* {
    yield ProcessingState();
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CartSave cartSave = CartSave();
    cartSave.id = prefs.getInt('orderID');
    cartSave.orderType = prefs.getInt('orderType');
    cartSave.orderLineItems = cart;

    var response;
    print(cartSave.toJson());
    try {
      response = await Dio().post(
        API.SAVE_TO_CART,
        data: cartSave.toJson(),
        queryParameters: {"storeKey": API.STORE_KEY},
        options: Options(headers: HEADER_MAP),
      );
    } catch (e) {
      print(e);
    }

    StandardResponse res = StandardResponse.fromMap(response.data);
    if (res.message != null && res.message.isNotEmpty) showToast(res.message);
    if (res.message != null && res.message.isNotEmpty) showToast(res.message);
    if (response.statusCode == 200) {
      yield SuccessState(res);
    } else
      yield ErrorState(res);
  }
}
