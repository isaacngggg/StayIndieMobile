import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/widgets/projects/media_carousel.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/models/StoryPage.dart';

class StoryScreen extends StatefulWidget {
  final Profile profile;
  final StoryPage storyPage;
  final String meta;
  final String title;
  final String body;
  final List<String> images;
  static String id = 'storyscreen';
  final List<String> setimages = [
    'assets/image1.png',
    'assets/image2.png',
    'assets/image3.png',
    // Add more image paths as needed
  ];

  StoryScreen({
    required this.profile,
    required this.storyPage,
    required this.meta,
    required this.title,
    required this.body,
    required this.images,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          // padding: EdgeInsets.symmetric(horizontal: 4),
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(widget.profile.profileImageUrl),
          ),
        ),
        title: Text(
          widget.title,
          style: kHeading3,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: kPrimaryColour20, width: 2))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text(widget.meta,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                      Text(widget.title,
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w500)),
                      Text(widget.body,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                MediaCarousel(
                  networkImages: widget.images,
                  height: 350,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 30,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                            labelText: 'Comment',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.favorite_border),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.more_vert),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
