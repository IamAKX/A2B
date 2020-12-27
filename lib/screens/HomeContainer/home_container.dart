import 'dart:developer';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/constants.dart';
import 'package:singlestore/configs/style.dart';
import 'package:singlestore/configs/utils.dart';
import 'package:singlestore/models/CategoryModel.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/orderLineItems.dart';

import 'package:singlestore/screens/HomeContainer/bloc/homecontainer_bloc.dart';
import 'package:singlestore/screens/HomeContainer/bloc/homecontainer_model.dart';
import 'package:singlestore/screens/MainPageCategories/favroite.dart';
import 'package:singlestore/screens/MainPageCategories/home.dart';
import 'package:singlestore/screens/MainPageCategories/menu_list.dart';
import 'package:singlestore/widgets/utility_widget.dart';

import '../../main.dart';

class HomeContainerStateLess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomecontainerBloc>(
      create: (BuildContext context) => HomecontainerBloc(),
      child: HomeContainer(),
    );
  }
}

class HomeContainer extends StatefulWidget {
  static String currencySymbol = 'Rs.';
  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer>
    with TickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  String _selectedLocation;
  HomeContainerModel homeModel;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CartItem> cart = [];
  static bool fstLoad = false;
  Logger logger = Logger();
  refreshState() {
    setState(() {
      takeCartBackup();
    });
  }

  Future<void> takeCartBackup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listBack = [];
    for (CartItem ci in cart) listBack.add(ci.toJson());
    prefs.setStringList('backuplist', listBack);

    logger.i('Taking backup : ${prefs.getStringList('backuplist').length}');
  }

  Future<void> loadCartFromBackup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cart.clear();
    if (prefs.getStringList('backuplist') != null) {
      List<String> listBack = prefs.getStringList('backuplist');
      for (String s in listBack) {
        cart.add(CartItem.fromJson(s));
      }
      setState(() {});
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedLocation = BRANCHES.elementAt(0).name;
    loadCartFromBackup();
  }

  @override
  Widget build(BuildContext context) {
    HomecontainerBloc _homeContainerBloc =
        BlocProvider.of<HomecontainerBloc>(context);
    // if (!fstLoad) {
    fstLoad = true;
    _homeContainerBloc.add(
      FetchHomeData(API.STORE_KEY),
    );
    // }

    return Scaffold(
      key: _scaffoldKey,
      drawer: buildNavDrawer(),
      body: BlocListener<HomecontainerBloc, HomecontainerState>(
        bloc: _homeContainerBloc,
        listener: (context, state) {
          if (state is ErrorState) {
          } else {}
        },
        child: BlocBuilder<HomecontainerBloc, HomecontainerState>(
          builder: (context, state) {
            if (state is ProcessingState || state is HomecontainerInitial)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (state is ErrorState) {
              if (state.getResponse.status == '401')
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/onboarding', (Route<dynamic> route) => false);
              return Center(
                child: Text('${state.getResponse.message}'),
              );
            }
            if (state is SuccessState) {
              homeModel = state.getResponse.data;

              return body(state.getResponse.data);
            }
          },
        ),
      ),
    );
  }

  Drawer buildNavDrawer() => Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: TEXT_COLOR,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    'Menu',
                    style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 50,
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            getIconListTile('Home', '/home', context, Icons.home),
            getIconListTile(
                'My Account', '/account', context, Icons.person_outline),
            InkWell(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: THEME_COLOR_PRIMARY,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('My orders'),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).popAndPushNamed(
                  '/orders',
                  arguments: {
                    "cart": cart,
                    "notifyParent": refreshState,
                  },
                );
              },
            ),

            getIconListTile(
                'My Rewards', '/rewardDetail', context, Icons.attach_money),
            InkWell(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: THEME_COLOR_PRIMARY,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Favourite'),
                  ],
                ),
              ),
              onTap: () {
                _tabController
                    .animateTo(homeModel.allCategoriesWithoutItems.length + 1);
                Navigator.of(context).pop();
              },
            ),
            // getIconListTile('Notification', '/notification', context,
            //     Icons.notifications_none),
            Divider(
              color: Colors.grey,
            ),
            getIconListTile(
                'Contact Us', '/contact', context, Icons.chat_bubble_outline),
            Divider(
              color: Colors.grey,
            ),
            InkWell(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('Refer a Friend'),
              ),
              onTap: () {
                if (homeModel != null)
                  Navigator.of(context).pushNamed('/referfriend',
                      arguments: homeModel.greferral);
              },
            ),
            getListTile('Feedback', API.FEED_BACK, context),
            getListTile('Terms and Conditions', API.TandC, context),
            getListTile('FAQ\'s', API.FAQ, context),
            getListTile('Privacy Policy', API.PRIVACY_POLICY, context),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  'Version ${packageInfo.version}',
                ),
              ),
            ),
          ],
        ),
      );

  showBranchChooser(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Choose Branch',
          style: MANROPE_FONT,
        ),
        content: ListView.builder(
          shrinkWrap: true,
          itemCount: BRANCHES.length,
          itemBuilder: (context, index) {
            String name = BRANCHES.elementAt(index).name;
            String address = BRANCHES.elementAt(index).address;
            return ListTile(
              title: Text(
                name,
                style: MANROPE_FONT,
              ),
              subtitle: Text(
                address,
                style: GoogleFonts.manrope(fontSize: 12),
              ),
              onTap: () {
                setState(() {
                  _selectedLocation = name;
                });
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }

  Widget body(HomeContainerModel homeContainerModel) {
    // HomecontainerBloc _homeContainerBloc =
    //     BlocProvider.of<HomecontainerBloc>(context);
    // cart.clear();
    // for (OrderLineItems oli in homeContainerModel.order.orderLineItems) {
    //   cart.add(getCartItemFromOrderLineItem(oli));
    // }
    HomeContainer.currencySymbol = homeContainerModel.store.currency;
    _selectedLocation = homeContainerModel.store.shortAddress;
    if (_tabController == null)
      _tabController = TabController(
          length: homeContainerModel.allCategoriesWithoutItems.length + 2,
          vsync: this);
    _scrollController = ScrollController();
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            elevation: 10,
            forceElevated: true,
            backgroundColor: Colors.white,
            actions: [
              // IconButton(
              //   icon: Icon(
              //     Icons.search,
              //     color: TEXT_COLOR,
              //   ),
              //   onPressed: () {
              //     // showBranchChooser(context);
              //   },
              // )
            ],
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: TEXT_COLOR,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    }),
                // CachedNetworkImage(
                //   imageUrl: homeContainerModel.store.logoSmall,
                //   height: 50,
                //   width: 60,
                // ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homeContainerModel.store.name,
                      style: GoogleFonts.manrope(color: TEXT_COLOR),
                    ),
                    InkWell(
                      onTap: () {
                        if (homeContainerModel.store.hasLinkedStores)
                          Navigator.of(context)
                              .pushNamed('/store')
                              .then((value) {
                            setState(() {});
                          });
                      },
                      child: Row(
                        children: [
                          Text(
                            _selectedLocation,
                            style: GoogleFonts.manrope(
                              color: TEXT_COLOR,
                              textStyle: GoogleFonts.manrope(fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.store,
                            color: TEXT_COLOR,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: TEXT_COLOR,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/search',
                      arguments: {
                        "cart": cart,
                        "notifyParent": refreshState,
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Colors.grey,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 25.0,
                  indicatorColor: THEME_COLOR_PRIMARY,
                  tabBarIndicatorSize: TabBarIndicatorSize.label,
                ),
                controller: _tabController,
                tabs: getMainMenuTabs(
                    homeContainerModel.allCategoriesWithoutItems),
              ),
            ),
            pinned: true,
          )
        ];
      },
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          TabBarView(
            controller: _tabController,
            children: [
              Home(homeContainerModel, refreshState, cart, _tabController),
              for (CategoryModel c
                  in homeContainerModel.allCategoriesWithoutItems)
                // MenuListStateless(
                //     c.name, refreshState, cart, _tabController, c.id),
                MenuListStateless(
                    c.name, refreshState, cart, _tabController, c.id),
              WillPopScope(
                onWillPop: () {
                  _tabController.animateTo(0);
                },
                child: FavouriteItems(refreshState, cart, _tabController),
              ),
            ],
          ),
          Visibility(
            visible: cart.length > 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (cart.length > 1)
                              ? Text(
                                  '${cart.length}  ITEMS',
                                  style: GoogleFonts.manrope(
                                      letterSpacing: 2,
                                      color: TEXT_ON_THEME_COLOR,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  '${cart.length}  ITEM',
                                  style: GoogleFonts.manrope(
                                      letterSpacing: 2,
                                      color: TEXT_ON_THEME_COLOR,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
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
                              await SharedPreferences.getInstance();
                          if (prefs.getInt('orderType') != null)
                            Navigator.of(context).pushNamed('/cart',
                                arguments: {
                                  "cart": cart,
                                  "notifyParent": refreshState
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
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
