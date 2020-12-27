import 'dart:convert';

class OrderDetails {
  String text;
  String subText;
  OrderDetails({
    this.text,
    this.subText,
  });

  OrderDetails copyWith({
    String text,
    String subText,
  }) {
    return OrderDetails(
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

  factory OrderDetails.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderDetails(
      text: map['text'],
      subText: map['subText'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetails.fromJson(String source) =>
      OrderDetails.fromMap(json.decode(source));

  @override
  String toString() => 'OrderDetails(text: $text, subText: $subText)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderDetails && o.text == text && o.subText == subText;
  }

  @override
  int get hashCode => text.hashCode ^ subText.hashCode;
}
