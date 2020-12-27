import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/fooditem.dart';

class FavouriteModel {
  int id;
  int customerId;
  int storeId;
  List<FoodItem> items;
  FavouriteModel({
    this.id,
    this.customerId,
    this.storeId,
    this.items,
  });

  FavouriteModel copyWith({
    int id,
    int customerId,
    int storeId,
    List<FoodItem> items,
  }) {
    return FavouriteModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      storeId: storeId ?? this.storeId,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'storeId': storeId,
      'items': items?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FavouriteModel(
      id: map['id'],
      customerId: map['customerId'],
      storeId: map['storeId'],
      items: List<FoodItem>.from(map['items']?.map((x) => FoodItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteModel.fromJson(String source) =>
      FavouriteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FavouriteModel(id: $id, customerId: $customerId, storeId: $storeId, items: $items)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FavouriteModel &&
        o.id == id &&
        o.customerId == customerId &&
        o.storeId == storeId &&
        listEquals(o.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerId.hashCode ^
        storeId.hashCode ^
        items.hashCode;
  }
}
