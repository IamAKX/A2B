import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/constants.dart';
import 'package:singlestore/configs/utils.dart';
import 'package:singlestore/models/CategoryModel.dart';
import 'package:singlestore/models/all_order_display_item.dart';
import 'package:singlestore/models/cart_item_model.dart';
import 'package:singlestore/models/cart_item_option_model.dart';
import 'package:singlestore/models/customize.dart';
import 'package:singlestore/models/displaycategories.dart';
import 'package:singlestore/models/food.dart';
import 'package:singlestore/models/grewards.dart';
import 'package:singlestore/models/homePageGimages.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';

import 'add_remove_popup.dart';

getMainMenuTabs(List<CategoryModel> allCategoriesWithoutItems) {
  List<Widget> tabs = [];
  tabs.add(
    Tab(
      text: 'Home',
    ),
  );
  for (CategoryModel model in allCategoriesWithoutItems)
    tabs.add(
      Tab(
        text: model.name,
      ),
    );
  tabs.add(
    Tab(
      text: 'Favourite',
    ),
  );
  return tabs;
}

getListTile(String label, String path, BuildContext context) {
  return InkWell(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(label),
    ),
    onTap: () {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/webview', arguments: path);
    },
  );
}

getIconListTile(
    String label, String path, BuildContext context, IconData icon) {
  return InkWell(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: THEME_COLOR_PRIMARY,
          ),
          SizedBox(
            width: 15,
          ),
          Text(label),
        ],
      ),
    ),
    onTap: () {
      if (path == '/home') {
        // if (Navigator.of(context).canPop()) Navigator.of(context).pop();

        Navigator.of(context).pop();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(path, (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).popAndPushNamed(path);
      }
    },
  );
}

getBannerImages(
        List<HomePageGimages> homePageGimages,
        BuildContext context,
        List<DisplayCategories> displayCategories,
        TabController tabController) =>
    homePageGimages.map((item) {
      if (item.active)
        return Container(
          child: InkWell(
            onTap: () {
              switch (item.cta) {
                case 0:
                  break;
                case 1:
                  Navigator.of(context)
                      .pushNamed('/webview', arguments: item.target);
                  break;
                case 2:
                  launchCategoryByCategoryID(
                      displayCategories, item, tabController);
                  break;
                default:
                  break;
              }
            },
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: item.path,
                        width: 1000,
                        height: 300,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: (item.name != null)
                            ? Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            : Container(),
                      ),
                    ],
                  )),
            ),
          ),
        );
    }).toList();

getPrimeMemberShipCard(Grewards grewards, String logoSmall, context) {
  var cardHeight = 70.0;
  return InkWell(
    onTap: () => Navigator.of(context).pushNamed('/rewardDetail'),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: CachedNetworkImage(
              imageUrl: logoSmall,
              width: 70,
              height: 70,
            ),
          ),
          Container(
            height: cardHeight,
            width: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: cardHeight / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        grewards.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: THEME_COLOR_PRIMARY,
                          ),
                          onPressed: () {})
                    ],
                  ),
                ),
                SizedBox(
                  height: cardHeight / 2,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    color: THEME_COLOR_PRIMARY.withOpacity(0.3),
                    child: Text(
                      '${grewards.value} Points',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: THEME_COLOR_PRIMARY,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Padding getExploreCategoryTiles(TabController tabController,
    List<CategoryModel> allCategoriesWithoutItems) {
  List<Widget> categoryCardList = [];
  for (int i = 0; i < allCategoriesWithoutItems.length; i++) {
    CategoryModel c = allCategoriesWithoutItems.elementAt(i);
    if (c.active) {
      categoryCardList.add(
        InkWell(
          onTap: () => tabController.animateTo(i + 1),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: (c.image != null)
                        ? c.image
                        : 'https://scx2.b-cdn.net/gfx/news/hires/2016/howcuttingdo.jpg',
                    height: double.maxFinite,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/food_category_placeholder.jpg',
                      height: double.maxFinite,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/food_category_placeholder.jpg',
                      height: double.maxFinite,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  child: Text(
                    c.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      color: TEXT_COLOR,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  return Padding(
    padding: EdgeInsets.all(10),
    child: GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: categoryCardList,
    ),
  );
}

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: TEXT_COLOR.withOpacity(0.7),
      textColor: TEXT_ON_THEME_COLOR,
      fontSize: 16.0);
}

buildInputFieldThemColor(String label, IconData icon, TextInputType type,
    TextEditingController controller) {
  return Column(
    children: [
      SizedBox(
        height: 20,
      ),
      TextFormField(
        controller: controller,
        textInputAction: TextInputAction.done,
        autocorrect: true,
        keyboardType: type,
        cursorColor: THEME_COLOR_PRIMARY,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: THEME_COLOR_PRIMARY),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: THEME_COLOR_PRIMARY,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              width: 2,
              color: THEME_COLOR_PRIMARY,
              style: BorderStyle.solid,
            ),
          ),
        ),
      )
    ],
  );
}

Widget chip(String label, Color color) {
  return Chip(
    backgroundColor: color.withOpacity(0.1),
    labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
    label: Text(
      label,
      style: TextStyle(color: color, fontSize: 12),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    padding: EdgeInsets.zero,
  );
}
