import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/tip_value.dart';

class Tip {
  String name;
  String description;
  List<TipValue> values;
  Tip({
    this.name,
    this.description,
    this.values,
  });

  Tip copyWith({
    String name,
    String description,
    List<TipValue> values,
  }) {
    return Tip(
      name: name ?? this.name,
      description: description ?? this.description,
      values: values ?? this.values,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'values': values?.map((x) => x?.toMap())?.toList(),
    };
  }

  static Tip fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Tip(
      name: map['name'],
      description: map['description'],
      values:
          List<TipValue>.from(map['values']?.map((x) => TipValue.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static Tip fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() =>
      'Tip(name: $name, description: $description, values: $values)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Tip &&
        o.name == name &&
        o.description == description &&
        listEquals(o.values, values);
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ values.hashCode;
}
