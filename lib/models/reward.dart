import 'dart:convert';

import 'package:flutter/foundation.dart';

class Reward {
  String date;
  String reward;
  String rewardSubText;
  String details;
  List<String> received;
  Reward({
    this.date,
    this.reward,
    this.rewardSubText,
    this.details,
    this.received,
  });

  Reward copyWith({
    String date,
    String reward,
    String rewardSubText,
    String details,
    List<String> received,
  }) {
    return Reward(
      date: date ?? this.date,
      reward: reward ?? this.reward,
      rewardSubText: rewardSubText ?? this.rewardSubText,
      details: details ?? this.details,
      received: received ?? this.received,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'reward': reward,
      'rewardSubText': rewardSubText,
      'details': details,
      'received': received,
    };
  }

  factory Reward.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Reward(
      date: map['date'],
      reward: map['reward'],
      rewardSubText: map['rewardSubText'],
      details: map['details'],
      received: List<String>.from(map['received']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Reward.fromJson(String source) => Reward.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Reward(date: $date, reward: $reward, rewardSubText: $rewardSubText, details: $details, received: $received)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Reward &&
        o.date == date &&
        o.reward == reward &&
        o.rewardSubText == rewardSubText &&
        o.details == details &&
        listEquals(o.received, received);
  }

  @override
  int get hashCode {
    return date.hashCode ^
        reward.hashCode ^
        rewardSubText.hashCode ^
        details.hashCode ^
        received.hashCode;
  }
}
