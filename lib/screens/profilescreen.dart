import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/buttons/PrimarySmallButton.dart';
import 'package:stay_indie/widgets/MyJourneyWidget.dart';
import 'package:stay_indie/widgets/ConnectionWidget.dart';
import 'package:stay_indie/constants.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  static String id = 'profilescreen';

  final List<Map> userJourneyItems = [
    {
      'title': 'My first gig',
      'date': '2021-10-10',
      'description': 'I got my first gig today!',
    },
    {
      'title': 'My first gig',
      'date': '2021-10-10',
      'description': 'I got my first gig today!',
    },
    {
      'title': 'My first gig',
      'date': '2021-10-10',
      'description': 'I got my first gig today!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
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
                  top: 20,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                  padding: EdgeInsets.all(10),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Product Designer', style: kHeading3),
                            Text('London, UK', style: kBody2),
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
                                        child: Column(
                                          children: [
                                            SizedBox(height: 20),
                                            MyJourneyWidget(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(height: 20),
                                          Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: kOutlineBorder,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Heading Styles to GoodNotes5',
                                                        style: kHeading3,
                                                      ),
                                                      Text(
                                                        'A quicker way to navigate through notes and generate table of content',
                                                        style: kBody2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                      Container(
                                        child: Text('Activity'),
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
