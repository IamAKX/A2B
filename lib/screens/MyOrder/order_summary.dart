import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/utils.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/orderLineItems.dart';
import 'package:singlestore/models/orderLineItemsOptions.dart';
import 'package:singlestore/models/order_dtails.dart';
import 'package:singlestore/models/order_summary_model.dart';
import 'package:singlestore/models/reorder_model.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/models/taxAndChargeSet.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';
import 'package:singlestore/widgets/utility_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSummary extends StatefulWidget {
  var object;
  OrderSummary(this.object) : super();
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  OrderSummaryModel model;
  Function() notifyParent;
  var orderID;
  List<CartItem> cart;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cart = widget.object['cart'];
    notifyParent = widget.object['notifyParent'];
    orderID = widget.object['orderID'];
    loadOrderSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          if (model != null)
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/webview',
                    arguments:
                        'http://singlestore.us-east-2.elasticbeanstalk.com/app/helperpages/orderHelp/${model.order.id}?tempToken=${API.JWT_AUTH.replaceAll('Bearer ', '')}&storeKey=${API.STORE_KEY}');
              },
              child: Text('HELP'),
              textColor: THEME_COLOR_PRIMARY,
            ),
        ],
        iconTheme: IconThemeData(color: THEME_COLOR_PRIMARY),
        title: Text(
          'Order Summary',
          style: GoogleFonts.manrope(
            color: THEME_COLOR_PRIMARY,
          ),
        ),
      ),
      body: model == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : body(),
    );
  }

  Future<void> loadOrderSummary() async {
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    var response;
    logger.i(API.ORDER_SUMMARY + orderID.toString() + '/summary');
    try {
      response = await Dio().get(
        API.ORDER_SUMMARY + orderID.toString() + '/summary',
        queryParameters: {
          "storeKey": API.STORE_KEY,
        },
        options: Options(headers: HEADER_MAP),
      );

      StandardResponse res = StandardResponse.fromMap(response.data);
      if (res.message != null && res.message.isNotEmpty) showToast(res.message);
      logger.i(response.data);

      model = OrderSummaryModel.fromMap(res.data);
      setState(() {});
    } catch (e) {}
  }

  body() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      children: [
        Text(
          '${model.storeName}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${model.storeAddress}',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        Divider(),
        Text(
          '${model.orderStatusMessage}',
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Order',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                prcessReorder();
              },
              child: Text('REORDER'),
              color: THEME_COLOR_PRIMARY,
              textColor: Colors.white,
            ),
          ],
        ),
        for (OrderLineItems item in model.order.orderLineItems)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: double.maxFinite,
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
                    width: 10,
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
          ),
        Divider(),
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
                  '${HomeContainer.currencySymbol} ${model.order.netPrice.toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
        if (model.order.discountValue > 0)
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
                    '${HomeContainer.currencySymbol} ${model.order.discountValue.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.lightGreen),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         flex: 1,
        //         child: Text('Tip'),
        //       ),
        //       Text(':'),
        //       Expanded(
        //         flex: 1,
        //         child: Text(
        //           '${HomeContainer.currencySymbol} ${model.order.tipValue.toStringAsFixed(2)}',
        //           style: TextStyle(color: Colors.red),
        //           textAlign: TextAlign.right,
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        if (model.order.taxValue > 0)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('Taxes & Charges'),
                      // SizedBox(
                      //   width: 7,
                      // ),
                      // InkWell(
                      //   child: Icon(
                      //     Icons.info_outline,
                      //     size: 14,
                      //   ),
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //         content: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             for (TaxAndChargeSet tcset
                      //                 in model.order..taxAndChargeSet)
                      //               ListTile(
                      //                 title: Text(tcset.name),
                      //                 subtitle: Text(tcset.description),
                      //                 trailing: Text(
                      //                     '${HomeContainer.currencySymbol} ${tcset.value.toStringAsFixed(2)}'),
                      //               ),
                      //             Divider(),
                      //             ListTile(
                      //               title: Text('Total'),
                      //               trailing: Text(
                      //                   '${HomeContainer.currencySymbol} ${prepOrderModel.webOrder.order.taxValue.toStringAsFixed(2)}'),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
                Text(':'),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${HomeContainer.currencySymbol} ${model.order.taxValue.toStringAsFixed(2)}',
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
                  '${HomeContainer.currencySymbol} ${getTotalPriceOfOrder(model.order).toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Bill Details',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(),
        for (OrderDetails od in model.orderDetails) ...[
          Text(
            '${od.text}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${od.subText}',
            // maxLines: 2,
            // overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 10,
          ),
        ],
        SizedBox(
          height: 10,
        ),
        Divider(),
        FlatButton(
          onPressed: () {
            launch('tel:${model.phoneNumber}');
          },
          child: Text('Call ${model.storeName} (${model.phoneNumber})'),
          textColor: Colors.red,
        ),
      ],
    );
  }

  prcessReorder() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('${model.reOrderMessage}'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
              textColor: THEME_COLOR_PRIMARY,
            ),
            FlatButton(
              onPressed: () async {
                Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
                HEADER_MAP['Authorization'] = API.JWT_AUTH;
                showToast('Please wait, loading your cart');
                var response;
                try {
                  response = await Dio().post(
                    API.REORDER,
                    queryParameters: {
                      "storeKey": API.STORE_KEY,
                      "reOrderId": orderID
                    },
                    options: Options(headers: HEADER_MAP),
                  );
                  StandardResponse res =
                      StandardResponse.fromMap(response.data);
                  if (res.message != null && res.message.isNotEmpty)
                    showToast(res.message);
                  ReOrderModel oModel = ReOrderModel.fromMap(res.data);

                  cart.clear();
                  for (OrderLineItems oli
                      in oModel.webOrder.order.orderLineItems) {
                    CartItem ci = getCartItemFromOrderLineItem(oli);
                    int qty = ci.quantity;
                    ci.quantity = 1;
                    ci.id = null;
                    for (var i = 0; i < qty; i++) {
                      cart.add(ci);
                    }
                  }
                  notifyParent();
                  Navigator.of(context).popAndPushNamed('/cart',
                      arguments: {"cart": cart, "notifyParent": notifyParent});
                } catch (e) {}
              },
              child: Text('PROCEED'),
              textColor: THEME_COLOR_PRIMARY,
            ),
          ],
        );
      },
    );
  }
}
