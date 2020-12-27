import 'dart:collection';

import 'package:google_fonts/google_fonts.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/utils.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/cart_item_option_model.dart';
import 'package:flutter/material.dart';
import 'package:singlestore/models/fooditem.dart';
import 'package:singlestore/models/optionset.dart';
import 'package:singlestore/models/optionsetitem.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';

void removeFromCart(CartItem model, List<CartItem> cart,
    Function() notifyParent, FoodItem model1, BuildContext context) {
  if (model.orderLineItemsOptions.length == 0) {
    cart.remove(model);
    notifyParent();
  } else {
    addToCart(model1, cart, notifyParent, context);
  }
}

void addToCart(FoodItem model1, List<CartItem> cart, Function() notifyParent,
    BuildContext context) {
  CartItem model = getCartItemFromFoodItem(model1);
  model.quantity = 1;
  if (model1.optionSets.length == 0) {
    cart.add(model);
    notifyParent();
  } else {
    if (checkItemPresentInCart(model, cart)) {
      List<CartItem> cartCopy = [];
      List<CartItem> organizedCart = [];

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: StatefulBuilder(builder: (context, setState) {
              cartCopy.clear();
              organizedCart.clear();
              cartCopy = List.from(cart);
              organizedCart = getCartOrganizedByCustomization(cartCopy, model);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          model.itemName,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            color: TEXT_COLOR,
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (CartItem fm in organizedCart)
                          Container(
                            padding: EdgeInsets.all(10),
                            width: double.maxFinite,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Icon(
                                    Icons.radio_button_checked,
                                    size: 14,
                                    color: fm.veg
                                        ? Colors.green[500]
                                        : Colors.red[500],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${fm.unitPrice}  X  ${fm.quantity.toString()}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '${HomeContainer.currencySymbol} ${getTotalAmountOfItem(fm).toStringAsFixed(2)}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                      ),
                                    ),
                                    for (CartItemOption cm
                                        in fm.orderLineItemsOptions)
                                      Text(
                                        '${cm.optionName} - ${HomeContainer.currencySymbol} ${cm.optionPrice.toStringAsFixed(2)}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 90,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                String uniqueID =
                                                    generateItemUniqueId(fm);
                                                for (CartItem ci in cart) {
                                                  if (uniqueID ==
                                                      generateItemUniqueId(
                                                          ci)) {
                                                    cart.remove(ci);
                                                    notifyParent();

                                                    setState(() {});

                                                    break;
                                                  }
                                                }
                                              },
                                              child: Icon(
                                                Icons.remove,
                                                size: 14,
                                                color: THEME_COLOR_PRIMARY,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                '${fm.quantity}',
                                                style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.bold,
                                                    color: THEME_COLOR_PRIMARY),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                fm.quantity = 1;
                                                cart.add(fm);
                                                setState(() {});

                                                notifyParent();
                                              },
                                              child: Icon(
                                                Icons.add,
                                                size: 14,
                                                color: THEME_COLOR_PRIMARY,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: THEME_COLOR_PRIMARY,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3))),
                                    ),
                                    Text(
                                      '${HomeContainer.currencySymbol} ${(getTotalAmountOfItem(fm) * fm.quantity).toStringAsFixed(2)}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showNewItemAddPopup(context, model1, cart, notifyParent);
                    },
                    icon: Icon(
                      Icons.add,
                      color: THEME_COLOR_PRIMARY,
                    ),
                    label: Text(
                      'Add new cutomization',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: THEME_COLOR_PRIMARY,
                      ),
                    ),
                  )
                ],
              );
            }),
          );
        },
      );
    } else {
      showNewItemAddPopup(context, model1, cart, notifyParent);
    }
  }
}

Future<void> showNewItemAddPopup(
    BuildContext context, FoodItem model, List<CartItem> cart, notifyParent()) {
  ScrollController _scrollController = ScrollController();
  CartItem modelToBeAdded = getCartItemFromFoodItem(model);

  HashMap singleSelectOption = new HashMap<String, int>();
  HashMap mandatoryOptions = new HashMap<String, int>();
  for (OptionSet os in model.optionSets) {
    singleSelectOption[os.name] = 0;
    if (os.mandatory) mandatoryOptions[os.name] = 0;
  }
  if (modelToBeAdded.orderLineItemsOptions != null)
    modelToBeAdded.orderLineItemsOptions.clear();
  int count = 1;
  double amount = modelToBeAdded.unitPrice;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        model.name,
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          color: TEXT_COLOR,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: NotificationListener(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          _scrollController.position.pixels == 0.0) {
                        // Navigator.pop(context);
                      }
                    },
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        for (OptionSet os in model.optionSets) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              os.name,
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (os.mandatory)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Choose any 1 extra (*Mandatory)',
                                style: GoogleFonts.manrope(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          for (OptionSetItem osi in os.itemOptions)
                            os.multiSelectable
                                ? CheckboxListTile(
                                    dense: true,
                                    title: Text(osi.name),
                                    activeColor: THEME_COLOR_PRIMARY,
                                    secondary: Text(
                                        '${HomeContainer.currencySymbol} ${osi.price.toStringAsFixed(2)}'),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: modelToBeAdded.orderLineItemsOptions
                                        .any((element) =>
                                            element.optionId == osi.id),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          if (os.mandatory) {
                                            if (value)
                                              mandatoryOptions[os.name]++;
                                            else
                                              mandatoryOptions[os.name]--;
                                          }
                                          if (value) {
                                            modelToBeAdded.orderLineItemsOptions
                                                .add(CartItemOption(
                                                    optionId: osi.id,
                                                    optionName: osi.name,
                                                    optionPrice: osi.price,
                                                    optionSetName: osi.name));
                                          } else
                                            modelToBeAdded.orderLineItemsOptions
                                                .removeWhere((element) =>
                                                    element.optionId == osi.id);
                                          amount = getTotalAmountOfItem(
                                              modelToBeAdded);
                                        },
                                      );
                                    },
                                  )
                                : RadioListTile(
                                    title: Text(osi.name),
                                    value: osi.id,
                                    secondary: Text(
                                        '${HomeContainer.currencySymbol} ${osi.price.toStringAsFixed(2)}'),
                                    activeColor: THEME_COLOR_PRIMARY,
                                    groupValue: singleSelectOption[os.name],
                                    onChanged: (value) {
                                      singleSelectOption[os.name] = osi.id;
                                      for (OptionSetItem osi
                                          in os.itemOptions) {
                                        modelToBeAdded.orderLineItemsOptions
                                            .removeWhere((element) =>
                                                element.optionId == osi.id);
                                      }
                                      CartItemOption mtbaCIO = CartItemOption(
                                          optionId: osi.id,
                                          optionName: osi.name,
                                          optionPrice: osi.price,
                                          optionSetName: osi.name);
                                      modelToBeAdded.orderLineItemsOptions
                                          .add(mtbaCIO);
                                      amount =
                                          getTotalAmountOfItem(modelToBeAdded);
                                      setState(() {
                                        if (os.mandatory) {
                                          mandatoryOptions[os.name] = 1;
                                        }
                                      });
                                    },
                                  ),
                        ],
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      RaisedButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        color: THEME_COLOR_PRIMARY,
                        onPressed:
                            checkAllMandatoryIsSelected(mandatoryOptions.values)
                                ? () {
                                    while (count > 0) {
                                      modelToBeAdded.quantity = 1;
                                      cart.add(modelToBeAdded);

                                      count--;
                                    }
                                    notifyParent();

                                    // modelToBeAdded =
                                    //     FoodModel.fromJson(model.toJson());
                                    // modelToBeAdded.customizationList.clear();
                                    count = 1;

                                    // amount = modelToBeAdded.amount;
                                    // selectedRadio = null;
                                    Navigator.pop(context);
                                  }
                                : null,
                        child: Text(
                          'ADD ${HomeContainer.currencySymbol} ${(amount * count).toStringAsFixed(2)}',
                          style: GoogleFonts.manrope(
                            color: TEXT_ON_THEME_COLOR,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: 130,
                        height: 35,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (count > 1) count--;
                                  });
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: 14,
                                  color: THEME_COLOR_PRIMARY,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  '$count',
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                      color: THEME_COLOR_PRIMARY),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  // cart.add(modelToBeAdded);
                                  // notifyParent();
                                  // modelToBeAdded =
                                  //     FoodModel.fromJson(model.toJson());
                                  // modelToBeAdded.customizationList.clear();
                                  setState(() {
                                    count++;
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 14,
                                  color: THEME_COLOR_PRIMARY,
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: THEME_COLOR_PRIMARY,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      );
    },
  );
}
