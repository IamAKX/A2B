import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/constants.dart';
import 'package:singlestore/configs/utils.dart';
import 'package:singlestore/models/all_order_display_item.dart';
import 'package:singlestore/models/all_order_model.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/food.dart';
import 'package:singlestore/models/orderLineItems.dart';
import 'package:singlestore/models/reorder_model.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';
import 'package:singlestore/widgets/custom_appbars.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class MyOrders extends StatefulWidget {
  var object;
  MyOrders(this.object) : super();
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int page = 0;
  List<DisplayOrders> orderList = [];
  Function() notifyParent;
  List<CartItem> cart;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cart = widget.object['cart'];
    notifyParent = widget.object['notifyParent'];
    loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppbar('My Orders', []),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : orderList == null || orderList.isEmpty
              ? Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/no_order.svg',
                      semanticsLabel: 'No Rewards',
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No Reward Earned',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ))
              : body(),
    );
  }

  body() {
    return LazyLoadScrollView(
      onEndOfPage: () {
        loadOrders();
      },
      child: ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          DisplayOrders order = orderList.elementAt(index);
          return InkWell(
            child: getAllOrderCard(order),
            onTap: () => Navigator.of(context).pushNamed(
              '/ordersummary',
              arguments: {
                "orderID": order.orderId,
                "cart": cart,
                "notifyParent": notifyParent,
              },
            ),
          );
        },
      ),
    );
  }

  prcessReorder(DisplayOrders order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('${order.reOrderMessage}'),
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
                      "reOrderId": order.orderId
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

  Future<void> loadOrders() async {
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    setState(() {
      isLoading = true;
    });
    var response;

    try {
      response = await Dio().get(
        API.LOAD_ORDER + page.toString(),
        queryParameters: {
          "storeKey": API.STORE_KEY,
        },
        options: Options(headers: HEADER_MAP),
      );
      setState(() {
        isLoading = false;
      });
      StandardResponse res = StandardResponse.fromMap(response.data);
      if (res.message != null && res.message.isNotEmpty) showToast(res.message);
      AllOrderModel oModel = AllOrderModel.fromMap(res.data);
      if (oModel.displayOrders != null && oModel.displayOrders.isNotEmpty) {
        orderList.addAll(oModel.displayOrders);
        page++;
        setState(() {});
      }
    } catch (e) {}
  }

  Card getAllOrderCard(DisplayOrders order) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'ORDER NO : ${order.orderNumber}',
                      style: TextStyle(fontSize: 12),
                    ),
                    color: Colors.grey.withOpacity(0.2),
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                    child: Text(
                      '${order.numberOfItems} ITEMS',
                      style: TextStyle(fontSize: 12),
                    ),
                    color: Colors.grey.withOpacity(0.2),
                    padding: EdgeInsets.all(5),
                  ),
                ],
              ),
            ),
            Divider(),
            Text(
              'ITEMS',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${order.items}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'ORDERED ON',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${order.orderedOn}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL AMOUNT',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'ORDER STATUS',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${HomeContainer.currencySymbol} ${order.totalAmount.toStringAsFixed(2)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${order.orderStatus}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.orderType}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                RaisedButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    prcessReorder(order);
                  },
                  child: Text('REORDER'),
                  color: THEME_COLOR_PRIMARY,
                  textColor: Colors.white,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
