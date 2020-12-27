import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:singlestore/configs/api.dart';
import 'package:singlestore/configs/colors.dart';
import 'package:singlestore/models/store_model.dart';
import 'package:singlestore/models/web_stores.dart';
import 'package:singlestore/widgets/utility_widget.dart';

class StoreList extends StatefulWidget {
  StoreModel model;

  StoreList(this.model) : super();

  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.model.webStores.length,
      itemBuilder: (context, index) {
        WebStore store = widget.model.webStores.elementAt(index);
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/storeDetails', arguments: store);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  store.name,
                  style: TextStyle(
                      color: store.storeKey == API.STORE_KEY
                          ? Colors.green
                          : THEME_COLOR_PRIMARY,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                isThreeLine: true,
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.address),
                    Wrap(
                      spacing: 5,
                      runSpacing: -10,
                      children: [
                        for (String s in store.facilities)
                          chip(s, THEME_COLOR_PRIMARY),
                      ],
                    ),
                  ],
                ),
                // trailing: Icon(
                //   Icons.arrow_forward_ios,
                //   size: 16,
                // ),
              ),
              Divider(
                color: Colors.grey,
                indent: 15,
                endIndent: 15,
              )
            ],
          ),
        );
      },
    );
  }
}
