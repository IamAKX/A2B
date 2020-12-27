import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNode = FocusNode();
  TextEditingController textContoller = TextEditingController();
  String countryCode = '+1';
  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 450.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    KeyboardVisibility.onChange.listen((bool visible) {
      if (!visible) FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      body: body(),
    );
  }

  body() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(20),
          color: PAGE_BODY_GREY,
          elevation: 10,
          child: Container(
            width: width,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign In/Sign Up',
                  style: GoogleFonts.manrope(
                      color: TEXT_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextField(
                        focusNode: _focusNode,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: textContoller,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          prefix: CountryCodePicker(
                            initialSelection: 'US',
                            favorite: ['+1'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            textStyle: TextStyle(fontSize: 15),
                            onChanged: (value) {
                              setState(() {
                                countryCode = value.dialCode;
                              });
                            },
                          ),
                          labelStyle: GoogleFonts.manrope(
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                        cursorColor: TEXT_COLOR,
                      ),
                      Container(
                        width: width,
                        child: RaisedButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (textContoller.text.isEmpty ||
                                textContoller.text.length != 10) {
                              showToast('Enter a valid mobile number');
                              return;
                            }
                            Navigator.of(context).pushNamed('/otp', arguments: {
                              "countryCode": countryCode,
                              "mobileNumber": textContoller.text
                            });
                          },
                          color: THEME_COLOR_PRIMARY,
                          child: Text(
                            'Proceed',
                            style: GoogleFonts.manrope(
                                color: TEXT_ON_THEME_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: _animation.value),
      ],
    );
  }
}
