import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/order.dart';
import 'package:singlestore/models/order_dtails.dart';

class OrderSummaryModel {
  OrderModel order;
  String orderStatusMessage;
  List<OrderDetails> orderDetails;
  String storeName;
  String storeAddress;
  String phoneNumber;
  String reOrderMessage;
  OrderSummaryModel({
    this.order,
    this.orderStatusMessage,
    this.orderDetails,
    this.storeName,
    this.storeAddress,
    this.phoneNumber,
    this.reOrderMessage,
  });

  OrderSummaryModel copyWith({
    OrderModel order,
    String orderStatusMessage,
    List<OrderDetails> orderDetails,
    String storeName,
    String storeAddress,
    String phoneNumber,
    String reOrderMessage,
  }) {
    return OrderSummaryModel(
      order: order ?? this.order,
      orderStatusMessage: orderStatusMessage ?? this.orderStatusMessage,
      orderDetails: orderDetails ?? this.orderDetails,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      reOrderMessage: reOrderMessage ?? this.reOrderMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order?.toMap(),
      'orderStatusMessage': orderStatusMessage,
      'orderDetails': orderDetails?.map((x) => x?.toMap())?.toList(),
      'storeName': storeName,
      'storeAddress': storeAddress,
      'phoneNumber': phoneNumber,
      'reOrderMessage': reOrderMessage,
    };
  }

  factory OrderSummaryModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderSummaryModel(
      order: OrderModel.fromMap(map['order']),
      orderStatusMessage: map['orderStatusMessage'],
      orderDetails: List<OrderDetails>.from(
          map['orderDetails']?.map((x) => OrderDetails.fromMap(x))),
      storeName: map['storeName'],
      storeAddress: map['storeAddress'],
      phoneNumber: map['phoneNumber'],
      reOrderMessage: map['reOrderMessage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderSummaryModel.fromJson(String source) =>
      OrderSummaryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderSummaryModel(order: $order, orderStatusMessage: $orderStatusMessage, orderDetails: $orderDetails, storeName: $storeName, storeAddress: $storeAddress, phoneNumber: $phoneNumber, reOrderMessage: $reOrderMessage)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderSummaryModel &&
        o.order == order &&
        o.orderStatusMessage == orderStatusMessage &&
        listEquals(o.orderDetails, orderDetails) &&
        o.storeName == storeName &&
        o.storeAddress == storeAddress &&
        o.phoneNumber == phoneNumber &&
        o.reOrderMessage == reOrderMessage;
  }

  @override
  int get hashCode {
    return order.hashCode ^
        orderStatusMessage.hashCode ^
        orderDetails.hashCode ^
        storeName.hashCode ^
        storeAddress.hashCode ^
        phoneNumber.hashCode ^
        reOrderMessage.hashCode;
  }
}
