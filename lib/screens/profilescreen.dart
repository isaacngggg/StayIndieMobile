import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:stay_indie/objects/Project.dart';
import 'package:stay_indie/widgets/MyJourneyWidget.dart';
import 'package:stay_indie/widgets/ConnectionWidget.dart';

import 'package:stay_indie/widgets/ProjectTile.dart';
import 'package:stay_indie/objects/SocialMetric.dart';
import 'package:stay_indie/widgets/BottomNavBar.dart';
import 'package:stay_indie/widgets/SocialMetricPill.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stay_indie/modals/SettingsModal.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  static String id = 'profilescreen';

  List userProjects = [
    Project(
        title: 'Heading Styles to GoodNotes5',
        description:
            'A quicker way to navigate through notes and generate table of content',
        date: '10/2/2023',
        collaborators: ['GoodNotes', '2 others'],
        tags: ['Design', 'Productivity']),
    Project(
        title: 'Heading Styles to GoodNotes5',
        description:
            'A quicker way to navigate through notes and generate table of content',
        date: '10/2/2023',
        collaborators: ['GoodNotes', '2 others'],
        tags: ['Design', 'Productivity']),
    Project(
        title: 'Heading Styles to GoodNotes5',
        description:
            'A quicker way to navigate through notes and generate table of content',
        date: '10/2/2023',
        collaborators: ['GoodNotes', '2 others'],
        tags: ['Design', 'Productivity']),
  ];

  List socialMetrics = [
    SocialMetric(name: 'facebook', value: '14k', unit: 'followers'),
    SocialMetric(name: 'instagram', value: '14k', unit: 'followers'),
    SocialMetric(name: 'twitter', value: '14k', unit: 'followers'),
    SocialMetric(name: 'facebook', value: '14k', unit: 'followers'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      bottomNavigationBar: BottomNavBar(pageIndex: 4),
      body: Stack(
        children: [
          // Profile Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: kPrimaryColour,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Image.asset('assets/profile_example.jpeg',
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      height: 300,
                      alignment: Alignment.topCenter),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                                expand: false,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => SettingsModal());
                          },
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text('Isaac Ng',
                      style: TextStyle(
                          color: kBackgroundColour,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Profile Details
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: kBackgroundColour,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: kOutlineLight,
                    boxShadow: List<BoxShadow>.generate(
                      1,
                      (index) => BoxShadow(
                        color: kPrimaryColour70,
                        spreadRadius: 0,
                        blurRadius: 23,
                        offset: Offset(0, 0),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Product Designer', style: kHeading3),
                            Text('London, UK', style: kBody2),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 36,
                              child: ListView(
                                  padding: EdgeInsets.all(0),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (var socialMetric in socialMetrics) ...[
                                      SocialMetricPill(
                                          socialMetric: socialMetric),
                                      SizedBox(width: 5),
                                    ]
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      DefaultTabController(
                          length: 3,
                          child: Expanded(
                            child: Column(
                              children: [
                                TabBar(
                                  tabs: [
                                    Tab(text: 'About'),
                                    Tab(text: 'Projects'),
                                    Tab(text: 'Activity'),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      Container(
                                        child: ListView(
                                          padding: EdgeInsets.all(0),
                                          children: [
                                            SizedBox(height: 10),
                                            MyJourneyWidget(),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                                child: ListView(
                                                    padding: EdgeInsets.all(0),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    children: [
                                                  for (var project
                                                      in userProjects) ...[
                                                    SizedBox(height: 10),
                                                    ProjectTile(
                                                        project: project),
                                                  ]
                                                ])),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Text('No Activities'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                ConnectionWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
