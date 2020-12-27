import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/orderLineItems.dart';

class OrderModel {
  int id;
  String checkIn;
  String checkOut;
  List<OrderLineItems> orderLineItems;
  int orderType;
  int state;
  double netPrice;
  double discountValue;
  double customDiscountValue;
  double taxValue;
  double gratuityValue;
  double tipValue;
  double deliveryFee;
  String number;
  String instructions;
  String createDate;
  OrderModel({
    this.id,
    this.checkIn,
    this.checkOut,
    this.orderLineItems,
    this.orderType,
    this.state,
    this.netPrice,
    this.discountValue,
    this.customDiscountValue,
    this.taxValue,
    this.gratuityValue,
    this.tipValue,
    this.deliveryFee,
    this.number,
    this.instructions,
    this.createDate,
  });

  OrderModel copyWith({
    int id,
    String checkIn,
    String checkOut,
    List<OrderLineItems> orderLineItems,
    int orderType,
    int state,
    double netPrice,
    double discountValue,
    double customDiscountValue,
    double taxValue,
    double gratuityValue,
    double tipValue,
    double deliveryFee,
    String number,
    String instructions,
    String createDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      orderLineItems: orderLineItems ?? this.orderLineItems,
      orderType: orderType ?? this.orderType,
      state: state ?? this.state,
      netPrice: netPrice ?? this.netPrice,
      discountValue: discountValue ?? this.discountValue,
      customDiscountValue: customDiscountValue ?? this.customDiscountValue,
      taxValue: taxValue ?? this.taxValue,
      gratuityValue: gratuityValue ?? this.gratuityValue,
      tipValue: tipValue ?? this.tipValue,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      number: number ?? this.number,
      instructions: instructions ?? this.instructions,
      createDate: createDate ?? this.createDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'orderLineItems': orderLineItems?.map((x) => x?.toMap())?.toList(),
      'orderType': orderType,
      'state': state,
      'netPrice': netPrice,
      'discountValue': discountValue,
      'customDiscountValue': customDiscountValue,
      'taxValue': taxValue,
      'gratuityValue': gratuityValue,
      'tipValue': tipValue,
      'deliveryFee': deliveryFee,
      'number': number,
      'instructions': instructions,
      'createDate': createDate,
    };
  }

  static OrderModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderModel(
      id: map['id'],
      checkIn: map['checkIn'],
      checkOut: map['checkOut'],
      orderLineItems: List<OrderLineItems>.from(
          map['orderLineItems']?.map((x) => OrderLineItems.fromMap(x))),
      orderType: map['orderType'],
      state: map['state'],
      netPrice: map['netPrice'],
      discountValue: map['discountValue'],
      customDiscountValue: map['customDiscountValue'],
      taxValue: map['taxValue'],
      gratuityValue: map['gratuityValue'],
      tipValue: map['tipValue'],
      deliveryFee: map['deliveryFee'],
      number: map['number'],
      instructions: map['instructions'],
      createDate: map['createDate'],
    );
  }

  String toJson() => json.encode(toMap());

  static OrderModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(id: $id, checkIn: $checkIn, checkOut: $checkOut, orderLineItems: $orderLineItems, orderType: $orderType, state: $state, netPrice: $netPrice, discountValue: $discountValue, customDiscountValue: $customDiscountValue, taxValue: $taxValue, gratuityValue: $gratuityValue, tipValue: $tipValue, deliveryFee: $deliveryFee, number: $number, instructions: $instructions, createDate: $createDate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderModel &&
        o.id == id &&
        o.checkIn == checkIn &&
        o.checkOut == checkOut &&
        listEquals(o.orderLineItems, orderLineItems) &&
        o.orderType == orderType &&
        o.state == state &&
        o.netPrice == netPrice &&
        o.discountValue == discountValue &&
        o.customDiscountValue == customDiscountValue &&
        o.taxValue == taxValue &&
        o.gratuityValue == gratuityValue &&
        o.tipValue == tipValue &&
        o.deliveryFee == deliveryFee &&
        o.number == number &&
        o.instructions == instructions &&
        o.createDate == createDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        checkIn.hashCode ^
        checkOut.hashCode ^
        orderLineItems.hashCode ^
        orderType.hashCode ^
        state.hashCode ^
        netPrice.hashCode ^
        discountValue.hashCode ^
        customDiscountValue.hashCode ^
        taxValue.hashCode ^
        gratuityValue.hashCode ^
        tipValue.hashCode ^
        deliveryFee.hashCode ^
        number.hashCode ^
        instructions.hashCode ^
        createDate.hashCode;
  }
}
