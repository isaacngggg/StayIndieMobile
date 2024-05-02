import 'package:flutter/material.dart';
import 'package:stay_indie/fields/search_bar.dart';
import 'package:stay_indie/screens/chat/ChatScreen.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/widgets/navigation/mvp_nav_bar.dart';
import 'package:stay_indie/screens/notification/notification_page.dart';
import 'package:stay_indie/models/Chat.dart';
import 'package:stay_indie/screens/qr_screen.dart';

class InboxScreen extends StatefulWidget {
  InboxScreen({super.key});
  static String id = 'chats_screen';

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late PageController _pageController;
  List<Chat> chats = [];
  @override
  void initState() {
    Chat.getChats(currentUserId).then((value) => {
          setState(() {
            chats = value;
          })
        });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: 1);
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      children: [
        QrCodePage(),
        Scaffold(
          bottomNavigationBar: BottomNavBar(pageIndex: 0),
          appBar: AppBar(
            title: Text('Inbox'),
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
          body: SafeArea(
            child: SizedBox(
              height: 800,
              width: double.infinity,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      TopSearchBar(),
                      for (var chat in chats)
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: chat.imageUrl == null
                                ? null
                                : NetworkImage(chat.imageUrl!),
                            child: chat.imageUrl == null
                                ? Text(chat.name.substring(0, 2))
                                : null,
                            radius: 30,
                          ),
                          title: Text(chat.name ?? "Unnamed ?? group chat"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          chatInfo: chat,
                                        )));
                          },
                          subtitle: Text('Hey, how are you?'),
                          trailing: Text('12:00'),
                        ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    right: 0,
                    left: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: kPurpleButtonStyle,
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text('Request EPK'),
                                Icon(Icons.add),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        NotificationsPage(),
      ],
    );
  }
}
