import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/cart_item_option_model.dart';

class CartItem {
  int id;
  int itemId;
  String itemName;
  List<CartItemOption> orderLineItemsOptions;
  int personNum;
  int priority;
  int quantity;
  int uniqueKey;
  double unitPrice;
  bool veg;
  CartItem({
    this.id,
    this.itemId,
    this.itemName,
    this.orderLineItemsOptions,
    this.personNum,
    this.priority,
    this.quantity,
    this.uniqueKey,
    this.unitPrice,
    this.veg,
  });

  CartItem copyWith({
    int id,
    int itemId,
    String itemName,
    List<CartItemOption> orderLineItemsOptions,
    int personNum,
    int priority,
    int quantity,
    int uniqueKey,
    double unitPrice,
    bool veg,
  }) {
    return CartItem(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      orderLineItemsOptions:
          orderLineItemsOptions ?? this.orderLineItemsOptions,
      personNum: personNum ?? this.personNum,
      priority: priority ?? this.priority,
      quantity: quantity ?? this.quantity,
      uniqueKey: uniqueKey ?? this.uniqueKey,
      unitPrice: unitPrice ?? this.unitPrice,
      veg: veg ?? this.veg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'itemName': itemName,
      'orderLineItemsOptions':
          orderLineItemsOptions?.map((x) => x?.toMap())?.toList(),
      'personNum': personNum,
      'priority': priority,
      'quantity': quantity,
      'uniqueKey': uniqueKey,
      'unitPrice': unitPrice,
      'veg': veg,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CartItem(
      id: map['id'],
      itemId: map['itemId'],
      itemName: map['itemName'],
      orderLineItemsOptions: List<CartItemOption>.from(
          map['orderLineItemsOptions']?.map((x) => CartItemOption.fromMap(x))),
      personNum: map['personNum'],
      priority: map['priority'],
      quantity: map['quantity'],
      uniqueKey: map['uniqueKey'],
      unitPrice: map['unitPrice'],
      veg: map['veg'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartItem(id: $id, itemId: $itemId, itemName: $itemName, orderLineItemsOptions: $orderLineItemsOptions, personNum: $personNum, priority: $priority, quantity: $quantity, uniqueKey: $uniqueKey, unitPrice: $unitPrice, veg: $veg)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CartItem &&
        o.id == id &&
        o.itemId == itemId &&
        o.itemName == itemName &&
        listEquals(o.orderLineItemsOptions, orderLineItemsOptions) &&
        o.personNum == personNum &&
        o.priority == priority &&
        o.quantity == quantity &&
        o.uniqueKey == uniqueKey &&
        o.unitPrice == unitPrice &&
        o.veg == veg;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        itemId.hashCode ^
        itemName.hashCode ^
        orderLineItemsOptions.hashCode ^
        personNum.hashCode ^
        priority.hashCode ^
        quantity.hashCode ^
        uniqueKey.hashCode ^
        unitPrice.hashCode ^
        veg.hashCode;
  }
}
