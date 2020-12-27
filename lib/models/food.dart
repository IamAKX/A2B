import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/customize.dart';

class FoodModel {
  String id;
  String name;
  String description;
  String image;
  double amount;
  int stock;
  List<CustomizeModel> customizationList;
  bool isVeg;
  String category;
  FoodModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.amount,
    this.stock,
    this.customizationList,
    this.isVeg,
    this.category,
  });

  FoodModel copyWith({
    String id,
    String name,
    String description,
    String image,
    double amount,
    int stock,
    List<CustomizeModel> customizationList,
    bool isVeg,
    String category,
  }) {
    return FoodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      amount: amount ?? this.amount,
      stock: stock ?? this.stock,
      customizationList: customizationList ?? this.customizationList,
      isVeg: isVeg ?? this.isVeg,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'amount': amount,
      'stock': stock,
      'customizationList': customizationList?.map((x) => x?.toMap())?.toList(),
      'isVeg': isVeg,
      'category': category,
    };
  }

  static FoodModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FoodModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
      amount: map['amount'],
      stock: map['stock'],
      customizationList: List<CustomizeModel>.from(
          map['customizationList']?.map((x) => CustomizeModel.fromMap(x))),
      isVeg: map['isVeg'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  static FoodModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'FoodModel(id: $id, name: $name, description: $description, image: $image, amount: $amount, stock: $stock, customizationList: $customizationList, isVeg: $isVeg, category: $category)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FoodModel &&
        o.id == id &&
        o.name == name &&
        o.description == description &&
        o.image == image &&
        o.amount == amount &&
        o.stock == stock &&
        listEquals(o.customizationList, customizationList) &&
        o.isVeg == isVeg &&
        o.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        amount.hashCode ^
        stock.hashCode ^
        customizationList.hashCode ^
        isVeg.hashCode ^
        category.hashCode;
  }
}
