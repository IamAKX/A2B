import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/models/customer_model.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/widgets/custom_appbars.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String userId;
  String userPhone;

  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocalDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppbar('My Account', []),
      body: body(context),
    );
  }

  body(context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            onPressed: () async {
              await showUpdateProfileModalBottomSheet(context);
            },
            child: Text(
              'Edit',
              style: TextStyle(color: THEME_COLOR_PRIMARY),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: 80,
          height: 80,
          child: CachedNetworkImage(
              imageUrl:
                  'https://i0.wp.com/www.repol.copl.ulaval.ca/wp-content/uploads/2019/01/default-user-icon.jpg'),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          userName.text == null ? '' : userName.text,
          style: GoogleFonts.manrope(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        Text(
          userPhone == null ? '' : userPhone,
          style: GoogleFonts.manrope(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        Text(
          userEmail.text == null ? '' : userEmail.text,
          style: GoogleFonts.manrope(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Container(
          width: double.maxFinite,
          child: RaisedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/onboarding', (Route<dynamic> route) => false);
            },
            child: Text('LOG OUT'),
            color: THEME_COLOR_PRIMARY,
            textColor: Colors.white,
          ),
        )
      ],
    );
  }

  showUpdateProfileModalBottomSheet(context) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true, // important
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Title(
                            color: THEME_COLOR_PRIMARY,
                            child: Text(
                              'Profile Update',
                              style: TextStyle(
                                  color: THEME_COLOR_PRIMARY,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                            textColor: THEME_COLOR_PRIMARY,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildInputFieldThemColor(
                          'Name', Icons.person, TextInputType.name, userName),
                      buildInputFieldThemColor('Email', Icons.email,
                          TextInputType.emailAddress, userEmail),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: double.maxFinite,
                        child: RaisedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            prefs.setString('userName', userName.text);
                            prefs.setString('userEmail', userEmail.text);

                            Navigator.of(context).pop();
                            updateCustomerDetails();

                            setState(() {});
                          },
                          child: Text('Save'),
                          textColor: Colors.white,
                          color: THEME_COLOR_PRIMARY,
                        ),
                      ),
                      Container(
                        height: 230,
                        width: double.maxFinite,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> updateCustomerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    String url =
        API.BASE_URL + '/api/app/singlestore/customer/updateAccountDetails';

    var response;

    try {
      response = await Dio().post(
        url,
        data: {
          "emailId": prefs.getString('userEmail'),
          "emailVerified": false,
          "fullName": prefs.getString('userName'),
          "mobileNo": prefs.getString('userNumber'),
          "mobileVerified": true,
          "storeKey": API.STORE_KEY
        },
        queryParameters: {
          "storeKey": API.STORE_KEY,
        },
        options: Options(headers: HEADER_MAP),
      );
      StandardResponse res = StandardResponse.fromMap(response.data);
      if (res.message != null && res.message.isNotEmpty) showToast(res.message);
      showToast('Profile updated');
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchLocalDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    String url = API.BASE_URL + '/api/app/singlestore/customer';

    var response;

    try {
      response = await Dio().get(
        url,
        queryParameters: {
          "storeKey": API.STORE_KEY,
        },
        options: Options(headers: HEADER_MAP),
      );
      StandardResponse res = StandardResponse.fromMap(response.data);
      if (res.message != null && res.message.isNotEmpty) showToast(res.message);
      CustomerDetailsModel cModel = CustomerDetailsModel.fromMap(res.data);

      prefs.setString('userName', cModel.fullName);
      prefs.setString('userEmail', cModel.emailId);
      prefs.setString('userNumber', cModel.mobileNo);

      userId = prefs.getString('userID');
      userPhone = prefs.getString('userNumber');
      userName.text = prefs.getString('userName');
      userEmail.text = prefs.getString('userEmail');
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
