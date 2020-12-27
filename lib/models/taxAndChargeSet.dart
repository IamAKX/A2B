import 'dart:convert';

class TaxAndChargeSet {
  String name;
  String description;
  double value;
  TaxAndChargeSet({
    this.name,
    this.description,
    this.value,
  });

  TaxAndChargeSet copyWith({
    String name,
    String description,
    double value,
  }) {
    return TaxAndChargeSet(
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'value': value,
    };
  }

  static TaxAndChargeSet fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TaxAndChargeSet(
      name: map['name'],
      description: map['description'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  static TaxAndChargeSet fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'TaxAndChargeSet(name: $name, description: $description, value: $value)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TaxAndChargeSet &&
        o.name == name &&
        o.description == description &&
        o.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ value.hashCode;
}
