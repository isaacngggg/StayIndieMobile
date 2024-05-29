import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter/material.dart';
import 'package:stay_indie/models/Journey.dart';

import 'package:intl/intl.dart';

import 'package:stay_indie/screens/journeys/edit_journey_modal.dart';
import 'package:stay_indie/utilities/LinePainter.dart';

import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';

import 'package:stay_indie/widgets/projects/media_carousel.dart';
import 'package:stay_indie/widgets/GRBottomSheet.dart';

class FullStoryPage extends StatefulWidget {
  final List<Journey> journeys;
  final int initialPage;
  FullStoryPage({required this.journeys, this.initialPage = 0, super.key});

  @override
  State<FullStoryPage> createState() => _FullStoryPageState();
}

class _FullStoryPageState extends State<FullStoryPage> {
  late final PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    _pageController =
        PageController(viewportFraction: 0.7, initialPage: widget.initialPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 30,
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
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  itemCount: widget.journeys.length,
                  itemBuilder: (context, index) {
                    Journey journey = widget.journeys[index];
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = index == widget.initialPage ? 1 : 0;
                        double opacity = index == widget.initialPage ? 1 : 0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          opacity = (1 - (value.abs())).clamp(0.0, 1.0);
                          value = (1 - (value.abs() * .2)).clamp(0.0, 1.0);
                        }

                        return Column(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      radius: Curves.easeOut.transform(value) *
                                          23, // or the size you want
                                      backgroundColor: kPrimaryColour40,
                                      child: CircleAvatar(
                                        radius: Curves.easeOut
                                                .transform(value) *
                                            (23 -
                                                1), // slightly smaller to create a border effect
                                        backgroundColor: journey.emojiBgColor,

                                        child: Text(
                                          journey.emoji,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10),
                                                  Text(journey.title,
                                                      style: kHeading3),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(journey.organization,
                                                          style: kBody1),
                                                      SizedBox(width: 10),
                                                      Container(
                                                        width:
                                                            2.0, // or the size you want
                                                        height:
                                                            2.0, // or the size you want
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              kPrimaryColour, // or the color you want
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                          DateFormat('MMM yyyy')
                                                              .format(journey
                                                                  .startDate),
                                                          style: kCaption1),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: kPrimaryColour,
                                                ),
                                                onPressed: () => {
                                                      GRBottomSheet
                                                          .buildBottomSheet(
                                                              context,
                                                              MoreActionModel(
                                                                  journey:
                                                                      journey))
                                                    }),
                                          ],
                                        ),
                                        Expanded(
                                          child: Opacity(
                                            opacity: Curves.easeOut
                                                .transform(opacity),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(journey.description,
                                                    style: kBody1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MediaCarousel(
                              height: 300,
                              networkImages: journey.imagesUrls,
                              leftMargin: 60,
                            ),
                            Spacer(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: kBackgroundColour.withOpacity(0.5),
                      border: Border(
                        bottom: BorderSide(
                          color: kBackgroundColour.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Hero(
                            tag: 'profilePic',
                            child: CircleAvatarWBorder(
                              imageUrl: currentUserProfile.profileImageUrl,
                              radius: 20,
                            ),
                          ),
                          Text('My Journey', style: kHeading3),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: FaIcon(FontAwesomeIcons.xmark,
                                  color: kPrimaryColour),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class MoreActionModel extends StatelessWidget {
  const MoreActionModel({
    super.key,
    required this.journey,
  });

  final Journey journey;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      children: [
        SizedBox(height: 10),
        Text(journey.title, style: kHeading2),
        Divider(
          color: kBackgroundColour30,
        ),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: kBackgroundColour20,
          trailing: Icon(Icons.edit),
          title: Text('Edit'),
          onTap: () {
            Navigator.pop(context);
            GRBottomSheet.buildBottomSheet(
              context,
              EditJourneyModal(journey: journey),
            );
          },
        ),
        SizedBox(height: 10),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: kBackgroundColour20,
          trailing: Icon(Icons.delete),
          title: Text('Delete'),
          onTap: () {
            Journey.deleteJourney(journey.id);
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ],
    );
  }
}
