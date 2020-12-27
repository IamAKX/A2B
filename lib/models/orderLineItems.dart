import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'orderLineItemsOptions.dart';

class OrderLineItems {
  int id;
  int personNum;
  int uniqueKey;
  String itemName;
  int itemId;
  double unitPrice;
  double quantity;
  String comment;
  int priority;
  List<OrderLineItemsOptions> orderLineItemsOptions;
  bool veg;
  OrderLineItems({
    this.id,
    this.personNum,
    this.uniqueKey,
    this.itemName,
    this.itemId,
    this.unitPrice,
    this.quantity,
    this.comment,
    this.priority,
    this.orderLineItemsOptions,
    this.veg,
  });

  OrderLineItems copyWith({
    int id,
    int personNum,
    int uniqueKey,
    String itemName,
    int itemId,
    double unitPrice,
    double quantity,
    String comment,
    int priority,
    List<OrderLineItemsOptions> orderLineItemsOptions,
    bool veg,
  }) {
    return OrderLineItems(
      id: id ?? this.id,
      personNum: personNum ?? this.personNum,
      uniqueKey: uniqueKey ?? this.uniqueKey,
      itemName: itemName ?? this.itemName,
      itemId: itemId ?? this.itemId,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      comment: comment ?? this.comment,
      priority: priority ?? this.priority,
      orderLineItemsOptions:
          orderLineItemsOptions ?? this.orderLineItemsOptions,
      veg: veg ?? this.veg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'personNum': personNum,
      'uniqueKey': uniqueKey,
      'itemName': itemName,
      'itemId': itemId,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'comment': comment,
      'priority': priority,
      'orderLineItemsOptions':
          orderLineItemsOptions?.map((x) => x?.toMap())?.toList(),
      'veg': veg,
    };
  }

  static OrderLineItems fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderLineItems(
      id: map['id'],
      personNum: map['personNum'],
      uniqueKey: map['uniqueKey'],
      itemName: map['itemName'],
      itemId: map['itemId'],
      unitPrice: map['unitPrice'],
      quantity: map['quantity'],
      comment: map['comment'],
      priority: map['priority'],
      orderLineItemsOptions: List<OrderLineItemsOptions>.from(
          map['orderLineItemsOptions']
              ?.map((x) => OrderLineItemsOptions.fromMap(x))),
      veg: map['veg'],
    );
  }

  String toJson() => json.encode(toMap());

  static OrderLineItems fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderLineItems(id: $id, personNum: $personNum, uniqueKey: $uniqueKey, itemName: $itemName, itemId: $itemId, unitPrice: $unitPrice, quantity: $quantity, comment: $comment, priority: $priority, orderLineItemsOptions: $orderLineItemsOptions, veg: $veg)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderLineItems &&
        o.id == id &&
        o.personNum == personNum &&
        o.uniqueKey == uniqueKey &&
        o.itemName == itemName &&
        o.itemId == itemId &&
        o.unitPrice == unitPrice &&
        o.quantity == quantity &&
        o.comment == comment &&
        o.priority == priority &&
        listEquals(o.orderLineItemsOptions, orderLineItemsOptions) &&
        o.veg == veg;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        personNum.hashCode ^
        uniqueKey.hashCode ^
        itemName.hashCode ^
        itemId.hashCode ^
        unitPrice.hashCode ^
        quantity.hashCode ^
        comment.hashCode ^
        priority.hashCode ^
        orderLineItemsOptions.hashCode ^
        veg.hashCode;
  }
}
