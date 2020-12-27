import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/MainPageCategories/bloc/menulist_model.dart';
import 'package:singlestore/widgets/utility_widget.dart';

part 'menulist_event.dart';
part 'menulist_state.dart';

class MenulistBloc extends Bloc<MenulistEvent, MenulistState> {
  @override
  MenulistState get initialState => MenulistInitial();

  @override
  Stream<MenulistState> mapEventToState(MenulistEvent event) async* {
    if (event is FetchHomeData) {
      yield* _processCategoryFood(event.categoryID);
    } else {
      yield MenulistInitial();
    }
  }

  Stream<MenulistState> _processCategoryFood(int categoryID) async* {
    yield ProcessingState();
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    var response;
    try {
      response = await Dio().get(
        API.FETCH_MENU_BY_CATEGORY_ID + categoryID.toString(),
        queryParameters: {"storeKey": API.STORE_KEY},
        options: Options(headers: HEADER_MAP),
      );
    } catch (e) {
      print(e);
    }

    logger.e(response.data);

    StandardResponse res = StandardResponse.fromMap(response.data);
    if (res.message != null && res.message.isNotEmpty) showToast(res.message);
    if (response.statusCode == 200) {
      MenuListModel homeContainerModel = MenuListModel.fromMap(res.data);
      res.data = homeContainerModel;
      yield SuccessState(res);
    } else
      yield ErrorState(res);
  }
}
