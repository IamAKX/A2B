import 'dart:convert';

class TipValue {
  int id;
  String name;
  String description;
  double value;
  TipValue({
    this.id,
    this.name,
    this.description,
    this.value,
  });

  TipValue copyWith({
    int id,
    String name,
    String description,
    double value,
  }) {
    return TipValue(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'value': value,
    };
  }

  static TipValue fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TipValue(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  static TipValue fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'TipValue(id: $id, name: $name, description: $description, value: $value)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TipValue &&
        o.id == id &&
        o.name == name &&
        o.description == description &&
        o.value == value;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode ^ value.hashCode;
  }
}
