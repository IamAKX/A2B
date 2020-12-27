import 'dart:convert';

class CartItemOption {
  int id;
  int optionId;
  String optionName;
  double optionPrice;
  String optionSetName;
  CartItemOption({
    this.id,
    this.optionId,
    this.optionName,
    this.optionPrice,
    this.optionSetName,
  });

  CartItemOption copyWith({
    int id,
    int optionId,
    String optionName,
    double optionPrice,
    String optionSetName,
  }) {
    return CartItemOption(
      id: id ?? this.id,
      optionId: optionId ?? this.optionId,
      optionName: optionName ?? this.optionName,
      optionPrice: optionPrice ?? this.optionPrice,
      optionSetName: optionSetName ?? this.optionSetName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'optionId': optionId,
      'optionName': optionName,
      'optionPrice': optionPrice,
      'optionSetName': optionSetName,
    };
  }

  static CartItemOption fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CartItemOption(
      id: map['id'],
      optionId: map['optionId'],
      optionName: map['optionName'],
      optionPrice: map['optionPrice'],
      optionSetName: map['optionSetName'],
    );
  }

  String toJson() => json.encode(toMap());

  static CartItemOption fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartItemOption(id: $id, optionId: $optionId, optionName: $optionName, optionPrice: $optionPrice, optionSetName: $optionSetName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CartItemOption &&
        o.id == id &&
        o.optionId == optionId &&
        o.optionName == optionName &&
        o.optionPrice == optionPrice &&
        o.optionSetName == optionSetName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        optionId.hashCode ^
        optionName.hashCode ^
        optionPrice.hashCode ^
        optionSetName.hashCode;
  }
}
