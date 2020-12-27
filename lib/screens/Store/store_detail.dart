import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/main.dart';
import 'package:singlestore/models/favourite_ids.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/models/storeHours.dart';
import 'package:singlestore/models/web_stores.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/widgets/utility_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetails extends StatefulWidget {
  WebStore store;
  StoreDetails(this.store) : super();

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  Completer<GoogleMapController> _controller = Completer();
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: THEME_COLOR_PRIMARY),
        title: Text(
          '${widget.store.name}',
          style: GoogleFonts.manrope(
            color: THEME_COLOR_PRIMARY,
          ),
        ),
      ),
      body: body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            onPressed: () {
              launch("tel://${widget.store.phone}");
            },
            child: Text('Call Store'),
          ),
          RaisedButton(
            onPressed: () {
              saveUserProfileLocal();
            },
            child: Text('Select Store'),
          ),
          RaisedButton(
            onPressed: () {
              launch(
                  "http://maps.google.com/maps?daddr=${widget.store.latitude},${widget.store.longitude}");
            },
            child: Text('Direction'),
          ),
        ],
      ),
    );
  }

  body() {
    CameraPosition myPosition = CameraPosition(
      target: LatLng(widget.store.latitude, widget.store.longitude),
      zoom: 10.4746,
      bearing: 192.8334901395799,
      tilt: 59.440717697143555,
    );

    List<Marker> markerList = [];

    markerList.add(
      Marker(
        markerId: MarkerId(
          widget.store.id.toString(),
        ),
        zIndex: 10,
        flat: false,
        infoWindow: InfoWindow(
          title: widget.store.name,
        ),
        position: LatLng(widget.store.latitude, widget.store.longitude),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.animateTo((200.0 * widget.store.focusDay),
          duration: Duration(milliseconds: 1000), curve: Curves.elasticOut);
    });

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: myPosition,
            // compassEnabled: true,
            // indoorViewEnabled: true,
            buildingsEnabled: true,
            // myLocationButtonEnabled: true,
            // myLocationEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            // zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(markerList),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          widget.store.name,
          style: TextStyle(color: THEME_COLOR_PRIMARY, fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          widget.store.address,
          style: TextStyle(fontSize: 16),
        ),
        Divider(
          indent: 10,
          endIndent: 10,
        ),
        Text(
          'Store Hours',
          style: TextStyle(color: THEME_COLOR_PRIMARY, fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 70,
          width: double.maxFinite,
          child: ListView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            children: [
              for (StoreHours sh in widget.store.storeHours) ...{
                Container(
                  width: 180,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: sh.id == widget.store.focusDay
                            ? THEME_COLOR_PRIMARY
                            : Colors.grey,
                      )),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${sh.name}',
                        style: TextStyle(
                          color: sh.id == widget.store.focusDay
                              ? Colors.black
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${sh.description}',
                        style: TextStyle(
                          color: sh.id == widget.store.focusDay
                              ? Colors.black
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                )
              }
            ],
          ),
        ),
        SizedBox(
          height: 80,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     RaisedButton(
        //       onPressed: () {
        //         launch("tel://${widget.store.phone}");
        //       },
        //       child: Text('Call Store'),
        //     ),
        //     RaisedButton(
        //       onPressed: () {
        //         saveUserProfileLocal();
        //       },
        //       child: Text('Select Store'),
        //     ),
        //     RaisedButton(
        //       onPressed: () {
        //         launch(
        //             "http://maps.google.com/maps?daddr=${widget.store.latitude},${widget.store.longitude}");
        //       },
        //       child: Text('Direction'),
        //     ),
        //   ],
        // )
      ],
    );
  }

  Future<void> saveUserProfileLocal() async {
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;
    prefs.setString("storeKey", widget.store.storeKey);
    API.STORE_KEY = widget.store.storeKey;
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
