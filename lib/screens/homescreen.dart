import 'package:flutter/material.dart';
import 'package:stay_indie/widgets/navbar.dart';
import 'package:stay_indie/fields/search_bar.dart';
import 'package:stay_indie/screens/add_screen.dart';
import 'package:stay_indie/screens/connectionsscreen.dart';
import 'package:stay_indie/screens/opportunities_screen.dart';
import 'package:stay_indie/screens/homescreen.dart';
import 'package:stay_indie/screens/profilescreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = 'homescreen';

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
        children: [
          Text('Hello World'),
          Text('Hello World'),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        selectedLabelStyle: TextStyle(
          color: Colors.black,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
        ),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              color: Colors.black,
            ),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cases_rounded,
              color: Colors.black,
            ),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2_rounded,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (value) {
          switch (value) {
            case 0:
              // Handle Home
              Navigator.pushReplacementNamed(context, HomeScreen.id);
              break;
            case 1:
              // Handle Network
              Navigator.pushReplacementNamed(context, ConnectionsScreen.id);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AddScreen.id);
              // Handle Create
              break;
            case 3:
              Navigator.pushReplacementNamed(context, OpportunityScreen.id);
              // Handle Jobs
              break;
            case 4:
              Navigator.pushReplacementNamed(context, ProfileScreen.id);
              // Handle Profile
              break;
          }
        },
      ),
    );
  }
}
