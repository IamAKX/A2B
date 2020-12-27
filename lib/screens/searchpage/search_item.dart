import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/utils.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/fooditem.dart';
import 'package:singlestore/models/search_model.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';
import 'package:singlestore/widgets/add_remove_popup.dart';
import 'package:singlestore/widgets/utility_widget.dart';

import '../../main.dart';

class SearchPage extends StatefulWidget {
  var object;
  SearchPage(this.object) : super();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  List<FoodItem> menuList = [];
  Function() notifyParent;
  List<CartItem> cart;
  List<String> favItems = [];
  TextEditingController _seachText = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cart = widget.object['cart'];
    notifyParent = widget.object['notifyParent'];
    if (prefs.getStringList('fav') != null) {
      favItems = prefs.getStringList('fav');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: THEME_COLOR_PRIMARY),
        title: Text(
          'Search',
          style: GoogleFonts.manrope(
            color: THEME_COLOR_PRIMARY,
          ),
        ),
      ),
      body: body(),
    );
  }

  body() {
    menuList.removeWhere((element) => !element.active);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextField(
            controller: _seachText,
            decoration: InputDecoration(
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              suffixIcon: IconButton(
                  icon: Icon(
                    LineAwesomeIcons.search,
                    color: THEME_COLOR_PRIMARY,
                  ),
                  onPressed: () {
                    if (_seachText.text.length < 3)
                      showToast('Enter atleast 3 charaters');
                    else
                      seachItem();
                  }),
              hintText: 'Search something ...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : menuList.isEmpty
                    ? Center(
                        child: SvgPicture.asset(
                          'assets/svg/search.svg',
                          semanticsLabel: 'Under development',
                          height: 200,
                          width: 200,
                        ),
                      )
                    : Stack(
                        children: [
                          displaySearchResults(),
                          Visibility(
                            visible: cart.length > 0,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: TEXT_COLOR,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (cart.length > 1)
                                              ? Text(
                                                  '${cart.length}  ITEMS',
                                                  style: GoogleFonts.manrope(
                                                      letterSpacing: 2,
                                                      color:
                                                          TEXT_ON_THEME_COLOR,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Text(
                                                  '${cart.length}  ITEM',
                                                  style: GoogleFonts.manrope(
                                                      letterSpacing: 2,
                                                      color:
                                                          TEXT_ON_THEME_COLOR,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  '${HomeContainer.currencySymbol} ${getTotalAmountFromCart(cart).toStringAsFixed(2)}',
                                              style: GoogleFonts.manrope(
                                                color: TEXT_ON_THEME_COLOR,
                                                fontSize: 14,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: '      plus taxes',
                                                  style: GoogleFonts.manrope(
                                                    color: TEXT_ON_THEME_COLOR,
                                                    fontSize: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: FlatButton(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          if (prefs.getInt('orderType') != null)
                                            Navigator.of(context)
                                                .pushNamed('/cart', arguments: {
                                              "cart": cart,
                                              "notifyParent": notifyParent
                                            });
                                          else
                                            showToast('Select Order type');
                                        },
                                        child: Text(
                                          'Go to Cart',
                                          style: GoogleFonts.manrope(
                                            color: THEME_COLOR_PRIMARY,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  ListView displaySearchResults() => ListView.builder(
        itemCount: menuList.length + 1,
        itemBuilder: (context, index) {
          if (index == menuList.length)
            return Container(
              height: 100,
            );
          FoodItem model = menuList.elementAt(index);
          return Container(
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
                                                model,
                                                context);
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
                                            addToCart(model, cart, notifyParent,
                                                context);
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3))),
                                )
                              : InkWell(
                                  onTap: () {
                                    addToCart(
                                        model, cart, notifyParent, context);
                                    setState(() {});
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3))),
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
                      style:
                          GoogleFonts.manrope(fontSize: 12, color: TEXT_COLOR),
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

  Future<void> seachItem() async {
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    String url = API.BASE_URL + '/api/items/search';

    setState(() {
      isLoading = true;
    });
    var response;
    try {
      response = await Dio().get(
        url,
        queryParameters: {
          "storeKey": API.STORE_KEY,
          "searchTerm": _seachText.text
        },
        options: Options(headers: HEADER_MAP),
      );
      setState(() {
        isLoading = false;
      });
      StandardResponse res = StandardResponse.fromMap(response.data);
      if (res.message != null && res.message.isNotEmpty) showToast(res.message);
      SearchModel model = SearchModel.fromMap(res.data);
      menuList.clear();
      menuList.addAll(model.res);
      setState(() {});
    } catch (e) {}
  }
}
