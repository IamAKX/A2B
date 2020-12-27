import 'dart:convert';

class OrderTypeInfoBox {
  String text;
  String subText;
  OrderTypeInfoBox({
    this.text,
    this.subText,
  });

  OrderTypeInfoBox copyWith({
    String text,
    String subText,
  }) {
    return OrderTypeInfoBox(
      text: text ?? this.text,
      subText: subText ?? this.subText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'subText': subText,
    };
  }

  static OrderTypeInfoBox fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderTypeInfoBox(
      text: map['text'],
      subText: map['subText'],
    );
  }

  String toJson() => json.encode(toMap());

  static OrderTypeInfoBox fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'OrderTypeInfoBox(text: $text, subText: $subText)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderTypeInfoBox && o.text == text && o.subText == subText;
  }

  @override
  int get hashCode => text.hashCode ^ subText.hashCode;
}
