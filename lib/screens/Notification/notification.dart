import 'package:flutter/material.dart';
import 'package:singlestore/widgets/custom_appbars.dart';

class MyNotification extends StatefulWidget {
  @override
  _MyNotificationState createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getSimpleAppbar('Notification', []),
      body: body(),
    );
  }

  body() {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.notifications),
        title: Text('Special Offer this diwali'),
        subtitle: Text('Get 25% off with coupon DIL25'),
        trailing: Text('${index + 1}d ago'),
      ),
    );
  }
}
