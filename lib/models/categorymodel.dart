import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/fooditem.dart';

class CategoryModel {
  int id;
  String name;
  String image;
  bool active;
  CategoryModel({
    this.id,
    this.name,
    this.image,
    this.active,
  });


  CategoryModel copyWith({
    int id,
    String name,
    String image,
    bool active,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'active': active,
    };
  }

  static CategoryModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      active: map['active'],
    );
  }

  String toJson() => json.encode(toMap());

  static CategoryModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, image: $image, active: $active)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CategoryModel &&
      o.id == id &&
      o.name == name &&
      o.image == image &&
      o.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      active.hashCode;
  }
}
