import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:singlestore/models/store_model.dart';
import 'package:singlestore/models/web_stores.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class StoreMap extends StatefulWidget {
  StoreModel model;
  Position position;
  StoreMap(this.model, this.position) : super();

  @override
  _StoreMapState createState() => _StoreMapState();
}

class _StoreMapState extends State<StoreMap> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition myPosition;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myPosition = CameraPosition(
      target: LatLng(widget.position.latitude, widget.position.longitude),
      zoom: 10.4746,
      bearing: 192.8334901395799,
      tilt: 59.440717697143555,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markerList = [];
    for (WebStore store in widget.model.webStores)
      markerList.add(
        Marker(
          markerId: MarkerId(
            store.id.toString(),
          ),
          zIndex: 10,
          flat: false,
          infoWindow: InfoWindow(
            title: store.name,
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/storeDetails', arguments: store);
            },
          ),
          position: LatLng(store.latitude, store.longitude),
        ),
      );
    logger.e(markerList.length);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: myPosition,
      compassEnabled: true,
      // indoorViewEnabled: true,
      buildingsEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      // zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      markers: Set<Marker>.of(markerList),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
