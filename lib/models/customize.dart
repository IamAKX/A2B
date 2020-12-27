import 'dart:convert';

class CustomizeModel {
  String title;
  double charge;
  CustomizeModel({
    this.title,
    this.charge,
  });

  CustomizeModel copyWith({
    String title,
    double charge,
  }) {
    return CustomizeModel(
      title: title ?? this.title,
      charge: charge ?? this.charge,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'charge': charge,
    };
  }

  static CustomizeModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CustomizeModel(
      title: map['title'],
      charge: map['charge'],
    );
  }

  String toJson() => json.encode(toMap());

  static CustomizeModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'CustomizeModel(title: $title, charge: $charge)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CustomizeModel && o.title == title && o.charge == charge;
  }

  @override
  int get hashCode => title.hashCode ^ charge.hashCode;
}
