import 'dart:convert';

class AvailableOrderTypes {
  int id;
  String value;
  AvailableOrderTypes({
    this.id,
    this.value,
  });

  AvailableOrderTypes copyWith({
    int id,
    String value,
  }) {
    return AvailableOrderTypes(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
    };
  }

  static AvailableOrderTypes fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AvailableOrderTypes(
      id: map['id'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  static AvailableOrderTypes fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'AvailableOrderTypes(id: $id, value: $value)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AvailableOrderTypes && o.id == id && o.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}
