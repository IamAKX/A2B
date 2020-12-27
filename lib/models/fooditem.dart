import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/optionset.dart';

class FoodItem {
  int id;
  String name;
  int priceType;
  double price;
  double originalPrice;
  int priceUOM;
  String comments;
  String image;
  String shortDesc;
  bool active;
  bool manageStock;
  double stockQuantity;
  List<OptionSet> optionSets;
  bool veg;
  FoodItem({
    this.id,
    this.name,
    this.priceType,
    this.price,
    this.originalPrice,
    this.priceUOM,
    this.comments,
    this.image,
    this.shortDesc,
    this.active,
    this.manageStock,
    this.stockQuantity,
    this.optionSets,
    this.veg,
  });

  FoodItem copyWith({
    int id,
    String name,
    int priceType,
    double price,
    double originalPrice,
    int priceUOM,
    String comments,
    String image,
    String shortDesc,
    bool active,
    bool manageStock,
    double stockQuantity,
    List<OptionSet> optionSets,
    bool veg,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      priceType: priceType ?? this.priceType,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      priceUOM: priceUOM ?? this.priceUOM,
      comments: comments ?? this.comments,
      image: image ?? this.image,
      shortDesc: shortDesc ?? this.shortDesc,
      active: active ?? this.active,
      manageStock: manageStock ?? this.manageStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      optionSets: optionSets ?? this.optionSets,
      veg: veg ?? this.veg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priceType': priceType,
      'price': price,
      'originalPrice': originalPrice,
      'priceUOM': priceUOM,
      'comments': comments,
      'image': image,
      'shortDesc': shortDesc,
      'active': active,
      'manageStock': manageStock,
      'stockQuantity': stockQuantity,
      'optionSets': optionSets?.map((x) => x?.toMap())?.toList(),
      'veg': veg,
    };
  }

  static FoodItem fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FoodItem(
      id: map['id'],
      name: map['name'],
      priceType: map['priceType'],
      price: map['price'],
      originalPrice: map['originalPrice'],
      priceUOM: map['priceUOM'],
      comments: map['comments'],
      image: map['image'],
      shortDesc: map['shortDesc'],
      active: map['active'],
      manageStock: map['manageStock'],
      stockQuantity: map['stockQuantity'],
      optionSets: List<OptionSet>.from(
          map['optionSets']?.map((x) => OptionSet.fromMap(x))),
      veg: map['veg'],
    );
  }

  String toJson() => json.encode(toMap());

  static FoodItem fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, priceType: $priceType, price: $price, originalPrice: $originalPrice, priceUOM: $priceUOM, comments: $comments, image: $image, shortDesc: $shortDesc, active: $active, manageStock: $manageStock, stockQuantity: $stockQuantity, optionSets: $optionSets, veg: $veg)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FoodItem &&
        o.id == id &&
        o.name == name &&
        o.priceType == priceType &&
        o.price == price &&
        o.originalPrice == originalPrice &&
        o.priceUOM == priceUOM &&
        o.comments == comments &&
        o.image == image &&
        o.shortDesc == shortDesc &&
        o.active == active &&
        o.manageStock == manageStock &&
        o.stockQuantity == stockQuantity &&
        listEquals(o.optionSets, optionSets) &&
        o.veg == veg;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        priceType.hashCode ^
        price.hashCode ^
        originalPrice.hashCode ^
        priceUOM.hashCode ^
        comments.hashCode ^
        image.hashCode ^
        shortDesc.hashCode ^
        active.hashCode ^
        manageStock.hashCode ^
        stockQuantity.hashCode ^
        optionSets.hashCode ^
        veg.hashCode;
  }
}
