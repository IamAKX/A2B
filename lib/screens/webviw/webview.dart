import 'package:flutter/material.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/screens/Cart/bloc/cart_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  String url;
  WebViewScreen(this.url) : super();

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    logger.d(widget.url);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: THEME_COLOR_PRIMARY),
        title: Text(
          'A2B',
          style: TextStyle(color: THEME_COLOR_PRIMARY),
        ),
      ),
      body: WebView(
        debuggingEnabled: true,
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
