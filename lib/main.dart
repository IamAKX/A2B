import 'package:country_code_picker/country_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/screens/AppIntro/app_intro.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';
import 'package:singlestore/screens/Onboarding/onboarding.dart';
import 'package:singlestore/screens/Store/store_page.dart';
import 'package:singlestore/screens/UpdateApp/update_app.dart';

import 'configs/api.dart';
import 'configs/navigator.dart';

SharedPreferences prefs;
String userID;
String appVersion = 'success';
PackageInfo packageInfo;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();
  prefs = await SharedPreferences.getInstance();
  userID = prefs.getString('userID');
  API.STORE_KEY = prefs.getString('storeKey');
  if (prefs.getString('jwt') != null)
    API.JWT_AUTH = 'Bearer ' + prefs.getString('jwt');
  // API.STORE_KEY = 'storeKey1';
  logger.e(API.STORE_KEY);

  String url = API.BASE_URL + '/api/app/singlestore/appversionvalid';

  var response;

  try {
    response = await Dio().get(
      url,
      queryParameters: {
        "appVersion": packageInfo.version,
      },
    );
    logger.e('app version : ${packageInfo.version}');
    logger.e(response.data);
    appVersion = response.data['status'];
    logger.e('app version status : $appVersion');
  } catch (e) {}

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en'),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      title: 'A2B',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orangeAccent[500],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: appVersion != 'success'
          ? UpdateApp()
          : API.JWT_AUTH.length < 8
              ? AppIntro()
              : API.STORE_KEY == '' || API.STORE_KEY == null
                  ? StorePage()
                  : HomeContainerStateLess(),
      onGenerateRoute: NavRouter.generatedRoute,
    );
  }
}
