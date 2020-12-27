import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/models/reward_detail_model.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';
import 'package:singlestore/widgets/custom_appbars.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class RewardDetail extends StatefulWidget {
  @override
  _RewardDetailState createState() => _RewardDetailState();
}

class _RewardDetailState extends State<RewardDetail> {
  bool isLoading = false;
  RewardDetailModel model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadReward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getSimpleAppbar('My Rewards', []),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : model == null
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/no_rewards.svg',
                        semanticsLabel: 'No Rewards',
                        height: 200,
                        width: 200,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Reward Earned',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ))
                : body());
  }

  Future<void> loadReward() async {
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    String url = API.BASE_URL + '/api/singlestore/reward/';
    setState(() {
      isLoading = true;
    });
    var response;
    try {
      response = await Dio().get(
        url,
        queryParameters: {"storeKey": API.STORE_KEY},
        options: Options(headers: HEADER_MAP),
      );

      StandardResponse res = StandardResponse.fromMap(response.data);
      if (res.message != null && res.message.isNotEmpty) showToast(res.message);
      model = RewardDetailModel.fromMap(res.data);

      setState(() {
        isLoading = false;
      });
    } catch (e) {}
  }

  body() {
    return Container(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 90,
            backgroundColor: THEME_COLOR_PRIMARY,
            child: RichText(
              text: TextSpan(
                text: model.points.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\nPOINTS',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '${HomeContainer.currencySymbol} ${model.rewards.toString()} REWARDS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              model.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          IconButton(
            icon: Icon(
              LineAwesomeIcons.question_circle,
              size: 40,
              color: THEME_COLOR_PRIMARY,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/webview', arguments: API.REWARD_POLICY);
            },
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () => Navigator.of(context).pushNamed('/wallet'),
            child: Text('Reward History'),
            textColor: Colors.white,
            color: THEME_COLOR_PRIMARY,
          ),
        ],
      ),
    );
  }
}
