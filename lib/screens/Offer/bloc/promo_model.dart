import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/offer.dart';
import 'package:singlestore/screens/Offer/offer.dart';

class PromoModel {
  List<OfferModel> promos;
  PromoModel({
    this.promos,
  });

  PromoModel copyWith({
    List<OfferModel> promos,
  }) {
    return PromoModel(
      promos: promos ?? this.promos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'promos': promos?.map((x) => x?.toMap())?.toList(),
    };
  }

  static PromoModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PromoModel(
      promos: List<OfferModel>.from(
          map['promos']?.map((x) => OfferModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static PromoModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'PromoModel(promos: $promos)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PromoModel && listEquals(o.promos, promos);
  }

  @override
  int get hashCode => promos.hashCode;
}
