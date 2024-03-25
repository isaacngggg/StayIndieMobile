import 'package:flutter/material.dart';
import 'package:stay_indie/widgets/CircleAvatarWBorder.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/widgets/BottomNavBar.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});
  static String id = 'chats_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(pageIndex: 3),
      appBar: AppBar(
        title: Text('Inbox'),
        actions: <Widget>[
          SizedBox(
            width: 10,
          ),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: Icon(Icons.chat_bubble_rounded), onPressed: () {}),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: 800,
          width: double.infinity,
          child: ListView(
            children: [
              ListTile(
                leading: CircleAvatarWBorder(
                  image: 'assets/profile_example.jpeg',
                  radius: 30,
                ),
                title: Text('John Doe'),
                subtitle: Text('Hey, how are you?'),
                trailing: Text('12:00'),
              ),
              ListTile(
                leading: CircleAvatarWBorder(
                  image: 'assets/profile_example.jpeg',
                  radius: 30,
                ),
                title: Text('John Doe'),
                subtitle: Text('Hey, how are you?'),
                trailing: Text('12:00'),
              ),
            ],
          ),
        ),
      ),
    );
  } // Add this closing brace
}
