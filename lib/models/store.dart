import 'dart:convert';

import 'package:flutter/foundation.dart';

class Store {
  int id;
  String name;
  String fullname;
  String tagline;
  String description;
  String posProductKey;
  String storeKey;
  String registrationId;
  String email;
  String address;
  String shortAddress;
  String city;
  String state;
  String country;
  String zipCode;
  String phone;
  int status;
  bool hasLinkedStores;
  String logoSmall;
  String logoLarge;
  String currency;
  List<int> availableOrderTypes;
  Store({
    this.id,
    this.name,
    this.fullname,
    this.tagline,
    this.description,
    this.posProductKey,
    this.storeKey,
    this.registrationId,
    this.email,
    this.address,
    this.shortAddress,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.phone,
    this.status,
    this.hasLinkedStores,
    this.logoSmall,
    this.logoLarge,
    this.currency,
    this.availableOrderTypes,
  });

  Store copyWith({
    int id,
    String name,
    String fullname,
    String tagline,
    String description,
    String posProductKey,
    String storeKey,
    String registrationId,
    String email,
    String address,
    String shortAddress,
    String city,
    String state,
    String country,
    String zipCode,
    String phone,
    int status,
    bool hasLinkedStores,
    String logoSmall,
    String logoLarge,
    String currency,
    List<int> availableOrderTypes,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      fullname: fullname ?? this.fullname,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      posProductKey: posProductKey ?? this.posProductKey,
      storeKey: storeKey ?? this.storeKey,
      registrationId: registrationId ?? this.registrationId,
      email: email ?? this.email,
      address: address ?? this.address,
      shortAddress: shortAddress ?? this.shortAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      hasLinkedStores: hasLinkedStores ?? this.hasLinkedStores,
      logoSmall: logoSmall ?? this.logoSmall,
      logoLarge: logoLarge ?? this.logoLarge,
      currency: currency ?? this.currency,
      availableOrderTypes: availableOrderTypes ?? this.availableOrderTypes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fullname': fullname,
      'tagline': tagline,
      'description': description,
      'posProductKey': posProductKey,
      'storeKey': storeKey,
      'registrationId': registrationId,
      'email': email,
      'address': address,
      'shortAddress': shortAddress,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'phone': phone,
      'status': status,
      'hasLinkedStores': hasLinkedStores,
      'logoSmall': logoSmall,
      'logoLarge': logoLarge,
      'currency': currency,
      'availableOrderTypes': availableOrderTypes,
    };
  }

  static Store fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Store(
      id: map['id'],
      name: map['name'],
      fullname: map['fullname'],
      tagline: map['tagline'],
      description: map['description'],
      posProductKey: map['posProductKey'],
      storeKey: map['storeKey'],
      registrationId: map['registrationId'],
      email: map['email'],
      address: map['address'],
      shortAddress: map['shortAddress'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      zipCode: map['zipCode'],
      phone: map['phone'],
      status: map['status'],
      hasLinkedStores: map['hasLinkedStores'],
      logoSmall: map['logoSmall'],
      logoLarge: map['logoLarge'],
      currency: map['currency'],
      availableOrderTypes: List<int>.from(map['availableOrderTypes']),
    );
  }

  String toJson() => json.encode(toMap());

  static Store fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Store(id: $id, name: $name, fullname: $fullname, tagline: $tagline, description: $description, posProductKey: $posProductKey, storeKey: $storeKey, registrationId: $registrationId, email: $email, address: $address, shortAddress: $shortAddress, city: $city, state: $state, country: $country, zipCode: $zipCode, phone: $phone, status: $status, hasLinkedStores: $hasLinkedStores, logoSmall: $logoSmall, logoLarge: $logoLarge, currency: $currency, availableOrderTypes: $availableOrderTypes)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Store &&
        o.id == id &&
        o.name == name &&
        o.fullname == fullname &&
        o.tagline == tagline &&
        o.description == description &&
        o.posProductKey == posProductKey &&
        o.storeKey == storeKey &&
        o.registrationId == registrationId &&
        o.email == email &&
        o.address == address &&
        o.shortAddress == shortAddress &&
        o.city == city &&
        o.state == state &&
        o.country == country &&
        o.zipCode == zipCode &&
        o.phone == phone &&
        o.status == status &&
        o.hasLinkedStores == hasLinkedStores &&
        o.logoSmall == logoSmall &&
        o.logoLarge == logoLarge &&
        o.currency == currency &&
        listEquals(o.availableOrderTypes, availableOrderTypes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        fullname.hashCode ^
        tagline.hashCode ^
        description.hashCode ^
        posProductKey.hashCode ^
        storeKey.hashCode ^
        registrationId.hashCode ^
        email.hashCode ^
        address.hashCode ^
        shortAddress.hashCode ^
        city.hashCode ^
        state.hashCode ^
        country.hashCode ^
        zipCode.hashCode ^
        phone.hashCode ^
        status.hashCode ^
        hasLinkedStores.hashCode ^
        logoSmall.hashCode ^
        logoLarge.hashCode ^
        currency.hashCode ^
        availableOrderTypes.hashCode;
  }
}
