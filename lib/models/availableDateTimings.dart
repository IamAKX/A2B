import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:singlestore/models/availableDateTimingsItem.dart';

class OrderDateTimes {
  bool nowAvailable;
  List<AvailableDateTimings> availableDateTimings;
  List<String> commonDateTimings;
  OrderDateTimes({
    this.nowAvailable,
    this.availableDateTimings,
    this.commonDateTimings,
  });

  OrderDateTimes copyWith({
    bool nowAvailable,
    List<AvailableDateTimings> availableDateTimings,
    List<String> commonDateTimings,
  }) {
    return OrderDateTimes(
      nowAvailable: nowAvailable ?? this.nowAvailable,
      availableDateTimings: availableDateTimings ?? this.availableDateTimings,
      commonDateTimings: commonDateTimings ?? this.commonDateTimings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nowAvailable': nowAvailable,
      'availableDateTimings':
          availableDateTimings?.map((x) => x?.toMap())?.toList(),
      'commonDateTimings': commonDateTimings,
    };
  }

  factory OrderDateTimes.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderDateTimes(
      nowAvailable: map['nowAvailable'],
      availableDateTimings: List<AvailableDateTimings>.from(
          map['availableDateTimings']
              ?.map((x) => AvailableDateTimings.fromMap(x))),
      commonDateTimings: List<String>.from(map['commonDateTimings']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDateTimes.fromJson(String source) =>
      OrderDateTimes.fromMap(json.decode(source));

  @override
  String toString() =>
      'OrderDateTimes(nowAvailable: $nowAvailable, availableDateTimings: $availableDateTimings, commonDateTimings: $commonDateTimings)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is OrderDateTimes &&
        o.nowAvailable == nowAvailable &&
        listEquals(o.availableDateTimings, availableDateTimings) &&
        listEquals(o.commonDateTimings, commonDateTimings);
  }

  @override
  int get hashCode =>
      nowAvailable.hashCode ^
      availableDateTimings.hashCode ^
      commonDateTimings.hashCode;
}
