import 'dart:convert';

class StandardResponse {
  String status;
  dynamic data;
  String message;
  StandardResponse({
    this.status,
    this.data,
    this.message,
  });

  StandardResponse copyWith({
    String status,
    dynamic data,
    String message,
  }) {
    return StandardResponse(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data,
      'message': message,
    };
  }

  static StandardResponse fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return StandardResponse(
      status: map['status'],
      data: map['data'],
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  static StandardResponse fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'StandardResponse(status: $status, data: $data, message: $message)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StandardResponse &&
        o.status == status &&
        o.data == data &&
        o.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode ^ message.hashCode;
}
