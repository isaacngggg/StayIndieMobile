import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/fields/search_bar.dart';
import 'package:stay_indie/models/ConnectionRequest.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/data_deletion_page.dart';
import 'package:stay_indie/screens/qr_page.dart';
import 'package:stay_indie/widgets/avatars/AvatarStack.dart';
import 'package:stay_indie/widgets/navigation/new_nav_bar.dart';
import 'package:stay_indie/widgets/profile/CoverButton.dart';
import 'package:stay_indie/widgets/profile/contact_tile.dart';
import 'package:stay_indie/widgets/profile/profile_card.dart';
import 'package:stay_indie/screens/profile/profile_page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:go_router/go_router.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});
  static String id = '/contacts';

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Profile> connections = [];
  List<Profile> connectionRequestProfiles = [];
  List<Profile> searchResults = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Profile.getProfileData(currentUserId).then((value) {
      setState(() {
        currentUserProfile = value;
        connectionRequestProfiles = [];
        ConnectionRequest.getProfileConnectionRequests(currentUserId)
            .then((value) {
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
        connections = [];
        for (var connectionId in currentUserProfile.connectionsProfileIds) {
          Profile.getProfileData(connectionId).then((value) {
            if (value != null) {
              setState(() {
                connections.add(value);
              });
            }
          });
        }
      });
    });
    print('Connections:');
    for (var connection in connections) {
      print(connection.id);
    }
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    for (var connectionId in currentUserProfile.connectionsProfileIds) {
      Profile.getProfileData(connectionId).then((value) {
        if (value != null) {
          setState(() {
            connections.add(value);
          });
        }
      });
    }

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavBar(pageIndex: 1),
      appBar: AppBar(
        title: Text('Contacts'),
        actions: <Widget>[
          SizedBox(
            width: 10,
          ),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                context.push(QrPage.id);
              }),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: [
          SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      Profile.searchProfileByUsername(value).then((value) => {
                            if (value != null)
                              {
                                setState(() {
                                  searchResults.add(value);
                                })
                              }
                            else
                              {
                                setState(() {
                                  searchResults = [];
                                })
                              }
                          });
                    });
                  },
                  decoration: kSearchTextFieldDecoration,
                ),
                searchResults.length != 0
                    ? ListView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        children: [
                          for (Profile searchResult in searchResults)
                            ContactTile(
                              connection: searchResult,
                            ),
                        ],
                      )
                    : Container(),
                connectionRequestProfiles.length != 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                            'Connection Requests (${connectionRequestProfiles.length})',
                            style: kBody1),
                      )
                    : Container(),
                connectionRequestProfiles.length != 0
                    ? ListView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        children: [
                          for (Profile profile in connectionRequestProfiles)
                            ConnectRequestTile(
                              connection: profile,
                            ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 10),
                for (var connection in connections)
                  ContactTile(connection: connection)
              ],
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   left: 0,
          //   child: Column(
          //     children: [
          //       NewNavBar(pageIndex: 1),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}

class ConnectRequestTile extends StatelessWidget {
  const ConnectRequestTile({
    super.key,
    required this.connection,
  });

  final Profile connection;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(connection.profileImageUrl),
        radius: 24,
      ),
      title: Text(connection.name, style: kHeading3),
      subtitle: connection.headline == null ? Text(connection.headline!) : null,
      trailing: CoverButton(userProfile: connection),
      onTap: () {
        context.push(ProfilePage.id + '/${connection.id}');
      },
    );
  }
}
