import 'dart:convert';

class StoreHours {
  int id;
  String name;
  String description;
  StoreHours({
    this.id,
    this.name,
    this.description,
  });

  StoreHours copyWith({
    int id,
    String name,
    String description,
  }) {
    return StoreHours(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory StoreHours.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return StoreHours(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreHours.fromJson(String source) =>
      StoreHours.fromMap(json.decode(source));

  @override
  String toString() =>
      'StoreHours(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StoreHours &&
        o.id == id &&
        o.name == name &&
        o.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
