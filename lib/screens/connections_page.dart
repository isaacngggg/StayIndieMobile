import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/fields/search_bar.dart';
import 'package:stay_indie/models/ConnectionRequest.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/widgets/avatars/AvatarStack.dart';
import 'package:stay_indie/widgets/navigation/mvp_nav_bar.dart';
import 'package:stay_indie/widgets/profile/profile_card.dart';
import 'package:stay_indie/screens/profile/MainProfilePage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static String id = 'searchscreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Profile userProfile;
  late List<Profile> connections = [];
  late List<Profile> connectionRequestProfiles = [];
  @override
  void initState() {
    ConnectionRequest.getProfileConnectionRequests(currentUserId).then((value) {
      value.forEach((element) {
        Profile.getProfileData(element.senderId).then((value) {
          if (value != null) {
            setState(() {
              connectionRequestProfiles.add(value);
            });
          }
        });
      });
    });

    Profile.getProfileData(currentUserId).then((value) {
      if (value != null) {
        setState(() {
          userProfile = value;
          userProfile.connectionsProfileIds.forEach((element) {
            print('Element: ' + element);
            Profile.getProfileData(element).then((value) {
              if (value != null) {
                setState(() {
                  connections.add(value);
                });
              }
            });
          });
        });
      } else {
        print('Profile is null');
      }
    });

    super.initState();
  }

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
      body: ListView(children: [
        TopSearchBar(),
        connectionRequestProfiles == []
            ? SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(10),
                  children: [
                    for (var profile in connectionRequestProfiles)
                      ProfileCard(
                        profile: profile,
                      ),
                  ],
                ),
              )
            : Container(),
        if (connections.isNotEmpty)
          for (var connection in connections)
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(supabase.storage
                    .from('profile_images')
                    .getPublicUrl(connection.id + '.png')),
                radius: 24,
              ),
              title: Text(connection.name, style: kHeading3),
              subtitle: Text(connection.headline),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfilePage(
                    profileId: connection.id,
                  );
                }));
              },
            )
        else
          Expanded(
            child: Center(
              child: Text('No connections found'),
            ),
          ),
      ]),
    );
  }
}
