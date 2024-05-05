import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter/material.dart';
import 'package:stay_indie/models/Journey.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:intl/intl.dart';
import 'package:stay_indie/utilities/LinePainter.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/widgets/projects/project_media_carousel.dart';

class FullStoryPage extends StatelessWidget {
  final List<Journey> journeys;

  FullStoryPage({required this.journeys, super.key});

  @override
  Widget build(BuildContext context) {
    CarouselController _carrouselController = CarouselController();
    final PageController _pageController =
        PageController(viewportFraction: 0.7);
    return Scaffold(
      backgroundColor: kBackgroundColour,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 55,
            child: SafeArea(
              child: CustomPaint(
                size: Size(0, 0),
                painter:
                    LinePainter(height: MediaQuery.of(context).size.height),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _pageController,
                    itemCount: journeys.length,
                    itemBuilder: (context, index) {
                      Journey journey = journeys[index];
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
                          }

                          return Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                // color: Colors.amber.withOpacity(0.1),
                                ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: Curves.easeOut.transform(value) *
                                        30, // or the size you want
                                    backgroundColor: kPrimaryColour20,
                                    child: CircleAvatar(
                                      radius: Curves.easeOut.transform(value) *
                                          (30 -
                                              1), // slightly smaller to create a border effect
                                      backgroundImage:
                                          AssetImage('assets/amazon.png'),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(journey.title, style: kHeading3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(journey.organization,
                                              style: kBody1),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 2.0, // or the size you want
                                            height: 2.0, // or the size you want
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  kPrimaryColour, // or the color you want
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                              DateFormat('MMM yyyy')
                                                  .format(journey.startDate),
                                              style: kCaption1),
                                        ],
                                      ),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Text(journey.description,
                                              style: kBody1),
                                          ProjectMediaCarousel(
                                            networkImages: [],
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              left: 25,
              right: 0,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatarWBorder(
                      imageUrl: currentUserProfile!.profileImageUrl,
                      radius: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:
                            FaIcon(FontAwesomeIcons.xmark, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ListView.builder(
//                 controller: _pageController,
//                 physics: PageScrollPhysics(),
//                 itemCount: journeys.length,
//                 itemBuilder: (context, index) {
//                   Journey journey = journeys[index];
//                   return Container(
//                     height: 400,
//                     padding: EdgeInsets.all(20),
//                     margin: EdgeInsets.symmetric(horizontal: 5.0),
//                     decoration: BoxDecoration(
//                       color: Colors.amber.withOpacity(0.1),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 30, // or the size you want
//                           // ... rest of your code
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )


// PageView.builder(
//                 scrollDirection: Axis.vertical,
//                 controller: _pageController,
//                 itemCount: journeys.length,
//                 itemBuilder: (context, index) {
//                   Journey journey = journeys[index];
//                   return AnimatedBuilder(
//                     animation: _pageController,
//                     builder: (context, child) {
//                       double value = 1;
//                       if (_pageController.position.haveDimensions) {
//                         value = _pageController.page! - index;
//                         value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
//                       }

//                       return Container(
//                         padding: EdgeInsets.all(20),
//                         margin: EdgeInsets.symmetric(horizontal: 5.0),
//                         decoration: BoxDecoration(
//                           color: Colors.amber.withOpacity(0.1),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             CircleAvatar(
//                               radius: Curves.easeOut.transform(value) *
//                                   30, // or the size you want
//                               backgroundColor: kPrimaryColour40,
//                               child: CircleAvatar(
//                                 radius: Curves.easeOut.transform(value) *
//                                     (30 -
//                                         1), // slightly smaller to create a border effect
//                                 backgroundImage:
//                                     AssetImage('assets/amazon.png'),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(journey.title, style: kHeading3),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Text(journey.organization, style: kBody1),
//                                       SizedBox(width: 10),
//                                       Container(
//                                         width: 2.0, // or the size you want
//                                         height: 2.0, // or the size you want
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color:
//                                               kPrimaryColour, // or the color you want
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       Text(
//                                           DateFormat('MMM yyyy')
//                                               .format(journey.startDate),
//                                           style: kCaption1),
//                                     ],
//                                   ),
//                                   Expanded(
//                                       child: Text(journey.description,
//                                           style: kBody1)),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),

// FlutterCarousel(
//                 options: CarouselOptions(
//                   clipBehavior: Clip.none,
//                   scrollDirection: Axis.vertical,
//                   viewportFraction: 0.3,
//                   controller: _carrouselController,
//                 ),
//                 items: journeys.asMap().entries.map((entry) {
//                   int index = entry.key;
//                   Journey journey = entry.value;
//                   return Builder(
//                     builder: (BuildContext context) {
//                       print(_carrouselController.toString()); // (null
//                       // double currentPage = _carrouselController.toString().to ?? 0;
//                       double diff = (index - 0);

//                       double radius =
//                           (diff < 1) ? 30.0 : 20.0; // Change sizes as needed
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.symmetric(horizontal: 5.0),
//                         decoration: BoxDecoration(
//                           color: Colors.amber.withOpacity(0.1),
//                         ),
//                         child: Container(
//                           padding: EdgeInsets.all(20),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               CircleAvatar(
//                                 radius: radius, // or the size you want
//                                 backgroundColor: kPrimaryColour40,
//                                 child: CircleAvatar(
//                                   radius: radius -
//                                       1, // slightly smaller to create a border effect
//                                   backgroundImage:
//                                       AssetImage('assets/amazon.png'),
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(journey.title, style: kHeading3),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Text(journey.organization, style: kBody1),
//                                       SizedBox(width: 10),
//                                       Container(
//                                         width: 2.0, // or the size you want
//                                         height: 2.0, // or the size you want
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color:
//                                               kPrimaryColour, // or the color you want
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       Text(
//                                           DateFormat('MMM yyyy')
//                                               .format(journey.startDate),
//                                           style: kCaption1),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Spacer(),
//                               Icon(Icons.navigate_next),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),