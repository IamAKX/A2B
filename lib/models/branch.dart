import 'dart:convert';

class BranchModel {
  String id;
  String name;
  String address;
  BranchModel({
    this.id,
    this.name,
    this.address,
  });

  BranchModel copyWith({
    String id,
    String name,
    String address,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }

  static BranchModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BranchModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  static BranchModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'BranchModel(id: $id, name: $name, address: $address)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BranchModel &&
        o.id == id &&
        o.name == name &&
        o.address == address;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ address.hashCode;
}
