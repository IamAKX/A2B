import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:share/share.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/models/greferral.dart';
import 'package:singlestore/widgets/custom_appbars.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferFriend extends StatefulWidget {
  Greferral referalModal;
  ReferFriend(this.referalModal) : super();

  @override
  _ReferFriendState createState() => _ReferFriendState();
}

class _ReferFriendState extends State<ReferFriend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppbar('Refer & Earn', []),
      body: body(),
    );
  }

  body() {
    return Column(
      children: [
        Container(
          height: 200,
          child: Image.asset('assets/images/hug.png'),
        ),
        Text(
          'You friends are our friends too!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Your unique referal code is',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: DottedBorder(
            color: Colors.black,
            strokeWidth: 1,
            dashPattern: [10, 3],
            child: Container(
              width: double.maxFinite,
              child: Text(
                widget.referalModal.code,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/webview',
                arguments: widget.referalModal.policyUrl);
          },
          child: Text(
            'More Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: THEME_COLOR_PRIMARY,
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.referalModal.longDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: OutlineButton.icon(
                  onPressed: () {
                    String msg = widget.referalModal.message +
                        '\n\nPrivacy policy : ' +
                        widget.referalModal.policyUrl;
                    if (Platform.isIOS) {
                      launch("whatsapp://wa.me/?text=${msg}");
                    } else {
                      launch("whatsapp://send?phone=&text=${msg}");
                    }
                  },
                  icon: Icon(
                    LineAwesomeIcons.whatsapp,
                    color: Colors.green,
                  ),
                  label: Text('Whatsapp'),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: OutlineButton.icon(
                  onPressed: () {
                    Share.share(
                        widget.referalModal.message +
                            '\n\nPrivacy policy : ' +
                            widget.referalModal.policyUrl,
                        subject: 'Single Store Referal');
                  },
                  icon: Icon(
                    LineAwesomeIcons.share_alt_square,
                  ),
                  label: Text('More'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
