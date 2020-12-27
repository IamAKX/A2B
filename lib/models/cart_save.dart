import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/cart_item_model.dart';

class CartSave {
  int id;
  int orderType;
  List<CartItem> orderLineItems;
  CartSave({
    this.id,
    this.orderType,
    this.orderLineItems,
  });

  CartSave copyWith({
    int id,
    int orderType,
    List<CartItem> orderLineItems,
  }) {
    return CartSave(
      id: id ?? this.id,
      orderType: orderType ?? this.orderType,
      orderLineItems: orderLineItems ?? this.orderLineItems,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderType': orderType,
      'orderLineItems': orderLineItems?.map((x) => x?.toMap())?.toList(),
    };
  }

  static CartSave fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CartSave(
      id: map['id'],
      orderType: map['orderType'],
      orderLineItems: List<CartItem>.from(
          map['orderLineItems']?.map((x) => CartItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static CartSave fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() =>
      'CartSave(id: $id, orderType: $orderType, orderLineItems: $orderLineItems)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CartSave &&
        o.id == id &&
        o.orderType == orderType &&
        listEquals(o.orderLineItems, orderLineItems);
  }

  @override
  int get hashCode =>
      id.hashCode ^ orderType.hashCode ^ orderLineItems.hashCode;
}
