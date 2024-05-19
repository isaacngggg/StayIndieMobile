import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/profile/profile_page.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.connection,
  });

  final Profile connection;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(connection.profileImageUrl),
        radius: 24,
      ),
      title: Text(connection.name),
      subtitle: connection.headline != null
          ? Text(
              connection.headline!,
              style: kBody1,
            )
          : Container(),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfilePage(
            profileId: connection.id,
          );
        }));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
    );
  }
}
