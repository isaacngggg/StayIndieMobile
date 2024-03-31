import 'package:flutter/material.dart';

import 'package:stay_indie/fields/search_bar.dart';
import 'package:stay_indie/widgets/navigation/BottomNavBar.dart';
import 'package:stay_indie/widgets/profile/profile_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static String id = 'searchscreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(pageIndex: 1),
      appBar: AppBar(
        title: Text('Search'),
        actions: <Widget>[
          SizedBox(
            width: 10,
          ),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopSearchBar(),
            SizedBox(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(10),
                children: [
                  ProfileCard(
                      'Isaac Ng', 'Product Manager', 'American Express'),
                  ProfileCard(
                      'Isaac Ng', 'Product Manager', 'American Express'),
                  ProfileCard(
                      'Isaac Ng', 'Product Manager', 'American Express'),
                ],
              ),
            ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
