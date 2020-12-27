import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:singlestore/models/CategoryModel.dart';
import 'package:singlestore/models/availableOrderTypes.dart';
import 'package:singlestore/models/displaycategories.dart';
import 'package:singlestore/models/gimageblocks.dart';
import 'package:singlestore/models/greferral.dart';
import 'package:singlestore/models/grewards.dart';
import 'package:singlestore/models/homePageGimages.dart';
import 'package:singlestore/models/notificationGimages.dart';
import 'package:singlestore/models/offer.dart';
import 'package:singlestore/models/order.dart';
import 'package:singlestore/models/store.dart';

class HomeContainerModel {
  List<HomePageGimages> homePageGimages;
  Store store;
  Grewards grewards;
  Greferral greferral;
  List<NotificationGimages> notificationGimages;
  List<CategoryModel> allCategoriesWithoutItems;
  List<DisplayCategories> displayCategories;
  List<GimageBlocks> gimageBlocks;
  List<NotificationGimages> advertisements;
  OrderModel order;
  List<OfferModel> offers;
  List<AvailableOrderTypes> availableOrderTypes;
  HomeContainerModel({
    this.homePageGimages,
    this.store,
    this.grewards,
    this.greferral,
    this.notificationGimages,
    this.allCategoriesWithoutItems,
    this.displayCategories,
    this.gimageBlocks,
    this.advertisements,
    this.order,
    this.offers,
    this.availableOrderTypes,
  });

  HomeContainerModel copyWith({
    List<HomePageGimages> homePageGimages,
    Store store,
    Grewards grewards,
    Greferral greferral,
    List<NotificationGimages> notificationGimages,
    List<CategoryModel> allCategoriesWithoutItems,
    List<DisplayCategories> displayCategories,
    List<GimageBlocks> gimageBlocks,
    List<NotificationGimages> advertisements,
    OrderModel order,
    List<OfferModel> offers,
    List<AvailableOrderTypes> availableOrderTypes,
  }) {
    return HomeContainerModel(
      homePageGimages: homePageGimages ?? this.homePageGimages,
      store: store ?? this.store,
      grewards: grewards ?? this.grewards,
      greferral: greferral ?? this.greferral,
      notificationGimages: notificationGimages ?? this.notificationGimages,
      allCategoriesWithoutItems:
          allCategoriesWithoutItems ?? this.allCategoriesWithoutItems,
      displayCategories: displayCategories ?? this.displayCategories,
      gimageBlocks: gimageBlocks ?? this.gimageBlocks,
      advertisements: advertisements ?? this.advertisements,
      order: order ?? this.order,
      offers: offers ?? this.offers,
      availableOrderTypes: availableOrderTypes ?? this.availableOrderTypes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'homePageGimages': homePageGimages?.map((x) => x?.toMap())?.toList(),
      'store': store?.toMap(),
      'grewards': grewards?.toMap(),
      'greferral': greferral?.toMap(),
      'notificationGimages':
          notificationGimages?.map((x) => x?.toMap())?.toList(),
      'allCategoriesWithoutItems':
          allCategoriesWithoutItems?.map((x) => x?.toMap())?.toList(),
      'displayCategories': displayCategories?.map((x) => x?.toMap())?.toList(),
      'gimageBlocks': gimageBlocks?.map((x) => x?.toMap())?.toList(),
      'advertisements': advertisements?.map((x) => x?.toMap())?.toList(),
      'order': order?.toMap(),
      'offers': offers?.map((x) => x?.toMap())?.toList(),
      'availableOrderTypes':
          availableOrderTypes?.map((x) => x?.toMap())?.toList(),
    };
  }

  static HomeContainerModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return HomeContainerModel(
      homePageGimages: List<HomePageGimages>.from(
          map['homePageGimages']?.map((x) => HomePageGimages.fromMap(x))),
      store: Store.fromMap(map['store']),
      grewards: Grewards.fromMap(map['grewards']),
      greferral: Greferral.fromMap(map['greferral']),
      notificationGimages: List<NotificationGimages>.from(
          map['notificationGimages']
              ?.map((x) => NotificationGimages.fromMap(x))),
      allCategoriesWithoutItems: List<CategoryModel>.from(
          map['allCategoriesWithoutItems']
              ?.map((x) => CategoryModel.fromMap(x))),
      displayCategories: List<DisplayCategories>.from(
          map['displayCategories']?.map((x) => DisplayCategories.fromMap(x))),
      gimageBlocks: List<GimageBlocks>.from(
          map['gimageBlocks']?.map((x) => GimageBlocks.fromMap(x))),
      advertisements: List<NotificationGimages>.from(
          map['advertisements']?.map((x) => NotificationGimages.fromMap(x))),
      order: OrderModel.fromMap(map['order']),
      offers: List<OfferModel>.from(
          map['offers']?.map((x) => OfferModel.fromMap(x))),
      availableOrderTypes: List<AvailableOrderTypes>.from(
          map['availableOrderTypes']
              ?.map((x) => AvailableOrderTypes.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static HomeContainerModel fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'HomeContainerModel(homePageGimages: $homePageGimages, store: $store, grewards: $grewards, greferral: $greferral, notificationGimages: $notificationGimages, allCategoriesWithoutItems: $allCategoriesWithoutItems, displayCategories: $displayCategories, gimageBlocks: $gimageBlocks, advertisements: $advertisements, order: $order, offers: $offers, availableOrderTypes: $availableOrderTypes)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeContainerModel &&
        listEquals(o.homePageGimages, homePageGimages) &&
        o.store == store &&
        o.grewards == grewards &&
        o.greferral == greferral &&
        listEquals(o.notificationGimages, notificationGimages) &&
        listEquals(o.allCategoriesWithoutItems, allCategoriesWithoutItems) &&
        listEquals(o.displayCategories, displayCategories) &&
        listEquals(o.gimageBlocks, gimageBlocks) &&
        listEquals(o.advertisements, advertisements) &&
        o.order == order &&
        listEquals(o.offers, offers) &&
        listEquals(o.availableOrderTypes, availableOrderTypes);
  }

  @override
  int get hashCode {
    return homePageGimages.hashCode ^
        store.hashCode ^
        grewards.hashCode ^
        greferral.hashCode ^
        notificationGimages.hashCode ^
        allCategoriesWithoutItems.hashCode ^
        displayCategories.hashCode ^
        gimageBlocks.hashCode ^
        advertisements.hashCode ^
        order.hashCode ^
        offers.hashCode ^
        availableOrderTypes.hashCode;
  }
}
