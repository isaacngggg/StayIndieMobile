import 'package:flutter/material.dart';
import 'package:stay_indie/buttons/navicon_button.dart';
import 'package:stay_indie/screens/add_screen.dart';
import 'package:stay_indie/screens/connectionsscreen.dart';
import 'package:stay_indie/screens/homescreen.dart';
import 'package:stay_indie/screens/opportunities_screen.dart';
import 'package:stay_indie/screens/profilescreen.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavIconButton(Icons.home, HomeScreen.id, 'Home'),
          NavIconButton(Icons.people, ConnectionsScreen.id, 'Network'),
          NavIconButton(Icons.add_circle, AddScreen.id, 'Create'),
          NavIconButton(Icons.cases_sharp, OpportunityScreen.id, 'Jobs'),
          NavIconButton(Icons.account_circle, ProfileScreen.id, 'Profile'),
        ],
      ),
    );
  }
}
