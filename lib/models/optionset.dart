import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/optionsetitem.dart';

class OptionSet {
  int id;
  String name;
  bool mandatory;
  List<OptionSetItem> itemOptions;
  bool active;
  bool multiSelectable;
  OptionSet({
    this.id,
    this.name,
    this.mandatory,
    this.itemOptions,
    this.active,
    this.multiSelectable,
  });

  OptionSet copyWith({
    int id,
    String name,
    bool mandatory,
    List<OptionSetItem> itemOptions,
    bool active,
    bool multiSelectable,
  }) {
    return OptionSet(
      id: id ?? this.id,
      name: name ?? this.name,
      mandatory: mandatory ?? this.mandatory,
      itemOptions: itemOptions ?? this.itemOptions,
      active: active ?? this.active,
      multiSelectable: multiSelectable ?? this.multiSelectable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mandatory': mandatory,
      'itemOptions': itemOptions?.map((x) => x?.toMap())?.toList(),
      'active': active,
      'multiSelectable': multiSelectable,
    };
  }

  static OptionSet fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OptionSet(
      id: map['id'],
      name: map['name'],
      mandatory: map['mandatory'],
      itemOptions: List<OptionSetItem>.from(
          map['itemOptions']?.map((x) => OptionSetItem.fromMap(x))),
      active: map['active'],
      multiSelectable: map['multiSelectable'],
    );
  }

  String toJson() => json.encode(toMap());

  static OptionSet fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'OptionSet(id: $id, name: $name, mandatory: $mandatory, itemOptions: $itemOptions, active: $active, multiSelectable: $multiSelectable)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OptionSet &&
        o.id == id &&
        o.name == name &&
        o.mandatory == mandatory &&
        listEquals(o.itemOptions, itemOptions) &&
        o.active == active &&
        o.multiSelectable == multiSelectable;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        mandatory.hashCode ^
        itemOptions.hashCode ^
        active.hashCode ^
        multiSelectable.hashCode;
  }
}
