import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/all_order_display_item.dart';

class AllOrderModel {
  String reOrderMessage;
  List<DisplayOrders> displayOrders;
  AllOrderModel({
    this.reOrderMessage,
    this.displayOrders,
  });

  AllOrderModel copyWith({
    String reOrderMessage,
    List<DisplayOrders> displayOrders,
  }) {
    return AllOrderModel(
      reOrderMessage: reOrderMessage ?? this.reOrderMessage,
      displayOrders: displayOrders ?? this.displayOrders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reOrderMessage': reOrderMessage,
      'displayOrders': displayOrders?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory AllOrderModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AllOrderModel(
      reOrderMessage: map['reOrderMessage'],
      displayOrders: List<DisplayOrders>.from(
          map['displayOrders']?.map((x) => DisplayOrders.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AllOrderModel.fromJson(String source) =>
      AllOrderModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AllOrderModel(reOrderMessage: $reOrderMessage, displayOrders: $displayOrders)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AllOrderModel &&
        o.reOrderMessage == reOrderMessage &&
        listEquals(o.displayOrders, displayOrders);
  }

  @override
  int get hashCode => reOrderMessage.hashCode ^ displayOrders.hashCode;
}
