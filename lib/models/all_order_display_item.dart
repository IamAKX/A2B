import 'dart:convert';

class DisplayOrders {
  int orderId;
  String orderNumber;
  int numberOfItems;
  String items;
  String orderedOn;
  double totalAmount;
  String orderStatus;
  String orderType;
  String reOrderMessage;
  bool reorderEnabled;
  DisplayOrders({
    this.orderId,
    this.orderNumber,
    this.numberOfItems,
    this.items,
    this.orderedOn,
    this.totalAmount,
    this.orderStatus,
    this.orderType,
    this.reOrderMessage,
    this.reorderEnabled,
  });

  DisplayOrders copyWith({
    int orderId,
    String orderNumber,
    int numberOfItems,
    String items,
    String orderedOn,
    double totalAmount,
    String orderStatus,
    String orderType,
    String reOrderMessage,
    bool reorderEnabled,
  }) {
    return DisplayOrders(
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      numberOfItems: numberOfItems ?? this.numberOfItems,
      items: items ?? this.items,
      orderedOn: orderedOn ?? this.orderedOn,
      totalAmount: totalAmount ?? this.totalAmount,
      orderStatus: orderStatus ?? this.orderStatus,
      orderType: orderType ?? this.orderType,
      reOrderMessage: reOrderMessage ?? this.reOrderMessage,
      reorderEnabled: reorderEnabled ?? this.reorderEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'orderNumber': orderNumber,
      'numberOfItems': numberOfItems,
      'items': items,
      'orderedOn': orderedOn,
      'totalAmount': totalAmount,
      'orderStatus': orderStatus,
      'orderType': orderType,
      'reOrderMessage': reOrderMessage,
      'reorderEnabled': reorderEnabled,
    };
  }

  factory DisplayOrders.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DisplayOrders(
      orderId: map['orderId'],
      orderNumber: map['orderNumber'],
      numberOfItems: map['numberOfItems'],
      items: map['items'],
      orderedOn: map['orderedOn'],
      totalAmount: map['totalAmount'],
      orderStatus: map['orderStatus'],
      orderType: map['orderType'],
      reOrderMessage: map['reOrderMessage'],
      reorderEnabled: map['reorderEnabled'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DisplayOrders.fromJson(String source) =>
      DisplayOrders.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DisplayOrders(orderId: $orderId, orderNumber: $orderNumber, numberOfItems: $numberOfItems, items: $items, orderedOn: $orderedOn, totalAmount: $totalAmount, orderStatus: $orderStatus, orderType: $orderType, reOrderMessage: $reOrderMessage, reorderEnabled: $reorderEnabled)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DisplayOrders &&
        o.orderId == orderId &&
        o.orderNumber == orderNumber &&
        o.numberOfItems == numberOfItems &&
        o.items == items &&
        o.orderedOn == orderedOn &&
        o.totalAmount == totalAmount &&
        o.orderStatus == orderStatus &&
        o.orderType == orderType &&
        o.reOrderMessage == reOrderMessage &&
        o.reorderEnabled == reorderEnabled;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        orderNumber.hashCode ^
        numberOfItems.hashCode ^
        items.hashCode ^
        orderedOn.hashCode ^
        totalAmount.hashCode ^
        orderStatus.hashCode ^
        orderType.hashCode ^
        reOrderMessage.hashCode ^
        reorderEnabled.hashCode;
  }
}
