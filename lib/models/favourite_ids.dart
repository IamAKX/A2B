import 'dart:convert';

import 'package:flutter/foundation.dart';

class FavouriteIdModel {
  String favoriteItemIds;
  int orderAppDraftState;
  FavouriteIdModel({
    this.favoriteItemIds,
    this.orderAppDraftState,
  });

  FavouriteIdModel copyWith({
    String favoriteItemIds,
    int orderAppDraftState,
  }) {
    return FavouriteIdModel(
      favoriteItemIds: favoriteItemIds ?? this.favoriteItemIds,
      orderAppDraftState: orderAppDraftState ?? this.orderAppDraftState,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'favoriteItemIds': favoriteItemIds,
      'orderAppDraftState': orderAppDraftState,
    };
  }

  factory FavouriteIdModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FavouriteIdModel(
      favoriteItemIds: map['favoriteItemIds'],
      orderAppDraftState: map['orderAppDraftState'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteIdModel.fromJson(String source) =>
      FavouriteIdModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FavouriteIdModel(favoriteItemIds: $favoriteItemIds, orderAppDraftState: $orderAppDraftState)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FavouriteIdModel &&
        o.favoriteItemIds == favoriteItemIds &&
        o.orderAppDraftState == orderAppDraftState;
  }

  @override
  int get hashCode => favoriteItemIds.hashCode ^ orderAppDraftState.hashCode;
}
