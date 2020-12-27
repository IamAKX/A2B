import 'dart:convert';

class HomePageGimages {
  String name;
  String path;
  int cta;
  String target;
  bool active;
  HomePageGimages({
    this.name,
    this.path,
    this.cta,
    this.target,
    this.active,
  });

  HomePageGimages copyWith({
    String name,
    String path,
    int cta,
    String target,
    bool active,
  }) {
    return HomePageGimages(
      name: name ?? this.name,
      path: path ?? this.path,
      cta: cta ?? this.cta,
      target: target ?? this.target,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'path': path,
      'cta': cta,
      'target': target,
      'active': active,
    };
  }

  static HomePageGimages fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return HomePageGimages(
      name: map['name'],
      path: map['path'],
      cta: map['cta'],
      target: map['target'],
      active: map['active'],
    );
  }

  String toJson() => json.encode(toMap());

  static HomePageGimages fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'HomePageGimages(name: $name, path: $path, cta: $cta, target: $target, active: $active)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomePageGimages &&
        o.name == name &&
        o.path == path &&
        o.cta == cta &&
        o.target == target &&
        o.active == active;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        path.hashCode ^
        cta.hashCode ^
        target.hashCode ^
        active.hashCode;
  }
}
