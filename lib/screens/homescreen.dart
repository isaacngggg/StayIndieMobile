import 'package:flutter/material.dart';
import 'package:stay_indie/widgets/BottomNavBar.dart';
import 'package:stay_indie/fields/search_bar.dart';
import 'package:stay_indie/screens/AddScreen.dart';
import 'package:stay_indie/screens/OpportunitiesScreen.dart';
import 'package:stay_indie/screens/profilescreen.dart';
import 'package:stay_indie/screens/ConnectionsScreen.dart';
import 'package:stay_indie/widgets/TopAppBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = 'homescreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
      bottomNavigationBar: BottomNavBar(pageIndex: 0),
      body: Center(
          child: ListView(
        children: [
          Text('Hello World'),
          Text('Hello World'),
        ],
      )),
    );
  }
}
