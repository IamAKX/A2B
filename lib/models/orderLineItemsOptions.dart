import 'dart:convert';

class OrderLineItemsOptions {
  int id;
  String optionSetName;
  int optionId;
  String optionName;
  double optionPrice;
  OrderLineItemsOptions({
    this.id,
    this.optionSetName,
    this.optionId,
    this.optionName,
    this.optionPrice,
  });

  OrderLineItemsOptions copyWith({
    int id,
    String optionSetName,
    int optionId,
    String optionName,
    double optionPrice,
  }) {
    return OrderLineItemsOptions(
      id: id ?? this.id,
      optionSetName: optionSetName ?? this.optionSetName,
      optionId: optionId ?? this.optionId,
      optionName: optionName ?? this.optionName,
      optionPrice: optionPrice ?? this.optionPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'optionSetName': optionSetName,
      'optionId': optionId,
      'optionName': optionName,
      'optionPrice': optionPrice,
    };
  }

  static OrderLineItemsOptions fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderLineItemsOptions(
      id: map['id'],
      optionSetName: map['optionSetName'],
      optionId: map['optionId'],
      optionName: map['optionName'],
      optionPrice: map['optionPrice'],
    );
  }

  String toJson() => json.encode(toMap());

  static OrderLineItemsOptions fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderLineItemsOptions(id: $id, optionSetName: $optionSetName, optionId: $optionId, optionName: $optionName, optionPrice: $optionPrice)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderLineItemsOptions &&
        o.id == id &&
        o.optionSetName == optionSetName &&
        o.optionId == optionId &&
        o.optionName == optionName &&
        o.optionPrice == optionPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        optionSetName.hashCode ^
        optionId.hashCode ^
        optionName.hashCode ^
        optionPrice.hashCode;
  }
}
