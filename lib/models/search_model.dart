import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/fooditem.dart';

class SearchModel {
  List<FoodItem> res;
  SearchModel({
    this.res,
  });

  SearchModel copyWith({
    List<FoodItem> res,
  }) {
    return SearchModel(
      res: res ?? this.res,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'res': res?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SearchModel(
      res: List<FoodItem>.from(map['res']?.map((x) => FoodItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchModel.fromJson(String source) =>
      SearchModel.fromMap(json.decode(source));

  @override
  String toString() => 'SearchModel(res: $res)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SearchModel && listEquals(o.res, res);
  }

  @override
  int get hashCode => res.hashCode;
}
