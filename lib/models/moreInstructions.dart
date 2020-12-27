import 'dart:convert';

class MoreInstructions {
  String name;
  String description;
  int id;
  MoreInstructions({
    this.name,
    this.description,
    this.id,
  });

  MoreInstructions copyWith({
    String name,
    String description,
    int id,
  }) {
    return MoreInstructions(
      name: name ?? this.name,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'id': id,
    };
  }

  factory MoreInstructions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MoreInstructions(
      name: map['name'],
      description: map['description'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MoreInstructions.fromJson(String source) =>
      MoreInstructions.fromMap(json.decode(source));

  @override
  String toString() =>
      'MoreInstructions(name: $name, description: $description, id: $id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoreInstructions &&
        o.name == name &&
        o.description == description &&
        o.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ id.hashCode;
}
