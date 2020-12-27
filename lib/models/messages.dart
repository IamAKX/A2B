import 'dart:convert';

class Messages {
  String text;
  Messages({
    this.text,
  });

  Messages copyWith({
    String text,
  }) {
    return Messages(
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }

  static Messages fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Messages(
      text: map['text'],
    );
  }

  String toJson() => json.encode(toMap());

  static Messages fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Messages(text: $text)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Messages && o.text == text;
  }

  @override
  int get hashCode => text.hashCode;
}
