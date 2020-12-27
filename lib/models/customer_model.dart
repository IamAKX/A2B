import 'dart:convert';

class CustomerDetailsModel {
  String mobileNo;
  String fullName;
  String emailId;
  String storeKey;
  bool mobileVerified;
  bool emailVerified;
  CustomerDetailsModel({
    this.mobileNo,
    this.fullName,
    this.emailId,
    this.storeKey,
    this.mobileVerified,
    this.emailVerified,
  });

  CustomerDetailsModel copyWith({
    String mobileNo,
    String fullName,
    String emailId,
    String storeKey,
    bool mobileVerified,
    bool emailVerified,
  }) {
    return CustomerDetailsModel(
      mobileNo: mobileNo ?? this.mobileNo,
      fullName: fullName ?? this.fullName,
      emailId: emailId ?? this.emailId,
      storeKey: storeKey ?? this.storeKey,
      mobileVerified: mobileVerified ?? this.mobileVerified,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mobileNo': mobileNo,
      'fullName': fullName,
      'emailId': emailId,
      'storeKey': storeKey,
      'mobileVerified': mobileVerified,
      'emailVerified': emailVerified,
    };
  }

  factory CustomerDetailsModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CustomerDetailsModel(
      mobileNo: map['mobileNo'],
      fullName: map['fullName'],
      emailId: map['emailId'],
      storeKey: map['storeKey'],
      mobileVerified: map['mobileVerified'],
      emailVerified: map['emailVerified'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerDetailsModel.fromJson(String source) =>
      CustomerDetailsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CustomerDetailsModel(mobileNo: $mobileNo, fullName: $fullName, emailId: $emailId, storeKey: $storeKey, mobileVerified: $mobileVerified, emailVerified: $emailVerified)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CustomerDetailsModel &&
        o.mobileNo == mobileNo &&
        o.fullName == fullName &&
        o.emailId == emailId &&
        o.storeKey == storeKey &&
        o.mobileVerified == mobileVerified &&
        o.emailVerified == emailVerified;
  }

  @override
  int get hashCode {
    return mobileNo.hashCode ^
        fullName.hashCode ^
        emailId.hashCode ^
        storeKey.hashCode ^
        mobileVerified.hashCode ^
        emailVerified.hashCode;
  }
}
