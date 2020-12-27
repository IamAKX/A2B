import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/utils.dart';
import 'package:singlestore/main.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/fooditem.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';
import 'package:singlestore/screens/MainPageCategories/bloc/menulist_bloc.dart';
import 'package:singlestore/screens/MainPageCategories/bloc/menulist_model.dart';
import 'package:singlestore/widgets/add_remove_popup.dart';

class MenuListStateless extends StatelessWidget {
  String foodCategory;
  Function() notifyParent;
  int categoryID;
  List<CartItem> cart;
  TabController tabController;

  MenuListStateless(this.foodCategory, this.notifyParent, this.cart,
      this.tabController, this.categoryID)
      : super();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenulistBloc>(
      create: (BuildContext context) => MenulistBloc(),
      child:
          MenuList(foodCategory, notifyParent, cart, tabController, categoryID),
    );
  }
}

class MenuList extends StatefulWidget {
  String foodCategory;
  Function() notifyParent;
  int categoryID;
  List<CartItem> cart;
  TabController tabController;
  MenuList(this.foodCategory, this.notifyParent, this.cart, this.tabController,
      this.categoryID)
      : super();

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  List<FoodItem> menuList = [];
  List<String> favItems = [];

  @override
  Widget build(BuildContext context) {
    if (prefs.getStringList('fav') != null) {
      favItems = prefs.getStringList('fav');
    }
    MenulistBloc _menulistBloc = BlocProvider.of<MenulistBloc>(context);
    _menulistBloc.add(
      FetchHomeData(widget.categoryID),
    );
    return BlocListener<MenulistBloc, MenulistState>(
      bloc: _menulistBloc,
      listener: (context, state) {
        if (state is ErrorState) {
        } else {}
      },
      child: BlocBuilder<MenulistBloc, MenulistState>(
        builder: (context, state) {
          if (state is ProcessingState || state is MenulistInitial)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is ErrorState)
            return Center(
              child: Text('Error'),
            );
          if (state is SuccessState) return body(state.getResponse.data);
        },
      ),
    );
  }

  WillPopScope body(MenuListModel model) {
    menuList.clear();
    menuList.addAll(model.items);
    menuList.removeWhere((element) => !element.active);
    return WillPopScope(
      onWillPop: () {
        widget.tabController.animateTo(0);
      },
      child: ListView.builder(
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
                                  getCartItemFromFoodItem(model), widget.cart))
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
                                                widget.cart,
                                                widget.notifyParent,
                                                model,
                                                context);
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
                                            '${getCountOfItemInCart(model, widget.cart)}',
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
                                            addToCart(model, widget.cart,
                                                widget.notifyParent, context);
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
                                    addToCart(model, widget.cart,
                                        widget.notifyParent, context);
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
      ),
    );
  }
}
