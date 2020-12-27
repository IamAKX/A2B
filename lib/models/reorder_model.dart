import 'dart:convert';

import 'package:singlestore/models/web_order.dart';

class ReOrderModel {
  WebOrder webOrder;
  ReOrderModel({
    this.webOrder,
  });

  ReOrderModel copyWith({
    WebOrder webOrder,
  }) {
    return ReOrderModel(
      webOrder: webOrder ?? this.webOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'webOrder': webOrder?.toMap(),
    };
  }

  factory ReOrderModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReOrderModel(
      webOrder: WebOrder.fromMap(map['webOrder']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReOrderModel.fromJson(String source) =>
      ReOrderModel.fromMap(json.decode(source));

  @override
  String toString() => 'ReOrderModel(webOrder: $webOrder)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ReOrderModel && o.webOrder == webOrder;
  }

  @override
  int get hashCode => webOrder.hashCode;
}
