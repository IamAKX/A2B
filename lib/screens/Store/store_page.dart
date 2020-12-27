import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/main.dart';
import 'package:singlestore/models/favourite_ids.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/models/store_model.dart';
import 'package:singlestore/models/web_stores.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/Store/store_list.dart';
import 'package:singlestore/screens/Store/store_map.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool isLoading = false;
  StoreModel model = StoreModel(webStores: []);
  Position position;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this);
    loadStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: THEME_COLOR_PRIMARY),
        title: Text(
          'Select Store',
          style: GoogleFonts.manrope(
            color: THEME_COLOR_PRIMARY,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: THEME_COLOR_PRIMARY,
          indicatorColor: THEME_COLOR_PRIMARY,
          tabs: [
            Tab(
              text: 'List',
            ),
            Tab(
              text: 'Map',
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : model.webStores.length == 0
              ? Center(
                  child: Text('No store'),
                )
              : body(),
    );
  }

  body() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        StoreList(model),
        StoreMap(model, position),
      ],
      controller: _tabController,
    );
  }

  Future<void> loadStores() async {
    setState(() {
      isLoading = true;
    });
    try {
      // position =
      //     await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      position = await getLastKnownPosition();
      if (position != null) {
        logger.e(position.latitude);
        logger.e(position.longitude);
      }
    } catch (e) {}

    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    String url = API.BASE_URL + '/api/singlestore/stores/';

    var response;
    try {
      response = await Dio().get(
        url,
        queryParameters: {
          "storeCommonKey": API.COMMON_STORE_KEY,
        },
        options: Options(headers: HEADER_MAP),
      );
      setState(() {
        isLoading = false;
      });
      StandardResponse res = StandardResponse.fromMap(response.data);
      if (res.message != null && res.message.isNotEmpty) showToast(res.message);
      model = StoreModel.fromMap(res.data);
      if (model.webStores.length == 1)
        saveUserProfileLocal(model.webStores.elementAt(0));
      setState(() {});
    } catch (e) {}
  }

  Future<void> saveUserProfileLocal(WebStore element) async {
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;
    prefs.setString("storeKey", element.storeKey);
    API.STORE_KEY = element.storeKey;
    var response;
    try {
      response = await Dio().get(
        API.BASE_URL + '/api/app/singlestore/commonDetails',
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

    StandardResponse res = StandardResponse.fromMap(response.data);
    if (res.message != null && res.message.isNotEmpty) showToast(res.message);
    // showToast(res.message);
    logger.e(res.data);
    FavouriteIdModel model = FavouriteIdModel.fromMap(res.data);
    prefs.setStringList('fav', model.favoriteItemIds.split(','));

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }
}
