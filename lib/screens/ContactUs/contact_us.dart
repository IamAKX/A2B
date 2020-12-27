import 'package:flutter/material.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/configs/style.dart';
import 'package:singlestore/widgets/custom_appbars.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppbar('Contact Us', []),
      body: body(),
      backgroundColor: PAGE_BODY_GREY,
    );
  }

  body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.maxFinite,
        ),
        Image.asset(
          'assets/images/logo.png',
          width: 80,
          height: 80,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Tingling finguretips?',
          style: MANROPE_FONT,
        ),
        Text(
          'That\'s magnetic urge to get in touch with us!',
          style: MANROPE_FONT,
        ),
        SizedBox(
          height: 40,
        ),
        RaisedButton(
          color: Colors.white,
          onPressed: () {
            launch("tel://+919502324646");
          },
          child: Text(
            'Call Us Maybe',
            style: MANROPE_FONT,
          ),
        ),
        RaisedButton(
          color: Colors.white,
          onPressed: () {
            final Uri _emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'support@a2b.com',
                queryParameters: {'subject': 'Feedback for A2B'});
            launch(_emailLaunchUri.toString());
          },
          child: Text(
            'Drop us a line',
            style: MANROPE_FONT,
          ),
        ),
      ],
    );
  }
}
