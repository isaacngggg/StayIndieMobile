import 'package:flutter/material.dart';

import 'package:stay_indie/fields/search_bar.dart';
import 'package:stay_indie/widgets/BottomNavBar.dart';
import 'package:stay_indie/widgets/profile_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static String id = 'searchscreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(pageIndex: 1),
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
