import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/models/reward.dart';
import 'package:singlestore/models/reward_history_model.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';
import 'package:singlestore/widgets/custom_appbars.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  RewardHistoryModel model;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRewardHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getSimpleAppbar('Reward History', []),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : model == null || model.rewardsHistory.isEmpty
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

  body() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: 50,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: THEME_COLOR_PRIMARY,
                  border: Border.all(color: THEME_COLOR_PRIMARY),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Text(
                  '2020',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
              flex: 3,
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            itemCount: model.rewardsHistory.length,
            itemBuilder: (context, index) {
              Reward reward = model.rewardsHistory.elementAt(index);
              return Container(
                height: 170,
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          CircleAvatar(
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                reward.date.replaceAll(' ', '\n'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            backgroundColor: THEME_COLOR_PRIMARY,
                            minRadius: 25,
                          ),
                          Container(
                            width: 1,
                            height: 120,
                            color: THEME_COLOR_PRIMARY,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            reward.reward.toUpperCase(),
                            style: TextStyle(
                                color: THEME_COLOR_PRIMARY,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            reward.rewardSubText,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            reward.details,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: reward.received.length,
                              itemBuilder: (context, index) => Container(
                                padding: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: THEME_COLOR_PRIMARY),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  reward.received.elementAt(index),
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> loadRewardHistory() async {
    Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
    HEADER_MAP['Authorization'] = API.JWT_AUTH;

    String url = API.BASE_URL + '/api/singlestore/reward/history';

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
      model = RewardHistoryModel.fromMap(res.data);

      setState(() {
        isLoading = false;
      });
    } catch (e) {}
  }
}
