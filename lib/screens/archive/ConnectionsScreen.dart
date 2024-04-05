import 'package:flutter/material.dart';

import 'package:stay_indie/fields/search_bar.dart';

import 'package:stay_indie/widgets/profile/profile_card.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});
  static String id = 'connectionsscreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stay Indie'),
        actions: <Widget>[
          SizedBox(
            width: 10,
          ),
          TopSearchBar(),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: Icon(Icons.chat_bubble_rounded), onPressed: () {}),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Center(
          child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(10),
        children: [
          ProfileCard('Isaac Ng', 'Product Manager', 'American Express'),
          ProfileCard('Isaac Ng', 'Product Manager', 'American Express'),
          ProfileCard('Isaac Ng', 'Product Manager', 'American Express'),
        ],
      )),
    );
  }
}
