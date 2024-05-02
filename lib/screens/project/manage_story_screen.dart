import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:stay_indie/models/StoryPage.dart';

class ManageStoryScreen extends StatefulWidget {
  static String id = 'manage_story_screen';
  final List<StoryPage> storyPages;

  ManageStoryScreen({required this.storyPages});
  @override
  _ManageStoryScreenState createState() => _ManageStoryScreenState();
}

class _ManageStoryScreenState extends State<ManageStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Storyboards'),
      ),
      body: Container(
        color: Colors.deepPurpleAccent.withOpacity(0.1),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: FlutterCarousel(
                options: CarouselOptions(
                  viewportFraction: 0.7,
                  height: 400.0,
                  showIndicator: true,
                  slideIndicator: CircularSlideIndicator(),
                ),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.amber),
                          child: Text(
                            'text $i',
                            style: TextStyle(fontSize: 16.0),
                          ));
                    },
                  );
                }).toList(),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                  height: 450,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: kBackgroundColour,
                  ),
                  child: SafeArea(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TabBar(
                                  tabs: [
                                    Tab(text: 'Edit Text'),
                                    Tab(text: 'Edit Images'),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(height: 30),
                                          TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Title',
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          TextField(
                                            maxLines: 3,
                                            // minLines: 3,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Body',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(height: 30),
                                          TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Title',
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          TextField(
                                            maxLines: 3,
                                            // minLines: 3,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Body',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
