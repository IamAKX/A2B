import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/order.dart';
import 'package:singlestore/models/taxAndChargeSet.dart';

class WebOrder {
  OrderModel order;
  List<TaxAndChargeSet> taxAndChargeSet;
  WebOrder({
    this.order,
    this.taxAndChargeSet,
  });

  WebOrder copyWith({
    OrderModel order,
    List<TaxAndChargeSet> taxAndChargeSet,
  }) {
    return WebOrder(
      order: order ?? this.order,
      taxAndChargeSet: taxAndChargeSet ?? this.taxAndChargeSet,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order?.toMap(),
      'taxAndChargeSet': taxAndChargeSet?.map((x) => x?.toMap())?.toList(),
    };
  }

  static WebOrder fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return WebOrder(
      order: OrderModel.fromMap(map['order']),
      taxAndChargeSet: List<TaxAndChargeSet>.from(
          map['taxAndChargeSet']?.map((x) => TaxAndChargeSet.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static WebOrder fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() =>
      'WebOrder(order: $order, taxAndChargeSet: $taxAndChargeSet)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is WebOrder &&
        o.order == order &&
        listEquals(o.taxAndChargeSet, taxAndChargeSet);
  }

  @override
  int get hashCode => order.hashCode ^ taxAndChargeSet.hashCode;
}
