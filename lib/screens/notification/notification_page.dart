import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';

class NotificationsPage extends StatelessWidget {
  static String id = 'notificationspage';
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Notifications'),
        actions: <Widget>[
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/profile_example.jpeg'),
                radius: 20,
              ),
              title: Text('John Doe'),
              subtitle: Text('Requested to follow you'),
              trailing: TextButton(
                style: kSmallPrimaryButtonStyle,
                child: Text('Follow'),
                onPressed: () => null,
              )),
          Divider(
            color: Colors.grey.shade300,
            height: 0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_example.jpeg'),
              radius: 20,
            ),
            title: Text('John Doe'),
            subtitle: Text('Liked your post'),
            trailing: Text('12:00'),
          ),
        ],
      ),
    );
  }
}
