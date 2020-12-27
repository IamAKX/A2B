import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/models/favourite_ids.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class OTP extends StatefulWidget {
  var arguments;
  OTP(this.arguments) : super();

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  bool _isResendVisible = false;
  Timer _timer;
  int _otpTimeoutDuration = 60;
  int _currentInstant = 1;
  var countryCode = '';
  var mobileNumber = '';
  var otpCode = "";
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countryCode = widget.arguments['countryCode'];
    mobileNumber = widget.arguments['mobileNumber'];
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  void startTimer() {
    login();
    _currentInstant = 1;
    _isResendVisible = false;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_currentInstant == _otpTimeoutDuration) {
            timer.cancel();
            _isResendVisible = true;
          } else {
            _currentInstant++;
          }
        },
      ),
    );
  }

  body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Log into OrderToGo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    color: TEXT_COLOR,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'One Time Password (OTP) has been shared to your mobile number',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    color: SUB_HEADER_COLOR,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Text(
            '${countryCode} ${mobileNumber}',
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: PinCodeTextField(
                highlight: true,
                wrapAlignment: WrapAlignment.center,
                defaultBorderColor: Colors.transparent,
                hasTextBorderColor: Colors.transparent,
                pinBoxColor: THEME_COLOR_PRIMARY.withOpacity(0.3),
                highlightColor: THEME_COLOR_PRIMARY.withOpacity(0.5),
                pinTextStyle: GoogleFonts.openSans(fontSize: 18),
                maxLength: 6,
                pinBoxHeight: 50,
                pinBoxWidth: 50,
                onDone: (text) async {
                  logger.e(countryCode + mobileNumber.trim());
                  var response;
                  try {
                    response = await Dio().post(
                      API.BASE_URL + '/api/login/validate',
                      data: {
                        "storeCommonKey": API.COMMON_STORE_KEY,
                        "username": countryCode + mobileNumber.trim(),
                        "otp": text,
                      },
                      options: Options(
                        receiveTimeout: 60000,
                        sendTimeout: 30000,
                      ),
                    );
                    StandardResponse res =
                        StandardResponse.fromMap(response.data);
                    if (res.message != null && res.message.isNotEmpty)
                      showToast(res.message);

                    if (res.status == 'success')
                      saveUserProfileLocal(res.data['jwt']);
                    else
                      showToast(res.message);

                    logger.e(response.data);
                  } catch (e) {
                    print(e);
                  }

                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  // '/home', (Route<dynamic> route) => false);
                  // AuthCredential authCredential =
                  //     PhoneAuthProvider.getCredential(
                  //         verificationId: otpCode, smsCode: text.trim());
                  // AuthResult result =
                  //     await _auth.signInWithCredential(authCredential);
                  // FirebaseUser user = result.user;
                  // if (user != null) {
                  //   showToast('Login successful');
                  //   saveUserProfileLocal(user);
                  // } else {
                  //   showToast('Failed to log in');
                  // }
                  _timer.cancel();
                }
                // onDone: (text) => Navigator.of(context).pushNamed('/home'),
                ),
          ),
          (_isResendVisible)
              ? FlatButton(
                  onPressed: () {
                    startTimer();
                  },
                  child: Text(
                    'Resend OTP',
                    style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: THEME_COLOR_PRIMARY,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 3,
                  percent: _currentInstant / _otpTimeoutDuration,
                  center: Text('${_otpTimeoutDuration - _currentInstant}'),
                  progressColor: THEME_COLOR_PRIMARY.withOpacity(0.8),
                ),
          SizedBox(
            height: 30,
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }

  //login or reg
  Future<bool> login() async {
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;
    logger.e(countryCode + mobileNumber.trim());
    var response;
    try {
      response = await Dio().post(
        API.BASE_URL + '/api/login/getOtp',
        data: {
          "storeCommonKey": API.COMMON_STORE_KEY,
          "username": countryCode + mobileNumber.trim()
        },
        options: Options(
          receiveTimeout: 60000,
          sendTimeout: 30000,
        ),
      );

      logger.e(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveUserProfileLocal(String jwt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    API.JWT_AUTH = 'Bearer ' + jwt;
    prefs.setString('userNumber', countryCode + mobileNumber);
    prefs.setString('jwt', jwt);
    // setState(() {
    //   isLoading = true;
    // });
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('userID', user.uid);
    // prefs.setString('userNumber', mobileNumber);

    // Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    // HEADER_MAP['Authorization'] = API.JWT_AUTH;

    // var response;
    // try {
    //   response = await Dio().get(
    //     API.BASE_URL + '/api/app/singlestore/commonDetails',
    //     queryParameters: {"storeKey": API.STORE_KEY},
    //     options: Options(
    //       headers: HEADER_MAP,
    //       receiveTimeout: 60000,
    //       sendTimeout: 30000,
    //     ),
    //   );
    // } catch (e) {
    //   print(e);
    // }

    // StandardResponse res = StandardResponse.fromMap(response.data);
    // if (res.message != null &&
    //                                     res.message.isNotEmpty)
    //                                   showToast(res.message);
    // showToast(res.message);
    // FavouriteIdModel model = FavouriteIdModel.fromMap(res.data);
    // prefs.setStringList('fav', model.favoriteItemIds.split(','));
    // setState(() {
    //   isLoading = false;
    // });

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/store', (Route<dynamic> route) => false);
  }
}
