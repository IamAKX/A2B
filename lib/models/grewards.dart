import 'dart:convert';

class Grewards {
  String name;
  double value;
  Grewards({
    this.name,
    this.value,
  });

  Grewards copyWith({
    String name,
    double value,
  }) {
    return Grewards(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
    };
  }

  static Grewards fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Grewards(
      name: map['name'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  static Grewards fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Grewards(name: $name, value: $value)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Grewards && o.name == name && o.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
