import 'dart:convert';

class Greferral {
  String code;
  String shortDescription;
  String longDescription;
  String message;
  String policyUrl;
  Greferral({
    this.code,
    this.shortDescription,
    this.longDescription,
    this.message,
    this.policyUrl,
  });

  Greferral copyWith({
    String code,
    String shortDescription,
    String longDescription,
    String message,
    String policyUrl,
  }) {
    return Greferral(
      code: code ?? this.code,
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      message: message ?? this.message,
      policyUrl: policyUrl ?? this.policyUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'message': message,
      'policyUrl': policyUrl,
    };
  }

  static Greferral fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Greferral(
      code: map['code'],
      shortDescription: map['shortDescription'],
      longDescription: map['longDescription'],
      message: map['message'],
      policyUrl: map['policyUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  static Greferral fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Greferral(code: $code, shortDescription: $shortDescription, longDescription: $longDescription, message: $message, policyUrl: $policyUrl)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Greferral &&
        o.code == code &&
        o.shortDescription == shortDescription &&
        o.longDescription == longDescription &&
        o.message == message &&
        o.policyUrl == policyUrl;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        shortDescription.hashCode ^
        longDescription.hashCode ^
        message.hashCode ^
        policyUrl.hashCode;
  }
}
