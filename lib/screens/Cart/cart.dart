import 'dart:collection';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/utils.dart';
import 'package:singlestore/models/availableDateTimings.dart';
import 'package:singlestore/models/availableDateTimingsItem.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/cart_payment_validation.dart';
import 'package:singlestore/models/fooditem.dart';
import 'package:singlestore/models/messages.dart';
import 'package:singlestore/models/moreInstructions.dart';
import 'package:singlestore/models/offer.dart';
import 'package:singlestore/models/order.dart';
import 'package:singlestore/models/orderLineItems.dart';
import 'package:singlestore/models/orderLineItemsOptions.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/models/taxAndChargeSet.dart';
import 'package:singlestore/models/tip_value.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';
import 'package:singlestore/widgets/utility_widget.dart';
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
import 'package:singlestore/widgets/utility_widget.dart';

import '../../main.dart';
import 'bloc/cart_model.dart';

class CartStateless extends StatelessWidget {
  var object;
  CartStateless(this.object) : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (BuildContext context) => CartBloc(),
      child: Cart(object),
    );
  }
}

class Cart extends StatefulWidget {
  var object;
  Cart(this.object) : super();

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Function() notifyParent;
  List<CartItem> cart;
  List<String> moreInfo = [];
  String orderTimeStamp = 'Select Date and Time';
  bool isReloadAllowed = true;
  static bool allBottomSheet = true;
  int deliveryID = -1;
  String deliveryName = '';
  List<String> favItems = [];
  TextEditingController _instructionController = TextEditingController();
  PrepareOrderModel preOrdrMdl;
  refreshState() {
    setState(() {});
  }

  Future<void> getSavedOrderType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('orderType') != null)
      deliveryID = prefs.getInt('orderType');

    switch (deliveryID) {
      case 5:
        deliveryName = 'Pick Up';
        break;
      case 6:
        deliveryName = 'CurbSide';
        break;
      case 7:
        deliveryName = 'Delivery';
        break;
      case 8:
        deliveryName = 'DineIn';
        break;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cart = widget.object['cart'];
    notifyParent = widget.object['notifyParent'];
    getSavedOrderType();
  }

  List<Map<String, String>> tip = [];
  String tipValue = '7';

  String _deliveryTime = 'now';

  @override
  Widget build(BuildContext context) {
    if (prefs.getStringList('fav') != null) {
      favItems = prefs.getStringList('fav');
    }
    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: THEME_COLOR_PRIMARY),
          title: Text(
            'Cart',
            style: GoogleFonts.manrope(
              color: THEME_COLOR_PRIMARY,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/svg/empty_cart.svg',
                semanticsLabel: 'Under development',
                height: 200,
                width: 200,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'YOUR CART IS EMPTY',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Please add some item from the menu',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('EXPLORE MENU'),
                textColor: Colors.white,
                color: THEME_COLOR_PRIMARY,
              )
            ],
          ),
        ),
      );
    } else {
      CartBloc _cartBlock = BlocProvider.of<CartBloc>(context);
      if (isReloadAllowed)
        _cartBlock.add(
          PrepareOrder(cart),
        );
      // isReloadAllowed = false;
      return BlocListener<CartBloc, CartState>(
        bloc: _cartBlock,
        listener: (context, state) {
          if (state is ErrorState) {
          } else {}
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is ProcessingState || state is CartInitialState)
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: THEME_COLOR_PRIMARY),
                  title: Text(
                    'Cart',
                    style: GoogleFonts.manrope(
                      color: THEME_COLOR_PRIMARY,
                    ),
                  ),
                ),
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            if (state is ErrorState)
              return Center(
                child: Text(state.getResponse.message),
              );
            if (state is SuccessState) {
              tip.clear();

              for (TipValue tv in state.getResponse.data.tip.values) {
                tip.add(
                  {'value': tv.id.toString(), 'title': tv.name},
                );
              }
              tip.add(
                {'value': '7', 'title': 'Other'},
              );
              tipValue = state.getResponse.data.selectedTipId.toString();

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                logger
                    .e('addPostFrameCallback : ${preOrdrMdl.messages.length}');

                if (preOrdrMdl != null &&
                    preOrdrMdl.messages.isNotEmpty &&
                    allBottomSheet) {
                  showNotification(preOrdrMdl.messages);
                  preOrdrMdl = null;
                }
              });

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: THEME_COLOR_PRIMARY),
                  actions: [
                    FlatButton(
                      onPressed: null,
                      child: Text(
                        deliveryName,
                        style: GoogleFonts.manrope(
                            color: THEME_COLOR_PRIMARY,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${cart.length} Items in cart',
                        style: GoogleFonts.manrope(
                          color: THEME_COLOR_PRIMARY,
                        ),
                      ),
                      Text(
                        'You pay : ${HomeContainer.currencySymbol} ${getTotalPriceOfOrder(state.getResponse.data.webOrder.order).toStringAsFixed(2)}',
                        style: GoogleFonts.manrope(
                          color: THEME_COLOR_PRIMARY,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                body: body(state.getResponse.data),
              );
            }
          },
        ),
      );
    }
  }

  body(PrepareOrderModel prepOrderModel) {
    // for (TipValue tv in prepOrderModel.tip.values) {
    //   tip.add(
    //     {'value': tv.value.toStringAsFixed(2), 'title': tv.name},
    //   );
    // }
    // tip.add(
    //   {'value': 'Other', 'title': 'Other'},
    // );
    preOrdrMdl = prepOrderModel;

    for (OrderLineItems oli in prepOrderModel.webOrder.order.orderLineItems) {
      return ListView(
        children: [
          for (OrderLineItems item
              in prepOrderModel.webOrder.order.orderLineItems)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.radio_button_checked,
                      size: 14,
                      color: item.veg ? Colors.green[500] : Colors.red[500],
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
                        item.itemName,
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${item.unitPrice.toStringAsFixed(2)}  X ${item.quantity.toInt()}',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                        ),
                      ),
                      for (OrderLineItemsOptions oi
                          in item.orderLineItemsOptions)
                        Text(
                          '${oi.optionName} - ${HomeContainer.currencySymbol} ${oi.optionPrice}',
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
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Map<String, dynamic> HEADER_MAP =
                                      Map<String, dynamic>();
                                  HEADER_MAP['Authorization'] = API.JWT_AUTH;

                                  String url = API.BASE_URL +
                                      '/api/app/singlestore/decreaseOrderLineItemQuantity';

                                  var response;

                                  try {
                                    response = await Dio().post(
                                      url,
                                      queryParameters: {
                                        "storeKey": API.STORE_KEY,
                                        "orderId":
                                            prepOrderModel.webOrder.order.id,
                                        "orderLineItemId": item.id,
                                        "orderLineItemQuantityToDecrease": 1.0,
                                      },
                                      options: Options(headers: HEADER_MAP),
                                    );
                                    StandardResponse res =
                                        StandardResponse.fromMap(response.data);
                                    if (res.message != null &&
                                        res.message.isNotEmpty)
                                      showToast(res.message);
                                    OrderModel oModel =
                                        OrderModel.fromMap(res.data);

                                    cart.clear();
                                    for (OrderLineItems oli
                                        in oModel.orderLineItems) {
                                      CartItem ci =
                                          getCartItemFromOrderLineItem(oli);
                                      int qty = ci.quantity;
                                      ci.quantity = 1;
                                      ci.id = null;
                                      for (var i = 0; i < qty; i++) {
                                        cart.add(ci);
                                      }
                                    }
                                    notifyParent();
                                    refreshState();
                                  } catch (e) {
                                    print(e);
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
                                  '${item.quantity.toInt()}',
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                      color: THEME_COLOR_PRIMARY),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Map<String, dynamic> HEADER_MAP =
                                      Map<String, dynamic>();
                                  HEADER_MAP['Authorization'] = API.JWT_AUTH;

                                  String url = API.BASE_URL +
                                      '/api/app/singlestore/increaseOrderLineItemQuantity';

                                  var response;

                                  try {
                                    response = await Dio().post(
                                      url,
                                      queryParameters: {
                                        "storeKey": API.STORE_KEY,
                                        "orderId":
                                            prepOrderModel.webOrder.order.id,
                                        "orderLineItemId": item.id,
                                        "orderLineItemQuantityToIncrease": 1,
                                      },
                                      options: Options(headers: HEADER_MAP),
                                    );

                                    StandardResponse res =
                                        StandardResponse.fromMap(response.data);
                                    if (res.message != null &&
                                        res.message.isNotEmpty)
                                      showToast(res.message);
                                    OrderModel oModel =
                                        OrderModel.fromMap(res.data);

                                    cart.clear();
                                    for (OrderLineItems oli
                                        in oModel.orderLineItems) {
                                      CartItem ci =
                                          getCartItemFromOrderLineItem(oli);
                                      int qty = ci.quantity;
                                      ci.quantity = 1;
                                      ci.id = null;
                                      for (var i = 0; i < qty; i++) {
                                        cart.add(ci);
                                      }
                                    }
                                    notifyParent();
                                    refreshState();
                                  } catch (e) {
                                    print(e);
                                  }

                                  setState(() {});
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
                      ),
                      Text(
                        '${HomeContainer.currencySymbol} ${(item.unitPrice * item.quantity.toInt()).toStringAsFixed(2)}',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          Divider(
            color: Colors.grey.withOpacity(0.5),
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: TextField(
              controller: _instructionController,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 2,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'Any restaurant request? We will try our best to complete.'),
              style: GoogleFonts.manrope(color: Colors.grey, fontSize: 14),
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              'More Instructions',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (MoreInstructions mi in prepOrderModel.moreInstructions)
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  if (value)
                    moreInfo.add(mi.id.toString());
                  else
                    moreInfo.remove(mi.id.toString());
                });
              },
              activeColor: THEME_COLOR_PRIMARY,
              value: moreInfo.contains(mi.id.toString()),
              title: Text(mi.name),
              subtitle: Text(mi.description),
            ),
          Divider(),
          Divider(
            height: 10,
            color: Colors.grey.withOpacity(0.5),
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Tip your delivery partner'),
            subtitle: Text(
                'Thank your deliver partner to stay safe indoors. Support them through tough times with a tip.'),
          ),
          ChipsChoice<String>.single(
            value: tipValue,
            options: ChipsChoiceOption.listFrom<String, Map<String, String>>(
              source: tip,
              value: (index, item) => item['value'],
              label: (index, item) => item['title'],
            ),
            itemConfig:
                ChipsChoiceItemConfig(selectedColor: THEME_COLOR_PRIMARY),
            onChanged: (value) async {
              if (value == tipValue) {
                Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
                HEADER_MAP['Authorization'] = API.JWT_AUTH;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String url = API.BASE_URL +
                    '/api/app/singlestore/${prefs.getInt('orderID')}/removeTip';

                var response;

                try {
                  response = await Dio().post(
                    url,
                    queryParameters: {
                      "storeKey": API.STORE_KEY,
                    },
                    options: Options(headers: HEADER_MAP),
                  );
                } catch (e) {
                  print(e);
                }

                print(response.toString());
                StandardResponse res = StandardResponse.fromMap(response.data);
                if (res.message != null && res.message.isNotEmpty)
                  showToast(res.message);
                if (response.statusCode == 200) {
                  showToast('Tip removed.');
                } else {
                  showToast(res.message);
                }
                setState(() {});
              } else {
                if (value == '7') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController customTipCtrl =
                          TextEditingController();
                      return AlertDialog(
                        title: Text('Enter tip amount'),
                        actions: [
                          FlatButton(
                            onPressed: () async {
                              Map<String, dynamic> HEADER_MAP =
                                  Map<String, dynamic>();
                              HEADER_MAP['Authorization'] = API.JWT_AUTH;
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String url = API.BASE_URL +
                                  '/api/app/singlestore/${prefs.getInt('orderID')}/applyTip/${value}';

                              var response;

                              try {
                                response = await Dio().post(
                                  url,
                                  queryParameters: {
                                    "storeKey": API.STORE_KEY,
                                    "customTipValue": customTipCtrl.text
                                  },
                                  options: Options(headers: HEADER_MAP),
                                );
                              } catch (e) {
                                print(e);
                              }

                              print(response.toString());
                              StandardResponse res =
                                  StandardResponse.fromMap(response.data);
                              if (res.message != null && res.message.isNotEmpty)
                                showToast(res.message);
                              if (response.statusCode == 200) {
                                showToast('Tip added.');
                              } else {
                                showToast(res.message);
                              }
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(color: THEME_COLOR_PRIMARY),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(color: THEME_COLOR_PRIMARY),
                            ),
                          ),
                        ],
                        content: TextField(
                          controller: customTipCtrl,
                          cursorColor: THEME_COLOR_PRIMARY,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: THEME_COLOR_PRIMARY),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
                  HEADER_MAP['Authorization'] = API.JWT_AUTH;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String url = API.BASE_URL +
                      '/api/app/singlestore/${prefs.getInt('orderID')}/applyTip/${value}';

                  var response;

                  try {
                    response = await Dio().post(
                      url,
                      queryParameters: {
                        "storeKey": API.STORE_KEY,
                        "customTipValue": prepOrderModel.tip.values
                            .firstWhere(
                                (element) => element.id == int.parse(value))
                            .value
                      },
                      options: Options(headers: HEADER_MAP),
                    );
                  } catch (e) {
                    print(e);
                  }

                  print(response.toString());
                  StandardResponse res =
                      StandardResponse.fromMap(response.data);
                  if (res.message != null && res.message.isNotEmpty)
                    showToast(res.message);
                  if (response.statusCode == 200) {
                    showToast('Tip added.');
                  } else {
                    showToast(res.message);
                  }
                  setState(() {});
                }
              }
            },
          ),
          ListTile(
            leading: Container(
              height: double.maxFinite,
              width: 60,
              padding: EdgeInsets.all(10),
              color: (null != prepOrderModel.appliedOffer &&
                      prepOrderModel.appliedOffer.promocode.isNotEmpty)
                  ? Colors.green
                  : Colors.transparent,
              child: Image.asset(
                'assets/images/sale.png',
                width: 30,
                height: 30,
              ),
            ),
            onTap: () async {
              if (null != prepOrderModel.appliedOffer &&
                  prepOrderModel.appliedOffer.promocode.isNotEmpty) {
                showSelectedOfferPromoCodeDetail(
                    prepOrderModel.appliedOffer, context);
              } else
                Navigator.of(context).pushNamed('/offer').then((value) {
                  setState(() {});
                });
            },
            title: (null != prepOrderModel.appliedOffer &&
                    prepOrderModel.appliedOffer.promocode.isNotEmpty)
                ? Text(prepOrderModel.appliedOffer.promocode)
                : Text('APPLY COUPON'),
            subtitle: (null != prepOrderModel.appliedOffer &&
                    prepOrderModel.appliedOffer.promocode.isNotEmpty)
                ? Text(
                    prepOrderModel.appliedOffer.shortDescription,
                    style: TextStyle(color: THEME_COLOR_PRIMARY),
                  )
                : Text(
                    'Get discount with your order',
                  ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (null != prepOrderModel.appliedOffer &&
                    prepOrderModel.appliedOffer.promocode.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
                      HEADER_MAP['Authorization'] = API.JWT_AUTH;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String url = API.BASE_URL +
                          '/api/app/singlestore/${prefs.getInt('orderID')}/removePromocode';

                      var response;

                      try {
                        response = await Dio().post(
                          url,
                          queryParameters: {
                            "storeKey": API.STORE_KEY,
                          },
                          options: Options(headers: HEADER_MAP),
                        );
                      } catch (e) {
                        print(e);
                      }

                      print(response.toString());
                      StandardResponse res =
                          StandardResponse.fromMap(response.data);
                      if (res.message != null && res.message.isNotEmpty)
                        showToast(res.message);
                      if (response.statusCode == 200) {
                        showToast('Promo code removed.');
                      } else {
                        showToast(res.message);
                      }
                      setState(() {});
                    },
                  ),
                SizedBox(
                  width: 20,
                ),
                (null != prepOrderModel.appliedOffer &&
                        prepOrderModel.appliedOffer.promocode.isNotEmpty)
                    ? Text(
                        'MORE\nDETAILS',
                        style: TextStyle(color: THEME_COLOR_PRIMARY),
                        textAlign: TextAlign.center,
                      )
                    : Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              'Bill Details',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Sub Total'),
                ),
                Text(':'),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${HomeContainer.currencySymbol} ${prepOrderModel.webOrder.order.netPrice.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Discount'),
                ),
                Text(':'),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${HomeContainer.currencySymbol} ${prepOrderModel.webOrder.order.discountValue.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.lightGreen),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Tip'),
                ),
                Text(':'),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${HomeContainer.currencySymbol} ${prepOrderModel.webOrder.order.tipValue.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('Taxes & Charges'),
                      SizedBox(
                        width: 7,
                      ),
                      InkWell(
                        child: Icon(
                          Icons.info_outline,
                          size: 14,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (TaxAndChargeSet tcset in prepOrderModel
                                      .webOrder.taxAndChargeSet)
                                    ListTile(
                                      title: Text(tcset.name),
                                      subtitle: Text(tcset.description),
                                      trailing: Text(
                                          '${HomeContainer.currencySymbol} ${tcset.value.toStringAsFixed(2)}'),
                                    ),
                                  Divider(),
                                  ListTile(
                                    title: Text('Total'),
                                    trailing: Text(
                                        '${HomeContainer.currencySymbol} ${prepOrderModel.webOrder.order.taxValue.toStringAsFixed(2)}'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Text(':'),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${HomeContainer.currencySymbol} ${prepOrderModel.webOrder.order.taxValue.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 10,
            color: Colors.grey.withOpacity(0.5),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Grand Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${HomeContainer.currencySymbol} ${getTotalPriceOfOrder(prepOrderModel.webOrder.order).toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 20,
            color: Colors.grey.withOpacity(0.2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '$deliveryName Time',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/images/truck.png'),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Radio(
                              activeColor: THEME_COLOR_PRIMARY,
                              groupValue: _deliveryTime,
                              onChanged: (value) {
                                setState(() {
                                  _deliveryTime = value;
                                });
                              },
                              value: 'now',
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('$deliveryName Now'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _deliveryTime = 'advance';
                            getBottomSheetForOrderTime(
                                context, prepOrderModel.orderDateTimes);
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Radio(
                                activeColor: THEME_COLOR_PRIMARY,
                                value: 'advance',
                                groupValue: _deliveryTime,
                                onChanged: (value) {
                                  setState(() {
                                    allBottomSheet = false;

                                    _deliveryTime = value;
                                    getBottomSheetForOrderTime(
                                        context, prepOrderModel.orderDateTimes);
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Advance Timings',
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _deliveryTime = 'advance';
                            allBottomSheet = false;
                            getBottomSheetForOrderTime(
                                context, prepOrderModel.orderDateTimes);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            orderTimeStamp,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: THEME_COLOR_PRIMARY.withOpacity(0.5),
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Take Away from',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  prepOrderModel.orderTypeInfoBox.subText,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (prepOrderModel.webOrder.order.discountValue > 0)
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Text(
                'You have saved ${HomeContainer.currencySymbol} ${prepOrderModel.webOrder.order.discountValue.toStringAsFixed(2)}',
                style: GoogleFonts.manrope(
                  color: Colors.lightGreen,
                  fontSize: 14,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.lightGreen.withOpacity(0.1),
                border: Border.all(
                  color: Colors.lightGreen,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              prepOrderModel.displayCategory.name,
              style: GoogleFonts.manrope(
                  color: TEXT_COLOR, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 240,
            width: double.maxFinite,
            child: getDisplayItems(prepOrderModel.displayCategory.items),
          ),
          FlatButton(
            color: THEME_COLOR_PRIMARY,
            onPressed: prepOrderModel.toUpdateAccount
                ? () {
                    // update profile
                    // Navigator.of(context).pushNamed('/account').then((value) {
                    //   setState(() {});
                    // });
                    showUpdateProfileModalBottomSheet(context);
                  }
                : () async {
                    // check for cart
                    CartPaymentValidation cartPaymentValidation =
                        CartPaymentValidation(
                            instructions: _instructionController.text,
                            moreInstructionIds: moreInfo.join(','),
                            requiredTimings: orderTimeStamp);

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
                    HEADER_MAP['Authorization'] = API.JWT_AUTH;

                    String url = API.BASE_URL +
                        '/api/app/singlestore/order/canProceedToPayment/${prepOrderModel.webOrder.order.id}';

                    var response;

                    try {
                      response = await Dio().post(
                        url,
                        data: cartPaymentValidation.toJson(),
                        queryParameters: {
                          "storeKey": API.STORE_KEY,
                        },
                        options: Options(headers: HEADER_MAP),
                      );
                      StandardResponse res =
                          StandardResponse.fromMap(response.data);
                      if (res.message != null && res.message.isNotEmpty)
                        showToast(res.message);
                      // showToast(res.status);
                      Navigator.of(context)
                          .pushNamed('/webview',
                              arguments:
                                  'http://singlestore.us-east-2.elasticbeanstalk.com/order/proceedtoplaceorder/${prepOrderModel.webOrder.order.id}?storeKey=${API.STORE_KEY}&tempToken=${API.JWT_AUTH.replaceAll('Bearer ', '')}')
                          .then((value) async {
                        // callback

                        logger.e('requesting callbackk');

                        Map<String, dynamic> HEADER_MAP =
                            Map<String, dynamic>();
                        HEADER_MAP['Authorization'] = API.JWT_AUTH;

                        String url = API.BASE_URL +
                            '/api/app/singlestore/${prepOrderModel.webOrder.order.id}/orderpaymentsuccess';

                        var response;

                        try {
                          response = await Dio().get(
                            url,
                            queryParameters: {
                              "storeKey": API.STORE_KEY,
                            },
                            options: Options(headers: HEADER_MAP),
                          );

                          logger
                              .e('payment status : ${response.data['status']}');
                          if (response.data['status'] == 'success') {
                            cart.clear();
                            notifyParent();
                            Navigator.of(context)
                                .pushNamed('/ordersummary', arguments: {
                              "orderID": prepOrderModel.webOrder.order.id,
                              "cart": cart,
                              "notifyParent": notifyParent,
                            });
                          } else {
                            showToast(
                                'payment status : ${response.data['status']}');
                          }
                        } catch (e) {}
                      });
                    } catch (e) {}
                  },
            child: Text(
              !prepOrderModel.toUpdateAccount
                  ? '${prepOrderModel.submitButtonDisplayValue}'
                  : 'Update profile details',
              style: GoogleFonts.manrope(
                color: TEXT_ON_THEME_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      );
    }
  }

  void getBottomSheetForOrderTime(
      BuildContext context, OrderDateTimes availableDateTimings) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        String oDate = orderTimeStamp.substring(0, orderTimeStamp.indexOf(' '));
        int index = 0;
        List<String> oTime = List<String>.generate(
            availableDateTimings.availableDateTimings.length,
            (i) => availableDateTimings.availableDateTimings
                    .elementAt(i)
                    .useCommonTimings
                ? availableDateTimings.commonDateTimings.first
                : availableDateTimings.availableDateTimings
                    .elementAt(i)
                    .timings
                    .first);
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: StatefulBuilder(
            builder: (context, setState) {
              // allBottomSheet = true;
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      'Set delivery date and time',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: FlatButton(
                      onPressed: () {
                        if (oDate == 'Select') {
                          showToast('Select date');
                          return;
                        }
                        allBottomSheet = true;
                        Navigator.of(context).pop();
                        setOrderTimeStamp(oDate, oTime.elementAt(index));
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 16,
                            color: THEME_COLOR_PRIMARY,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  for (AvailableDateTimings ati
                      in availableDateTimings.availableDateTimings) ...[
                    CheckboxListTile(
                      activeColor: THEME_COLOR_PRIMARY,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: oDate == ati.date,
                      onChanged: (value) {
                        setState(() {
                          index = availableDateTimings.availableDateTimings
                              .indexOf(ati);
                          if (value)
                            oDate = ati.date;
                          else
                            oDate = '';
                        });
                      },
                      title: Text(ati.date),
                      secondary: DropdownButton<String>(
                        hint: new Text("Select time",
                            textAlign: TextAlign.center),
                        items: (ati.useCommonTimings
                                ? availableDateTimings.commonDateTimings
                                : ati.timings)
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        value: oTime[availableDateTimings.availableDateTimings
                            .indexOf(ati)],
                        onChanged: (value) {
                          setState(() {
                            oTime[availableDateTimings.availableDateTimings
                                .indexOf(ati)] = value;
                          });
                        },
                      ),
                    ),
                  ]
                ],
              );
            },
          ),
        );
      },
    );
  }

  void setOrderTimeStamp(String oDate, String oTime) {
    setState(() {
      if (oDate.isEmpty || oTime.isEmpty)
        orderTimeStamp = 'Select Date and Time';
      else
        orderTimeStamp = '$oDate $oTime';

      log(orderTimeStamp);
    });
  }

  getDisplayItems(List<FoodItem> items) {
    return ListView.builder(
      itemCount: items.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        FoodItem model = items.elementAt(index);
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: (model.image != null)
                          ? model.image
                          : "https://firebasestorage.googleapis.com/v0/b/single-store.appspot.com/o/WhatsApp%20Image%202020-09-03%20at%201.08.01%20AM.jpeg?alt=media&token=00e388c5-7f5b-4025-8e6a-742d1e0137ee",
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/food_category_placeholder.jpg',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/food_category_placeholder.jpg',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                          icon: Icon(
                            favItems.contains(model.id.toString())
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            Map<String, dynamic> HEADER_MAP =
                                Map<String, dynamic>();
                            HEADER_MAP['Authorization'] = API.JWT_AUTH;

                            String url = API.BASE_URL +
                                '/api/favorites/updateAndGetFavorites';
                            if (favItems.contains(model.id.toString()))
                              favItems.remove(model.id.toString());
                            else
                              favItems.add(model.id.toString());
                            var response;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setStringList('fav', favItems);
                            try {
                              response = await Dio().post(
                                url,
                                data: {"itemIds": favItems.join(',')},
                                queryParameters: {"storeKey": API.STORE_KEY},
                                options: Options(headers: HEADER_MAP),
                              );
                              setState(() {});
                            } catch (e) {}
                          }),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.radio_button_checked,
                    size: 14,
                    color: model.veg ? Colors.green[500] : Colors.red[500],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    model.name,
                    style: GoogleFonts.manrope(
                        color: TEXT_COLOR,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  (model.manageStock)
                      ? Text(
                          '${model.stockQuantity} left in stock',
                          style: GoogleFonts.manrope(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        )
                      : Text(
                          '',
                          style: GoogleFonts.manrope(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${HomeContainer.currencySymbol} ${model.price.toStringAsFixed(2)}',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        color: TEXT_COLOR,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: (model.stockQuantity == 0 && model.manageStock)
                        ? Container(
                            alignment: Alignment.center,
                            width: 90,
                            height: 35,
                            child: Text(
                              'Notify',
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                  color: THEME_COLOR_PRIMARY),
                            ),
                            decoration: BoxDecoration(
                                color: THEME_COLOR_PRIMARY.withOpacity(0.2),
                                border: Border.all(
                                  color: THEME_COLOR_PRIMARY,
                                  width: 1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                          )
                        : (checkItemPresentInCart(
                                getCartItemFromFoodItem(model), cart))
                            ? Container(
                                width: 120,
                                height: 35,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          removeFromCart(
                                              getCartItemFromFoodItem(model),
                                              cart,
                                              notifyParent,
                                              model);

                                          setState(() {});
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
                                          '${getCountOfItemInCart(model, cart)}',
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
                                          addToCart(model, context);
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                              )
                            : InkWell(
                                onTap: () {
                                  addToCart(model, context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 130,
                                  child: Text(
                                    'Add',
                                    style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.bold,
                                        color: THEME_COLOR_PRIMARY),
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: THEME_COLOR_PRIMARY,
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3))),
                                ),
                              ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    model.shortDesc,
                    style: GoogleFonts.manrope(fontSize: 12, color: TEXT_COLOR),
                  ),
                  Spacer(),
                  (model.optionSets.length == 0)
                      ? Text(
                          '',
                          style: GoogleFonts.manrope(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        )
                      : Text(
                          'Customizable',
                          style: GoogleFonts.manrope(
                            color: THEME_COLOR_PRIMARY,
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

  void addToCart(
    FoodItem model1,
    BuildContext context,
  ) {
    CartItem model = getCartItemFromFoodItem(model1);
    model.quantity = 1;
    if (model1.optionSets.length == 0) {
      cart.add(model);
      notifyParent();
      refreshState();
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
                organizedCart =
                    getCartOrganizedByCustomization(cartCopy, model);
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
                              refreshState();
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          THEME_COLOR_PRIMARY),
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
                        showNewItemAddPopup(context, model1, cart);
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
        showNewItemAddPopup(
          context,
          model1,
          cart,
        );
      }
    }
  }

  Future<void> showNewItemAddPopup(
      BuildContext context, FoodItem model, List<CartItem> cart) {
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      value: modelToBeAdded
                                          .orderLineItemsOptions
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
                                              modelToBeAdded
                                                  .orderLineItemsOptions
                                                  .add(CartItemOption(
                                                      optionId: osi.id,
                                                      optionName: osi.name,
                                                      optionPrice: osi.price,
                                                      optionSetName: osi.name));
                                            } else
                                              modelToBeAdded
                                                  .orderLineItemsOptions
                                                  .removeWhere((element) =>
                                                      element.optionId ==
                                                      osi.id);
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
                                        amount = getTotalAmountOfItem(
                                            modelToBeAdded);
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          color: THEME_COLOR_PRIMARY,
                          onPressed: checkAllMandatoryIsSelected(
                                  mandatoryOptions.values)
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
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

  void removeFromCart(
    CartItem model,
    List<CartItem> cart,
    Function() notifyParent,
    FoodItem model1,
  ) {
    if (model.orderLineItemsOptions.length == 0) {
      cart.remove(model);
      notifyParent();
    } else {
      addToCart(model1, context);
    }
  }

  void showSelectedOfferPromoCodeDetail(
      OfferModel model, BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (context) => Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(50.0),
            topRight: const Radius.circular(50.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: THEME_COLOR_PRIMARY,
                    ),
                    color: THEME_COLOR_PRIMARY.withOpacity(0.2),
                  ),
                  child: Text(
                    model.promocode,
                    style: GoogleFonts.openSans(
                        color: THEME_COLOR_PRIMARY,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  model.shortDescription,
                  style: GoogleFonts.openSans(
                      color: THEME_COLOR_PRIMARY,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            Divider(),
            for (Details s in model.details)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  '${HomeContainer.currencySymbol} ${s.text}',
                  style: GoogleFonts.openSans(
                    color: TEXT_COLOR,
                  ),
                ),
              ),
            Spacer(),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: THEME_COLOR_PRIMARY,
                  ),
                  color: THEME_COLOR_PRIMARY,
                ),
                child: Text(
                  'OK, GOT IT',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showNotification(List<Messages> messages) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Title(
              color: THEME_COLOR_PRIMARY,
              child: Text(
                'Please note',
                style: TextStyle(
                    color: THEME_COLOR_PRIMARY,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            for (Messages m in messages) ...[
              // Text(
              //   '${messages.indexOf(m) + 1} ${m.text}',
              //   softWrap: true,
              //   style: TextStyle(
              //     fontSize: 16,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(m.text),
                leading: Icon(
                  Icons.info_outline,
                  color: THEME_COLOR_PRIMARY,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  showUpdateProfileModalBottomSheet(context) async {
    TextEditingController userName = TextEditingController();
    TextEditingController userEmail = TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true, // important
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Title(
                            color: THEME_COLOR_PRIMARY,
                            child: Text(
                              'Profile Update',
                              style: TextStyle(
                                  color: THEME_COLOR_PRIMARY,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                            textColor: THEME_COLOR_PRIMARY,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildInputFieldThemColor(
                          'Name', Icons.person, TextInputType.name, userName),
                      buildInputFieldThemColor('Email', Icons.email,
                          TextInputType.emailAddress, userEmail),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: double.maxFinite,
                        child: RaisedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            prefs.setString('userName', userName.text);
                            prefs.setString('userEmail', userEmail.text);

                            Navigator.of(context).pop();
                            updateCustomerDetails();

                            setState(() {});
                          },
                          child: Text('Save'),
                          textColor: Colors.white,
                          color: THEME_COLOR_PRIMARY,
                        ),
                      ),
                      Container(
                        height: 230,
                        width: double.maxFinite,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> updateCustomerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    String url =
        API.BASE_URL + '/api/app/singlestore/customer/updateAccountDetails';

    var response;

    try {
      response = await Dio().post(
        url,
        data: {
          "emailId": prefs.getString('userEmail'),
          "emailVerified": false,
          "fullName": prefs.getString('userName'),
          "mobileNo": prefs.getString('userNumber'),
          "mobileVerified": true,
          "storeKey": API.STORE_KEY
        },
        queryParameters: {
          "storeKey": API.STORE_KEY,
        },
        options: Options(headers: HEADER_MAP),
      );
      StandardResponse res = StandardResponse.fromMap(response.data);
      if (res.message != null && res.message.isNotEmpty) showToast(res.message);
      showToast('Profile updated');
    } catch (e) {
      print(e);
    }
  }
}
