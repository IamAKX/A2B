import 'dart:convert';

class CartPaymentValidation {
  String instructions;
  String moreInstructionIds;
  String requiredTimings;
  CartPaymentValidation({
    this.instructions,
    this.moreInstructionIds,
    this.requiredTimings,
  });

  CartPaymentValidation copyWith({
    String instructions,
    String moreInstructionIds,
    String requiredTimings,
  }) {
    return CartPaymentValidation(
      instructions: instructions ?? this.instructions,
      moreInstructionIds: moreInstructionIds ?? this.moreInstructionIds,
      requiredTimings: requiredTimings ?? this.requiredTimings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'instructions': instructions,
      'moreInstructionIds': moreInstructionIds,
      'requiredTimings': requiredTimings,
    };
  }

  factory CartPaymentValidation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CartPaymentValidation(
      instructions: map['instructions'],
      moreInstructionIds: map['moreInstructionIds'],
      requiredTimings: map['requiredTimings'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartPaymentValidation.fromJson(String source) =>
      CartPaymentValidation.fromMap(json.decode(source));

  @override
  String toString() =>
      'CartPaymentValidation(instructions: $instructions, moreInstructionIds: $moreInstructionIds, requiredTimings: $requiredTimings)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CartPaymentValidation &&
        o.instructions == instructions &&
        o.moreInstructionIds == moreInstructionIds &&
        o.requiredTimings == requiredTimings;
  }

  @override
  int get hashCode =>
      instructions.hashCode ^
      moreInstructionIds.hashCode ^
      requiredTimings.hashCode;
}
