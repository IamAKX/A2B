import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:singlestore/configs/colors.dart';

class AppIntro extends StatefulWidget {
  @override
  _AppIntroState createState() => _AppIntroState();
}

class _AppIntroState extends State<AppIntro> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IntroViewsFlutter(
        pages,
        showSkipButton: false,
        onTapDoneButton: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/onboarding', (Route<dynamic> route) => false);
        },
        pageButtonTextStyles: GoogleFonts.manrope(
          color: THEME_COLOR_PRIMARY,
          fontSize: 18,
        ),
        fullTransition: 150,
      ), //IntroViewsFlutter
    );
  }

  List<PageViewModel> pages = [
    PageViewModel(
      bubbleBackgroundColor: THEME_COLOR_PRIMARY.withOpacity(0.2),
      pageColor: Colors.white,
      bubble: SvgPicture.asset(
        'assets/svg/food.svg',
        semanticsLabel: 'Under development',
        width: 10,
        height: 10,
      ),
      body: Text(
        'Food from India, China, Italy and all corners',
        style: GoogleFonts.manrope(
            color: TEXT_COLOR, fontSize: 20, fontWeight: FontWeight.w300),
      ),
      title: Text(
        'Large Varity Of Food',
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(
            color: THEME_COLOR_PRIMARY,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      ),
      mainImage: SvgPicture.asset(
        'assets/svg/food.svg',
        semanticsLabel: 'Under development',
        width: 150,
        height: 150,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      bubbleBackgroundColor: THEME_COLOR_PRIMARY.withOpacity(0.2),
      pageColor: Colors.white,
      bubble: SvgPicture.asset(
        'assets/svg/cook.svg',
        semanticsLabel: 'Under development',
        width: 10,
        height: 10,
      ),
      body: Text(
        'From the kitchen of hand-picked chefs of India',
        style: GoogleFonts.manrope(
            color: TEXT_COLOR, fontSize: 20, fontWeight: FontWeight.w300),
      ),
      title: Text(
        'Best Chef In-House',
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(
            color: THEME_COLOR_PRIMARY,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      ),
      mainImage: SvgPicture.asset(
        'assets/svg/cook.svg',
        semanticsLabel: 'Under development',
        width: 150,
        height: 150,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      bubbleBackgroundColor: THEME_COLOR_PRIMARY.withOpacity(0.2),
      pageColor: Colors.white,
      bubble: SvgPicture.asset(
        'assets/svg/delivery.svg',
        semanticsLabel: 'Under development',
        width: 10,
        height: 10,
      ),
      body: Text(
        'Blazing fast delivery in all weathers, all time',
        style: GoogleFonts.manrope(
            color: TEXT_COLOR, fontSize: 20, fontWeight: FontWeight.w300),
      ),
      title: Text(
        'Deliver Right On Time',
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(
            color: THEME_COLOR_PRIMARY,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      ),
      mainImage: SvgPicture.asset(
        'assets/svg/delivery.svg',
        semanticsLabel: 'Under development',
        width: 150,
        height: 150,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      bubbleBackgroundColor: THEME_COLOR_PRIMARY.withOpacity(0.2),
      pageColor: Colors.white,
      bubble: SvgPicture.asset(
        'assets/svg/eating.svg',
        semanticsLabel: 'Under development',
        width: 10,
        height: 10,
      ),
      body: Text(
        '27 branches across the nation',
        style: GoogleFonts.manrope(
            color: TEXT_COLOR, fontSize: 20, fontWeight: FontWeight.w300),
      ),
      title: Text(
        'Eat-Out At Nearby Branch',
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(
            color: THEME_COLOR_PRIMARY,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      ),
      mainImage: SvgPicture.asset(
        'assets/svg/eating.svg',
        semanticsLabel: 'Under development',
        width: 150,
        height: 150,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      bubbleBackgroundColor: THEME_COLOR_PRIMARY.withOpacity(0.2),
      pageColor: Colors.white,
      bubble: SvgPicture.asset(
        'assets/svg/online_order.svg',
        semanticsLabel: 'Under development',
        width: 10,
        height: 10,
      ),
      body: Text(
        'Order online from vast range for taste based on your mood',
        style: GoogleFonts.manrope(
            color: TEXT_COLOR, fontSize: 20, fontWeight: FontWeight.w300),
      ),
      title: Text(
        'Delicious at Fingure Tip',
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(
            color: THEME_COLOR_PRIMARY,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      ),
      mainImage: SvgPicture.asset(
        'assets/svg/online_order.svg',
        semanticsLabel: 'Under development',
        width: 150,
        height: 150,
        alignment: Alignment.center,
      ),
    ),
  ];
}
