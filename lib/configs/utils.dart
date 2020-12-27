import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/constants.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/cart_item_option_model.dart';
import 'package:singlestore/models/cart_save.dart';
import 'package:singlestore/models/customize.dart';
import 'package:singlestore/models/displaycategories.dart';
import 'package:singlestore/models/food.dart';
import 'package:singlestore/models/fooditem.dart';
import 'package:singlestore/models/homePageGimages.dart';
import 'package:singlestore/models/optionset.dart';
import 'package:singlestore/models/optionsetitem.dart';
import 'package:singlestore/models/order.dart';
import 'package:singlestore/models/orderLineItems.dart';
import 'package:singlestore/models/orderLineItemsOptions.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';

getCartItemFromOrderLineItem(OrderLineItems oli) {
  CartItem c = CartItem(
      itemId: oli.itemId,
      itemName: oli.itemName,
      personNum: oli.personNum,
      priority: oli.priority,
      quantity: oli.quantity.toInt(),
      uniqueKey: oli.uniqueKey,
      unitPrice: oli.unitPrice,
      veg: oli.veg);

  c.orderLineItemsOptions = [];
  for (OrderLineItemsOptions olio in oli.orderLineItemsOptions) {
    CartItemOption cio = CartItemOption(
        // id: olio.id,
        optionId: olio.optionId,
        optionName: olio.optionName,
        optionPrice: olio.optionPrice,
        optionSetName: olio.optionSetName);

    c.orderLineItemsOptions.add(cio);
  }

  return c;
}

getCartItemFromFoodItem(FoodItem f) {
  CartItem c = CartItem();
  c.itemId = f.id;
  c.itemName = f.name;
  c.quantity = 1;
  c.unitPrice = f.price;
  c.veg = f.veg;
  List<CartItemOption> cp = [];
  for (OptionSet os in f.optionSets) {
    for (OptionSetItem osi in os.itemOptions) {
      CartItemOption cio = CartItemOption();
      cio.optionId = osi.id;
      cio.optionName = osi.name;
      cio.optionPrice = osi.price;
      cio.optionSetName = os.name;

      cp.add(cio);
    }
  }
  c.orderLineItemsOptions = cp;
  return c;
}

getFoodItemFromOrderLineItems(OrderLineItems oli) {
  FoodItem f = FoodItem();
  f.id = oli.itemId;
  f.name = oli.itemName;
  oli.quantity = 1;
  f.price = oli.unitPrice;
  f.veg = oli.veg;

  f.optionSets = [];
  OptionSet os = OptionSet(
    active: true,
    id: 1,
    mandatory: true,
    multiSelectable: true,
    name: 'add on',
    itemOptions: [],
  );
  for (OrderLineItemsOptions olio in oli.orderLineItemsOptions) {
    OptionSetItem osi = OptionSetItem(
        active: true,
        id: olio.id,
        name: olio.optionName,
        price: olio.optionPrice);
    os.itemOptions.add(osi);
  }
  f.optionSets.add(os);
  return f;
}

getFoodItemFromCartItem(CartItem oli) {
  FoodItem f = FoodItem();
  f.id = oli.itemId;
  f.name = oli.itemName;
  oli.quantity = 1;
  f.price = oli.unitPrice;
  f.veg = oli.veg;

  f.optionSets = [];
  OptionSet os = OptionSet(
    active: true,
    id: 1,
    mandatory: true,
    multiSelectable: true,
    name: 'add on',
    itemOptions: [],
  );
  for (CartItemOption olio in oli.orderLineItemsOptions) {
    OptionSetItem osi = OptionSetItem(
        active: true,
        id: olio.id,
        name: olio.optionName,
        price: olio.optionPrice);
    os.itemOptions.add(osi);
  }
  f.optionSets.add(os);
  return f;
}

// filterFoodByCategory(String category) {
//   List<FoodItem> foodList = [];
//   for (FoodItem fm in FOOD_LIST) {
//     if (fm.category == category) foodList.add(fm);
//   }
//   return foodList;
// }

checkItemPresentInCart(CartItem model, List<CartItem> list) {
  for (CartItem fm in list) {
    if (fm.itemId == model.itemId) return true;
  }
  return false;
}

getCountOfItemInCart(FoodItem model, List<CartItem> list) {
  int count = 0;
  for (CartItem fm in list) {
    if (fm.itemId == model.id) count++;
  }
  return count;
}

getTotalPriceOfOrder(OrderModel order) {
  double total = 0.00;
  total = (order.netPrice +
      (order.discountValue + order.customDiscountValue) -
      (order.taxValue +
          order.gratuityValue +
          order.deliveryFee +
          order.tipValue));
  return total;
}

double getTotalAmountFromCart(List<CartItem> list) {
  double total = 0.0;

  for (CartItem fm in list) {
    // if (fm != null && null != fm.unitPrice) {
    //   total += fm.unitPrice;
    //   if (null != fm.orderLineItemsOptions &&
    //       fm.orderLineItemsOptions.length > 0) {
    //     for (CartItemOption cm in fm.orderLineItemsOptions) {
    //       total += cm.optionPrice;
    //     }
    //   }
    // }
    total += getTotalAmountOfItem(fm);
  }
  return total;
}

double getTotalAmountOfItem(CartItem fm) {
  double total = fm.unitPrice;
  if (fm.orderLineItemsOptions.length > 0) {
    for (CartItemOption cm in fm.orderLineItemsOptions) {
      total += cm.optionPrice;
    }
  }
  return total;
}

double getTotalExtraChargeOfItem(CartItem fm) {
  double total = 0;
  if (fm.orderLineItemsOptions.length > 0) {
    for (CartItemOption cm in fm.orderLineItemsOptions) {
      total += cm.optionPrice;
    }
  }
  return total;
}

List<CartItem> getCartOrganizedByCustomization(
    List<CartItem> actualCart, CartItem FoodItem) {
  actualCart.retainWhere((element) => (element.itemId == FoodItem.itemId));
  List<CartItem> organisedCart = [];
  if (actualCart.length == 0)
    return organisedCart;
  else {
    while (actualCart.length > 0) {
      CartItem item = actualCart.elementAt(0);
      bool addNew = true;
      for (var i = 0; i < organisedCart.length; i++) {
        CartItem fm = organisedCart.elementAt(i);

        if (fm.orderLineItemsOptions.length ==
            item.orderLineItemsOptions.length) {
          List<CartItemOption> fmCust = fm.orderLineItemsOptions;
          List<CartItemOption> itemCust = item.orderLineItemsOptions;
          fmCust.sort((a, b) => a.optionName.compareTo(b.optionName));
          itemCust.sort((a, b) => a.optionName.compareTo(b.optionName));
          bool isSame = true;

          for (var j = 0; j < fmCust.length; j++) {
            if (fmCust.elementAt(j).optionName !=
                itemCust.elementAt(j).optionName) isSame = false;
          }
          if (isSame) {
            organisedCart.elementAt(i).quantity += 1;

            actualCart.removeAt(0);
            addNew = false;
            break;
          }
        }
      }
      if (addNew) {
        item.quantity = 1;
        actualCart.removeAt(0);
        organisedCart.add(item);
      }
    }
  }

  return organisedCart;
}

List<List<CartItem>> getUniqueCartItems(List<CartItem> cart) {
  List<CartItem> uniqueModel = [];
  for (CartItem fm in cart) {
    if (!uniqueModel.any((element) => element.id == fm.id)) {
      uniqueModel.add(fm);
    }
  }
  List<List<CartItem>> uniqueList = [];
  for (CartItem fm in uniqueModel) {
    uniqueList.add(getCartOrganizedByCustomization(List.from(cart), fm));
  }
  return uniqueList;
}

String generateItemUniqueId(CartItem ci) {
  List<String> idList = [];
  idList.add(ci.itemId.toString());
  for (CartItemOption cio in ci.orderLineItemsOptions)
    idList.add(cio.optionId.toString());

  idList.sort();
  return idList.join();
}

checkAllMandatoryIsSelected(Iterable values) {
  for (int v in values) if (v == 0) return false;
  return true;
}

void launchCategoryByCategoryID(List<DisplayCategories> displayCategories,
    HomePageGimages item, TabController tabController) {
  List<int> categoryList = [];
  categoryList.add(0);
  for (DisplayCategories dc in displayCategories) categoryList.add(dc.id);
  if (item.target.isNotEmpty) {
    int index = categoryList.indexOf(int.parse(item.target));
    if (index != -1) tabController.animateTo(index);
  }
}
