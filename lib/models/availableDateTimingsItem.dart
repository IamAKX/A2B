import 'dart:convert';

import 'package:flutter/foundation.dart';

class AvailableDateTimings {
  String date;
  bool useCommonTimings;
  List<String> timings;
  AvailableDateTimings({
    this.date,
    this.useCommonTimings,
    this.timings,
  });

  AvailableDateTimings copyWith({
    String date,
    bool useCommonTimings,
    List<String> timings,
  }) {
    return AvailableDateTimings(
      date: date ?? this.date,
      useCommonTimings: useCommonTimings ?? this.useCommonTimings,
      timings: timings ?? this.timings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'useCommonTimings': useCommonTimings,
      'timings': timings,
    };
  }

  static AvailableDateTimings fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AvailableDateTimings(
      date: map['date'],
      useCommonTimings: map['useCommonTimings'],
      timings: List<String>.from(map['timings']),
    );
  }

  String toJson() => json.encode(toMap());

  static AvailableDateTimings fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'AvailableDateTimingsItem(date: $date, useCommonTimings: $useCommonTimings, timings: $timings)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AvailableDateTimings &&
        o.date == date &&
        o.useCommonTimings == useCommonTimings &&
        listEquals(o.timings, timings);
  }

  @override
  int get hashCode =>
      date.hashCode ^ useCommonTimings.hashCode ^ timings.hashCode;
}
