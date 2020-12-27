import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/storeHours.dart';

class WebStore {
  String name;
  int id;
  String storeKey;
  String address;
  String phone;
  double latitude;
  double longitude;
  List<String> facilities;
  int focusDay;
  List<StoreHours> storeHours;
  WebStore({
    this.name,
    this.id,
    this.storeKey,
    this.address,
    this.phone,
    this.latitude,
    this.longitude,
    this.facilities,
    this.focusDay,
    this.storeHours,
  });

  WebStore copyWith({
    String name,
    int id,
    String storeKey,
    String address,
    String phone,
    double latitude,
    double longitude,
    List<String> facilities,
    int focusDay,
    List<StoreHours> storeHours,
  }) {
    return WebStore(
      name: name ?? this.name,
      id: id ?? this.id,
      storeKey: storeKey ?? this.storeKey,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      facilities: facilities ?? this.facilities,
      focusDay: focusDay ?? this.focusDay,
      storeHours: storeHours ?? this.storeHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'storeKey': storeKey,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'facilities': facilities,
      'focusDay': focusDay,
      'storeHours': storeHours?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory WebStore.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return WebStore(
      name: map['name'],
      id: map['id'],
      storeKey: map['storeKey'],
      address: map['address'],
      phone: map['phone'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      facilities: List<String>.from(map['facilities']),
      focusDay: map['focusDay'],
      storeHours: List<StoreHours>.from(
          map['storeHours']?.map((x) => StoreHours.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory WebStore.fromJson(String source) =>
      WebStore.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WebStore(name: $name, id: $id, storeKey: $storeKey, address: $address, phone: $phone, latitude: $latitude, longitude: $longitude, facilities: $facilities, focusDay: $focusDay, storeHours: $storeHours)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is WebStore &&
        o.name == name &&
        o.id == id &&
        o.storeKey == storeKey &&
        o.address == address &&
        o.phone == phone &&
        o.latitude == latitude &&
        o.longitude == longitude &&
        listEquals(o.facilities, facilities) &&
        o.focusDay == focusDay &&
        listEquals(o.storeHours, storeHours);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        storeKey.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        facilities.hashCode ^
        focusDay.hashCode ^
        storeHours.hashCode;
  }
}
