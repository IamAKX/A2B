import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/availableDateTimings.dart';
import 'package:singlestore/models/displaycategories.dart';
import 'package:singlestore/models/messages.dart';
import 'package:singlestore/models/moreInstructions.dart';
import 'package:singlestore/models/offer.dart';
import 'package:singlestore/models/order.dart';
import 'package:singlestore/models/orderTypeInfoBox.dart';
import 'package:singlestore/models/tip.dart';
import 'package:singlestore/models/web_order.dart';
import 'package:singlestore/screens/Offer/offer.dart';

class PrepareOrderModel {
  WebOrder webOrder;
  DisplayCategories displayCategory;
  OfferModel appliedOffer;
  OrderDateTimes orderDateTimes;
  Tip tip;
  List<MoreInstructions> moreInstructions;
  String selectedOrderTypeName;
  OrderTypeInfoBox orderTypeInfoBox;
  List<Messages> messages;
  int selectedTipId;
  String submitButtonDisplayValue;
  bool toUpdateAccount;
  PrepareOrderModel({
    this.webOrder,
    this.displayCategory,
    this.appliedOffer,
    this.orderDateTimes,
    this.tip,
    this.moreInstructions,
    this.selectedOrderTypeName,
    this.orderTypeInfoBox,
    this.messages,
    this.selectedTipId,
    this.submitButtonDisplayValue,
    this.toUpdateAccount,
  });

  PrepareOrderModel copyWith({
    WebOrder webOrder,
    DisplayCategories displayCategory,
    OfferModel appliedOffer,
    OrderDateTimes orderDateTimes,
    Tip tip,
    List<MoreInstructions> moreInstructions,
    String selectedOrderTypeName,
    OrderTypeInfoBox orderTypeInfoBox,
    List<Messages> messages,
    int selectedTipId,
    String submitButtonDisplayValue,
    bool toUpdateAccount,
  }) {
    return PrepareOrderModel(
      webOrder: webOrder ?? this.webOrder,
      displayCategory: displayCategory ?? this.displayCategory,
      appliedOffer: appliedOffer ?? this.appliedOffer,
      orderDateTimes: orderDateTimes ?? this.orderDateTimes,
      tip: tip ?? this.tip,
      moreInstructions: moreInstructions ?? this.moreInstructions,
      selectedOrderTypeName:
          selectedOrderTypeName ?? this.selectedOrderTypeName,
      orderTypeInfoBox: orderTypeInfoBox ?? this.orderTypeInfoBox,
      messages: messages ?? this.messages,
      selectedTipId: selectedTipId ?? this.selectedTipId,
      submitButtonDisplayValue:
          submitButtonDisplayValue ?? this.submitButtonDisplayValue,
      toUpdateAccount: toUpdateAccount ?? this.toUpdateAccount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'webOrder': webOrder?.toMap(),
      'displayCategory': displayCategory?.toMap(),
      'appliedOffer': appliedOffer?.toMap(),
      'orderDateTimes': orderDateTimes?.toMap(),
      'tip': tip?.toMap(),
      'moreInstructions': moreInstructions?.map((x) => x?.toMap())?.toList(),
      'selectedOrderTypeName': selectedOrderTypeName,
      'orderTypeInfoBox': orderTypeInfoBox?.toMap(),
      'messages': messages?.map((x) => x?.toMap())?.toList(),
      'selectedTipId': selectedTipId,
      'submitButtonDisplayValue': submitButtonDisplayValue,
      'toUpdateAccount': toUpdateAccount,
    };
  }

  factory PrepareOrderModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PrepareOrderModel(
      webOrder: WebOrder.fromMap(map['webOrder']),
      displayCategory: DisplayCategories.fromMap(map['displayCategory']),
      appliedOffer: OfferModel.fromMap(map['appliedOffer']),
      orderDateTimes: OrderDateTimes.fromMap(map['orderDateTimes']),
      tip: Tip.fromMap(map['tip']),
      moreInstructions: List<MoreInstructions>.from(
          map['moreInstructions']?.map((x) => MoreInstructions.fromMap(x))),
      selectedOrderTypeName: map['selectedOrderTypeName'],
      orderTypeInfoBox: OrderTypeInfoBox.fromMap(map['orderTypeInfoBox']),
      messages:
          List<Messages>.from(map['messages']?.map((x) => Messages.fromMap(x))),
      selectedTipId: map['selectedTipId'],
      submitButtonDisplayValue: map['submitButtonDisplayValue'],
      toUpdateAccount: map['toUpdateAccount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PrepareOrderModel.fromJson(String source) =>
      PrepareOrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PrepareOrderModel(webOrder: $webOrder, displayCategory: $displayCategory, appliedOffer: $appliedOffer, orderDateTimes: $orderDateTimes, tip: $tip, moreInstructions: $moreInstructions, selectedOrderTypeName: $selectedOrderTypeName, orderTypeInfoBox: $orderTypeInfoBox, messages: $messages, selectedTipId: $selectedTipId, submitButtonDisplayValue: $submitButtonDisplayValue, toUpdateAccount: $toUpdateAccount)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PrepareOrderModel &&
        o.webOrder == webOrder &&
        o.displayCategory == displayCategory &&
        o.appliedOffer == appliedOffer &&
        o.orderDateTimes == orderDateTimes &&
        o.tip == tip &&
        listEquals(o.moreInstructions, moreInstructions) &&
        o.selectedOrderTypeName == selectedOrderTypeName &&
        o.orderTypeInfoBox == orderTypeInfoBox &&
        listEquals(o.messages, messages) &&
        o.selectedTipId == selectedTipId &&
        o.submitButtonDisplayValue == submitButtonDisplayValue &&
        o.toUpdateAccount == toUpdateAccount;
  }

  @override
  int get hashCode {
    return webOrder.hashCode ^
        displayCategory.hashCode ^
        appliedOffer.hashCode ^
        orderDateTimes.hashCode ^
        tip.hashCode ^
        moreInstructions.hashCode ^
        selectedOrderTypeName.hashCode ^
        orderTypeInfoBox.hashCode ^
        messages.hashCode ^
        selectedTipId.hashCode ^
        submitButtonDisplayValue.hashCode ^
        toUpdateAccount.hashCode;
  }
}
