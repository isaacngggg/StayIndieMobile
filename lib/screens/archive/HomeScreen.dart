import 'package:flutter/material.dart';
import 'package:stay_indie/widgets/navigation/mvp_nav_bar.dart';
import 'package:stay_indie/fields/search_bar.dart';
import 'package:stay_indie/screens/archive/AddScreen.dart';
import 'package:stay_indie/screens/archive/OpportunitiesScreen.dart';
import 'package:stay_indie/screens/archive/ConnectionsScreen.dart';
import 'package:stay_indie/widgets/navigation/TopAppBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = '/';

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
        child: Text('NO CONTENT YET!'),
      ),
    );
  }
}
