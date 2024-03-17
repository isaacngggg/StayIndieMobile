import 'package:flutter/material.dart';
import 'package:stay_indie/widgets/navbar.dart';
import 'package:stay_indie/fields/search_bar.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});
  static String id = 'add_screen';

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
      bottomNavigationBar: NavBar(),
    );
  }
}
