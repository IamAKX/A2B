import 'dart:convert';

import 'package:flutter/foundation.dart';

class OfferModel {
  int id;
  String promocode;
  String shortDescription;
  List<Details> details;
  OfferModel({
    this.id,
    this.promocode,
    this.shortDescription,
    this.details,
  });

  OfferModel copyWith({
    int id,
    String promocode,
    String shortDescription,
    List<Details> details,
  }) {
    return OfferModel(
      id: id ?? this.id,
      promocode: promocode ?? this.promocode,
      shortDescription: shortDescription ?? this.shortDescription,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'promocode': promocode,
      'shortDescription': shortDescription,
      'details': details?.map((x) => x?.toMap())?.toList(),
    };
  }

  static OfferModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OfferModel(
      id: map['id'],
      promocode: map['promocode'],
      shortDescription: map['shortDescription'],
      details:
          List<Details>.from(map['details']?.map((x) => Details.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static OfferModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'OfferModel(id: $id, promocode: $promocode, shortDescription: $shortDescription, details: $details)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OfferModel &&
        o.id == id &&
        o.promocode == promocode &&
        o.shortDescription == shortDescription &&
        listEquals(o.details, details);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        promocode.hashCode ^
        shortDescription.hashCode ^
        details.hashCode;
  }
}

class Details {
  String text;
  Details({
    this.text,
  });

  Details copyWith({
    String text,
  }) {
    return Details(
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }

  static Details fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Details(
      text: map['text'],
    );
  }

  String toJson() => json.encode(toMap());

  static Details fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Details(text: $text)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Details && o.text == text;
  }

  @override
  int get hashCode => text.hashCode;
}
