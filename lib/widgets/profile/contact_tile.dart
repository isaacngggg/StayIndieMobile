import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/profile/profile_page.dart';
import 'package:go_router/go_router.dart';

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
        foregroundImage: NetworkImage(connection.profileImageUrl),
        child: Text(connection.name.substring(0, 2)),
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
        context.push(ProfilePage.id + '/${connection.id}');
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
    );
  }
}
