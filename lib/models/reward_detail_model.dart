import 'dart:convert';

class RewardDetailModel {
  double points;
  double rewards;
  String description;
  RewardDetailModel({
    this.points,
    this.rewards,
    this.description,
  });

  RewardDetailModel copyWith({
    double points,
    double rewards,
    String description,
  }) {
    return RewardDetailModel(
      points: points ?? this.points,
      rewards: rewards ?? this.rewards,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'points': points,
      'rewards': rewards,
      'description': description,
    };
  }

  factory RewardDetailModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RewardDetailModel(
      points: map['points'],
      rewards: map['rewards'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RewardDetailModel.fromJson(String source) =>
      RewardDetailModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'RewardDetailModel(points: $points, rewards: $rewards, description: $description)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RewardDetailModel &&
        o.points == points &&
        o.rewards == rewards &&
        o.description == description;
  }

  @override
  int get hashCode => points.hashCode ^ rewards.hashCode ^ description.hashCode;
}
