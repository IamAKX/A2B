import 'package:flutter/material.dart';
import 'package:singlestore/models/store.dart';
import 'package:singlestore/screens/AppIntro/app_intro.dart';
import 'package:singlestore/screens/Cart/cart.dart';
import 'package:singlestore/screens/ContactUs/contact_us.dart';
import 'package:singlestore/screens/HomeContainer/home_container.dart';
import 'package:singlestore/screens/MyAccount/my_account.dart';
import 'package:singlestore/screens/MyOrder/my_orders.dart';
import 'package:singlestore/screens/MyOrder/order_summary.dart';
import 'package:singlestore/screens/Notification/notification.dart';
import 'package:singlestore/screens/Offer/offer.dart';
import 'package:singlestore/screens/Onboarding/onboarding.dart';
import 'package:singlestore/screens/Onboarding/otp.dart';
import 'package:singlestore/screens/ReferFriend/refer_friend.dart';
import 'package:singlestore/screens/Store/store_detail.dart';
import 'package:singlestore/screens/Store/store_page.dart';
import 'package:singlestore/screens/Wallet/reward_Detail.dart';
import 'package:singlestore/screens/Wallet/wallet.dart';
import 'package:singlestore/screens/searchpage/search_item.dart';
import 'package:singlestore/screens/webviw/webview.dart';

class NavRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AppIntro());

      case '/home':
        return MaterialPageRoute(builder: (_) => HomeContainerStateLess());

      case '/cart':
        return MaterialPageRoute(
            builder: (_) => CartStateless(settings.arguments));

      case '/account':
        return MaterialPageRoute(builder: (_) => MyAccount());

      case '/orders':
        return MaterialPageRoute(builder: (_) => MyOrders(settings.arguments));

      case '/wallet':
        return MaterialPageRoute(builder: (_) => Wallet());

      case '/rewardDetail':
        return MaterialPageRoute(builder: (_) => RewardDetail());

      case '/notification':
        return MaterialPageRoute(builder: (_) => MyNotification());

      case '/contact':
        return MaterialPageRoute(builder: (_) => ContactUs());

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => Onboarding());

      case '/referfriend':
        return MaterialPageRoute(
            builder: (_) => ReferFriend(settings.arguments));

      case '/otp':
        return MaterialPageRoute(builder: (_) => OTP(settings.arguments));

      case '/offer':
        return MaterialPageRoute(builder: (_) => OfferStateless());

      case '/webview':
        return MaterialPageRoute(
            builder: (_) => WebViewScreen(settings.arguments));

      case '/ordersummary':
        return MaterialPageRoute(
            builder: (_) => OrderSummary(settings.arguments));

      case '/search':
        return MaterialPageRoute(
            builder: (_) => SearchPage(settings.arguments));
      case '/storeDetails':
        return MaterialPageRoute(
            builder: (_) => StoreDetails(settings.arguments));

      case '/store':
        return MaterialPageRoute(builder: (_) => StorePage());

      default:
        return MaterialPageRoute(builder: (_) => HomeContainerStateLess());
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Oooppss!! Fatal error'),
        ),
      );
    });
  }
}
