import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/fooditem.dart';

class MenuListModel {
  int id;
  List<FoodItem> items;
  String name;
  String image;
  bool active;
  MenuListModel({
    this.id,
    this.items,
    this.name,
    this.image,
    this.active,
  });

  MenuListModel copyWith({
    int id,
    List<FoodItem> items,
    String name,
    String image,
    bool active,
  }) {
    return MenuListModel(
      id: id ?? this.id,
      items: items ?? this.items,
      name: name ?? this.name,
      image: image ?? this.image,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items?.map((x) => x?.toMap())?.toList(),
      'name': name,
      'image': image,
      'active': active,
    };
  }

  static MenuListModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MenuListModel(
      id: map['id'],
      items: List<FoodItem>.from(map['items']?.map((x) => FoodItem.fromMap(x))),
      name: map['name'],
      image: map['image'],
      active: map['active'],
    );
  }

  String toJson() => json.encode(toMap());

  static MenuListModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'MenuListModel(id: $id, items: $items, name: $name, image: $image, active: $active)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MenuListModel &&
        o.id == id &&
        listEquals(o.items, items) &&
        o.name == name &&
        o.image == image &&
        o.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        items.hashCode ^
        name.hashCode ^
        image.hashCode ^
        active.hashCode;
  }
}
