import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:stay_indie/screens/chat/ChatScreen.dart';

import 'package:stay_indie/constants.dart';
import 'package:stay_indie/widgets/navigation/new_nav_bar.dart';
import 'package:stay_indie/screens/notification/notification_page.dart';
import 'package:stay_indie/models/ChatInfo.dart';
import 'package:stay_indie/screens/qr_page.dart';
import 'package:stay_indie/widgets/GRBottomSheet.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/widgets/chat/message_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stay_indie/widgets/profile/contact_tile.dart';
import 'package:timeago/timeago.dart';

class InboxScreen extends StatefulWidget {
  InboxScreen({super.key});
  static String id = '/inbox';

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late PageController pageController;

  Stream<List<ChatInfo>>? _chatsStream;

  @override
  void initState() {
    pageController = PageController(initialPage: 1);
    super.initState();
    print(currentUserProfile.chatIds);
    _initChatsStream();
  }

  void _initChatsStream() async {
    List<ChatInfo> chats = [];
    var maps = await supabase
        .from('chats')
        .select()
        .inFilter('id', currentUserProfile.chatIds);

    for (var chat in maps) {
      print('Chat: ' + chat.toString());
      print('currentUserId: ' + currentUserId);

      try {
        var value = await ChatInfo.createChatInfo(chat);
        print('Chat Value: ' + value.toString());
        chats.add(value);
      } catch (e) {
        print('Error: ' + e.toString());
      }
    }
    print('Chat Length: ${chats.length}');
    setState(() {
      _chatsStream = Stream.value(chats);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/qr.png',
            width: 26,
          ),
          onPressed: () {
            context.push(QrPage.id);
          },
        ),
        title: Text('Inbox'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              showMaterialModalBottomSheet(
                  backgroundColor: kBackgroundColour10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enableDrag: true,
                  context: context,
                  builder: (context) {
                    return _NewChatModal();
                  });
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SizedBox(
              height: 800,
              width: double.infinity,
              child: Stack(
                children: [
                  StreamBuilder<Object>(
                      stream: _chatsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data == null) {
                          return Center(
                            child: Text('No chats found'),
                          );
                        } else {
                          print("Data Snapshot chats: " +
                              snapshot.data.toString());
                          List<ChatInfo> chats =
                              snapshot.data as List<ChatInfo>;
                          return ListView(
                            padding: EdgeInsets.all(10),
                            children: [
                              // TextFormField(
                              //   decoration: kSearchTextFieldDecoration,
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),

                              for (var chat in chats)
                                ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    backgroundImage: chat.imageUrl == null
                                        ? null
                                        : NetworkImage(chat.imageUrl!),
                                    child: chat.imageUrl == null
                                        ? Text(chat.name.substring(0, 2))
                                        : null,
                                    radius: 25,
                                  ),
                                  title: Text(
                                      chat.name ?? "Unnamed ?? group chat"),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                  chatInfo: chat,
                                                )));
                                  },
                                  subtitle: chat.lastMessage != null
                                      ? Text(
                                          chat.lastMessage!.content,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        )
                                      : Text('No messages yet.',
                                          style: TextStyle(
                                              color: kPrimaryColour90)),
                                  trailing: chat.lastMessage != null
                                      ? Text(
                                          format(chat.lastMessage!.createdAt,
                                              locale: 'en_short'),
                                        )
                                      : Text('Time error'),
                                ),
                            ],
                          );
                        }
                      }),
                  Positioned(
                    bottom: 20,
                    right: 0,
                    left: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: kSmallPrimaryButtonStyle,
                            onPressed: () {
                              GRBottomSheet.buildBottomSheet(
                                context,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    formSpacer,
                                    Text(
                                      'Request EPK',
                                      style: kHeading2,
                                    ),
                                    formSpacer,
                                    Text(
                                      "We'll send a request to the artist to share their EPK with you via your email.",
                                      style: kBody1,
                                    ),
                                    formSpacer,
                                    TextFormField(
                                      decoration: kBoxedTextFieldDecoration
                                          .copyWith(labelText: 'Email'),
                                    ),
                                    formSpacer,
                                    TextButton(
                                        child: Text('Send Request'),
                                        style: kSmallAccentButtonStyle,
                                        onPressed: () {}),
                                  ],
                                ),
                              );
                            },
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
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   left: 0,
          //   child: Column(
          //     children: [
          //       NewNavBar(pageIndex: 0),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}

class _NewChatModal extends StatefulWidget {
  const _NewChatModal({super.key});

  @override
  State<_NewChatModal> createState() => __NewChatModaState();
}

class __NewChatModaState extends State<_NewChatModal> {
  List<Profile> displayResults = currentUserProfile.connectionsProfiles;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Wrap(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              formSpacer,
              Text(
                'Start a new chat',
                style: kHeading2,
              ),
              formSpacer,
              Text(
                'Enter the name of the user you want to chat with.',
                style: kBody1,
              ),
              formSpacer,
              TextFormField(
                decoration: kSearchTextFieldDecoration,
                onChanged: (value) {
                  setState(() {
                    Profile.searchConnectionByName(value, currentUserProfile)
                        .then((value) => {
                              if (value.isNotEmpty)
                                {
                                  setState(() {
                                    displayResults = value;
                                  })
                                }
                              else
                                {
                                  setState(() {
                                    displayResults =
                                        currentUserProfile.connectionsProfiles;
                                  })
                                }
                            });
                  });
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  children: [
                    for (var profile in displayResults)
                      ContactTile(
                        connection: profile,
                      ),
                  ],
                ),
              ),
              MessageBar(),
            ],
          ),
        ],
      ),
    );
  }
}
