import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/models/offer.dart';
import 'package:singlestore/models/standardresponse.dart';
import 'package:singlestore/screens/Offer/bloc/offer_bloc.dart';
import 'package:singlestore/screens/Offer/bloc/promo_model.dart';
import 'package:singlestore/widgets/custom_appbars.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class OfferStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OfferBloc>(
      create: (BuildContext context) => OfferBloc(),
      child: Offer(),
    );
  }
}

class Offer extends StatefulWidget {
  @override
  _OfferState createState() => _OfferState();
}

class _OfferState extends State<Offer> {
  TextEditingController couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppbar('Offers', []),
      body: body(),
    );
  }

  body() {
    OfferBloc _offerBloc = BlocProvider.of<OfferBloc>(context);
    _offerBloc.add(FetchPromoCode());

    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (context, state) {
        if (state is ErrorState) showToast(state.getResponse.message);
      },
      child: BlocBuilder<OfferBloc, OfferState>(
        builder: (context, state) {
          if (state is ProcessingState || state is InitialState)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is ErrorState)
            return Center(
              child: Text(state.getResponse.message),
            );
          if (state is SuccessState)
            return generateOfferList(state.getResponse.data);
        },
      ),
    );

    // return ListView(
    //   scrollDirection: Axis.vertical,
    //   children: [
    //     // Container(
    //     //   alignment: Alignment.center,
    //     //   height: 80,
    //     //   width: double.maxFinite,
    //     //   color: PAGE_BODY_GREY,
    //     //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    //     //   child: TextField(
    //     //     controller: couponController,
    //     //     autocorrect: true,
    //     //     keyboardType: TextInputType.text,
    //     //     textInputAction: TextInputAction.done,
    //     //     maxLines: 1,
    //     //     textAlignVertical: TextAlignVertical.center,
    //     //     style: GoogleFonts.openSans(color: TEXT_COLOR, fontSize: 14),
    //     //     decoration: InputDecoration(
    //     //       suffix: FlatButton(
    //     //         onPressed: () {},
    //     //         child: Text(
    //     //           'APPLY',
    //     //           style: GoogleFonts.openSans(
    //     //               color: THEME_COLOR_PRIMARY,
    //     //               fontWeight: FontWeight.bold,
    //     //               fontSize: 14),
    //     //         ),
    //     //       ),
    //     //       filled: true,
    //     //       fillColor: Colors.white,
    //     //       focusColor: Colors.white,
    //     //       hintText: 'Enter Coupon Code',
    //     //       hintStyle: GoogleFonts.openSans(color: Colors.grey, fontSize: 14),
    //     //       focusedBorder: OutlineInputBorder(
    //     //         borderRadius: BorderRadius.circular(1),
    //     //         borderSide: BorderSide(color: THEME_COLOR_PRIMARY, width: 1.5),
    //     //       ),
    //     //       enabledBorder: OutlineInputBorder(
    //     //         borderRadius: BorderRadius.circular(1),
    //     //         borderSide: BorderSide(color: THEME_COLOR_PRIMARY),
    //     //       ),
    //     //     ),
    //     //   ),
    //     // ),
    //     Container(
    //       color: PAGE_BODY_GREY,
    //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //       child: Text(
    //         'Available Coupons',
    //         style:
    //             GoogleFonts.openSans(color: THEME_COLOR_PRIMARY, fontSize: 12),
    //       ),
    //     ),
    //     // for (OfferModel model in promoMode.data) getOfferCard(model)
    //   ],
    // );
  }

  Column getOfferCard(OfferModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: THEME_COLOR_PRIMARY,
                ),
                color: THEME_COLOR_PRIMARY.withOpacity(0.2),
              ),
              child: Text(
                model.promocode,
                style: GoogleFonts.openSans(
                    color: THEME_COLOR_PRIMARY,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () async {
                Map<String, dynamic> HEADER_MAP = Map<String, dynamic>();
                HEADER_MAP['Authorization'] = API.JWT_AUTH;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String url = API.BASE_URL +
                    '/api/app/singlestore/${prefs.getInt('orderID')}/applyPromocode/${model.promocode}';
                var response;

                try {
                  response = await Dio().post(
                    url,
                    queryParameters: {"storeKey": API.STORE_KEY},
                    options: Options(headers: HEADER_MAP),
                  );
                } catch (e) {
                  print(e);
                }

                print(url);
                StandardResponse res = StandardResponse.fromMap(response.data);
                if (res.message != null && res.message.isNotEmpty)
                  showToast(res.message);
                if (response.statusCode == 200) {
                  showToast('Promo code applied');
                  Navigator.of(context).pop();
                } else {
                  showToast(res.message);
                }
              },
              child: Text(
                'APPLY',
                style: GoogleFonts.openSans(
                    color: THEME_COLOR_PRIMARY,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            model.shortDescription,
            style: GoogleFonts.openSans(color: Colors.grey, fontSize: 12),
          ),
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          childrenPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (Details s in model.details)
              Text(
                '\u2022   ${s.text}',
                style: GoogleFonts.openSans(
                  color: TEXT_COLOR,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        Divider(),
      ],
    );
  }

  generateOfferList(PromoModel data) {
    return ListView(
      children: [
        Container(
          color: PAGE_BODY_GREY,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Available Coupons',
            style:
                GoogleFonts.openSans(color: THEME_COLOR_PRIMARY, fontSize: 12),
          ),
        ),
        for (OfferModel om in data.promos) getOfferCard(om)
      ],
    );
  }
}
