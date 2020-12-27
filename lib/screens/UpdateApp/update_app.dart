import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/widgets/custom_appbars.dart';
import 'package:store_redirect/store_redirect.dart';

class UpdateApp extends StatefulWidget {
  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppbar('Update Available', []),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/update.svg',
            semanticsLabel: 'No Rewards',
            height: 200,
            width: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Please update the app to continue.',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () {
              StoreRedirect.redirect();
            },
            child: Text('Update'),
            color: THEME_COLOR_PRIMARY,
            textColor: Colors.white,
          )
        ],
      )),
    );
  }
}
