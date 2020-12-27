import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/reward.dart';

class RewardHistoryModel {
  String year;
  List<Reward> rewardsHistory;
  RewardHistoryModel({
    this.year,
    this.rewardsHistory,
  });

  RewardHistoryModel copyWith({
    String year,
    List<Reward> rewardsHistory,
  }) {
    return RewardHistoryModel(
      year: year ?? this.year,
      rewardsHistory: rewardsHistory ?? this.rewardsHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'rewardsHistory': rewardsHistory?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory RewardHistoryModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RewardHistoryModel(
      year: map['year'],
      rewardsHistory: List<Reward>.from(
          map['rewardsHistory']?.map((x) => Reward.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory RewardHistoryModel.fromJson(String source) =>
      RewardHistoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'RewardHistoryModel(year: $year, rewardsHistory: $rewardsHistory)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RewardHistoryModel &&
        o.year == year &&
        listEquals(o.rewardsHistory, rewardsHistory);
  }

  @override
  int get hashCode => year.hashCode ^ rewardsHistory.hashCode;
}
