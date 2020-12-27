import 'dart:convert';

class OptionSetItem {
  int id;
  String name;
  double price;
  bool active;
  OptionSetItem({
    this.id,
    this.name,
    this.price,
    this.active,
  });

  OptionSetItem copyWith({
    int id,
    String name,
    double price,
    bool active,
  }) {
    return OptionSetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'active': active,
    };
  }

  static OptionSetItem fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OptionSetItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      active: map['active'],
    );
  }

  String toJson() => json.encode(toMap());

  static OptionSetItem fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'OptionSetItem(id: $id, name: $name, price: $price, active: $active)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OptionSetItem &&
        o.id == id &&
        o.name == name &&
        o.price == price &&
        o.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ price.hashCode ^ active.hashCode;
  }
}
