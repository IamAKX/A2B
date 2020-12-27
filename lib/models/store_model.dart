import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/web_stores.dart';

class StoreModel {
  List<WebStore> webStores;
  StoreModel({
    this.webStores,
  });

  StoreModel copyWith({
    List<WebStore> webStores,
  }) {
    return StoreModel(
      webStores: webStores ?? this.webStores,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'webStores': webStores?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return StoreModel(
      webStores: List<WebStore>.from(
          map['webStores']?.map((x) => WebStore.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreModel.fromJson(String source) =>
      StoreModel.fromMap(json.decode(source));

  @override
  String toString() => 'StoreModel(webStores: $webStores)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StoreModel && listEquals(o.webStores, webStores);
  }

  @override
  int get hashCode => webStores.hashCode;
}
