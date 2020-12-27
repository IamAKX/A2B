import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/homePageGimages.dart';

class GimageBlocks {
  String heading;
  int heightInPx;
  List<HomePageGimages> gimages;
  GimageBlocks({
    this.heading,
    this.heightInPx,
    this.gimages,
  });

  GimageBlocks copyWith({
    String heading,
    int heightInPx,
    List<HomePageGimages> gimages,
  }) {
    return GimageBlocks(
      heading: heading ?? this.heading,
      heightInPx: heightInPx ?? this.heightInPx,
      gimages: gimages ?? this.gimages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'heading': heading,
      'heightInPx': heightInPx,
      'gimages': gimages?.map((x) => x?.toMap())?.toList(),
    };
  }

  static GimageBlocks fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GimageBlocks(
      heading: map['heading'],
      heightInPx: map['heightInPx'],
      gimages: List<HomePageGimages>.from(
          map['gimages']?.map((x) => HomePageGimages.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static GimageBlocks fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() =>
      'GimageBlocks(heading: $heading, heightInPx: $heightInPx, gimages: $gimages)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GimageBlocks &&
        o.heading == heading &&
        o.heightInPx == heightInPx &&
        listEquals(o.gimages, gimages);
  }

  @override
  int get hashCode => heading.hashCode ^ heightInPx.hashCode ^ gimages.hashCode;
}
