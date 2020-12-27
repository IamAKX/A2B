import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/utils.dart';
import 'package:singlestore/models/availableOrderTypes.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/displaycategories.dart';
import 'package:singlestore/models/gimageblocks.dart';
import 'package:singlestore/models/homePageGimages.dart';
import 'package:singlestore/models/notificationGimages.dart';
import 'package:singlestore/models/offer.dart';
import 'package:singlestore/models/orderLineItems.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/HomeContainer/bloc/homecontainer_model.dart';
import 'package:singlestore/screens/MainPageCategories/menu_list_horizontal.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class Home extends StatefulWidget {
  TabController tabController;
  Function() notifyParent;
  List<CartItem> cart;
  HomeContainerModel homeModel;
  Home(this.homeModel, this.notifyParent, this.cart, this.tabController)
      : super();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentImageOnBanner = 0;
  int selectedOrderType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSavedOrderType();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // selectedOrderType = (widget.homeModel.availableOrderTypes.length > 0)
    //     ? widget.homeModel.availableOrderTypes.first.id
    //     : 0;
    return ListView(
      children: [
        CarouselSlider(
          items: getBannerImages(widget.homeModel.homePageGimages, context,
              widget.homeModel.displayCategories, widget.tabController),
          options: CarouselOptions(
              height: 220,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageOnBanner = index;
                });
              }),
        ),
        getPrimeMemberShipCard(widget.homeModel.grewards,
            widget.homeModel.store.logoSmall, context),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //   child: Text(
        //     'Order Type',
        //     style: GoogleFonts.manrope(
        //         color: TEXT_COLOR, fontWeight: FontWeight.bold),
        //   ),
        // ),
        SizedBox(
          width: width,
          height: 50,
          child: ListView.builder(
            itemCount: widget.homeModel.availableOrderTypes.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              AvailableOrderTypes orderTypes =
                  widget.homeModel.availableOrderTypes.elementAt(index);
              return Row(
                children: [
                  Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: THEME_COLOR_PRIMARY,
                    value: orderTypes.id,
                    groupValue: selectedOrderType,
                    onChanged: (value) {
                      setState(() {
                        selectedOrderType = value;
                        saveOrderType(selectedOrderType);
                      });
                    },
                  ),
                  InkWell(
                    child: Text(orderTypes.value),
                    onTap: () {
                      setState(() {
                        selectedOrderType = orderTypes.id;
                        saveOrderType(selectedOrderType);
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              );
            },
          ),
        ),
        InkWell(
          onTap: () {
            // Share.share(
            //     widget.homeModel.greferral.message +
            //         '\n\nPrivacy policy : ' +
            //         widget.homeModel.greferral.policyUrl,
            //     subject: 'Single Store Referal');
            Navigator.of(context).pushNamed('/referfriend',
                arguments: widget.homeModel.greferral);
          },
          child: Card(
            margin: EdgeInsets.all(10),
            color: THEME_COLOR_PRIMARY.withAlpha(150),
            elevation: 10,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://img.icons8.com/cotton/64/000000/wallet--v1.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    widget.homeModel.greferral.shortDescription,
                    style: GoogleFonts.manrope(
                        color: TEXT_ON_THEME_COLOR,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),

        for (NotificationGimages n in widget.homeModel.notificationGimages)
          if (n.gimage.active)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  switch (n.gimage.cta) {
                    case 0:
                      break;
                    case 1:
                      Navigator.of(context)
                          .pushNamed('/webview', arguments: n.gimage.target);
                      break;
                    case 2:
                      launchCategoryByCategoryID(
                          widget.homeModel.displayCategories,
                          n.gimage,
                          widget.tabController);
                      break;
                    default:
                      break;
                  }
                },
                child: CachedNetworkImage(
                  imageUrl: n.gimage.path,
                  height: n.heightInPx == null ? 200 : (n.heightInPx * 1.0),
                  width: double.infinity,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'Explore by Category',
            style: GoogleFonts.manrope(
                color: TEXT_COLOR, fontWeight: FontWeight.bold),
          ),
        ),
        getExploreCategoryTiles(
            widget.tabController, widget.homeModel.allCategoriesWithoutItems),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'Offers',
            style: GoogleFonts.manrope(
                color: TEXT_COLOR, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 100,
          child: ListView.builder(
            itemCount: widget.homeModel.offers.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              OfferModel offerModel = widget.homeModel.offers.elementAt(index);
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 100,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        THEME_COLOR_PRIMARY,
                        THEME_COLOR_PRIMARY.withOpacity(0.7),
                        THEME_COLOR_PRIMARY.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offerModel.promocode,
                            style: GoogleFonts.manrope(
                              color: TEXT_ON_THEME_COLOR,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            offerModel.shortDescription,
                            style: GoogleFonts.manrope(
                              color: TEXT_ON_THEME_COLOR,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      CachedNetworkImage(
                        imageUrl:
                            'https://www.onlygfx.com/wp-content/uploads/2018/04/discount-stamp-4.png',
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        for (DisplayCategories dc in widget.homeModel.displayCategories) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              dc.name,
              style: GoogleFonts.manrope(
                  color: TEXT_COLOR, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 240,
            width: double.maxFinite,
            child:
                MenuListHorizaontal(widget.notifyParent, widget.cart, dc.items),
          ),
        ],
        for (GimageBlocks gImgBlks in widget.homeModel.gimageBlocks)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  gImgBlks.heading,
                  style: GoogleFonts.manrope(
                      color: TEXT_COLOR, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: gImgBlks.heightInPx != null
                    ? double.parse(gImgBlks.heightInPx.toString())
                    : 200,
                width: double.maxFinite,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (HomePageGimages homePageGimages in gImgBlks.gimages)
                      if (homePageGimages.active)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            child: InkWell(
                              onTap: () {
                                switch (homePageGimages.cta) {
                                  case 0:
                                    break;
                                  case 1:
                                    Navigator.of(context).pushNamed('/webview',
                                        arguments: homePageGimages.target);
                                    break;
                                  case 2:
                                    launchCategoryByCategoryID(
                                        widget.homeModel.displayCategories,
                                        homePageGimages,
                                        widget.tabController);
                                    break;
                                  default:
                                    break;
                                }
                              },
                              child: Image.network(
                                homePageGimages.path,
                                height: double.maxFinite,
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width - 90,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        for (NotificationGimages n in widget.homeModel.advertisements)
          if (n.gimage.active)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  switch (n.gimage.cta) {
                    case 0:
                      break;
                    case 1:
                      Navigator.of(context)
                          .pushNamed('/webview', arguments: n.gimage.target);
                      break;
                    case 2:
                      launchCategoryByCategoryID(
                          widget.homeModel.displayCategories,
                          n.gimage,
                          widget.tabController);
                      break;
                    default:
                      break;
                  }
                },
                child: CachedNetworkImage(
                  imageUrl: n.gimage.path,
                  height: n.heightInPx == null ? 200 : (n.heightInPx * 1.0),
                  width: double.infinity,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        Card(
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      width: double.maxFinite,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: THEME_COLOR_PRIMARY),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Bulk/Party order?\n',
                          style: GoogleFonts.manrope(
                            color: TEXT_COLOR,
                            fontSize: 18,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'Get Special Discounts and\ndelivery for Bulk orders',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/contact'),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: double.maxFinite,
                        height: 30,
                        color: THEME_COLOR_PRIMARY.withOpacity(0.7),
                        child: Row(
                          children: [
                            Text(
                              'Contact Us',
                              style: GoogleFonts.manrope(
                                color: TEXT_ON_THEME_COLOR,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset('assets/images/GetImage.png'),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        CachedNetworkImage(
          imageUrl: widget.homeModel.store.logoSmall,
          height: 80,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            widget.homeModel.store.fullname,
            style: GoogleFonts.manrope(
                color: TEXT_COLOR, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            widget.homeModel.store.tagline,
            style: GoogleFonts.manrope(
              color: TEXT_COLOR,
              fontSize: 14,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            widget.homeModel.store.address,
            style: GoogleFonts.manrope(
              color: TEXT_COLOR,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }

  void saveOrderType(int selectedOrderType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('orderType', selectedOrderType);
    logger.d('saving order type $selectedOrderType');
  }

  Future<void> getSavedOrderType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('orderType') != null)
      selectedOrderType = prefs.getInt('orderType');
    logger.d('getting order type ${prefs.getInt('orderType')}');
    setState(() {});
  }
}
