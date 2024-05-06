import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
import 'package:stay_indie/widgets/GRBottomSheet.dart';

class FullStoryPage extends StatelessWidget {
  final List<Journey> journeys;
  final int initialPage;
  FullStoryPage({required this.journeys, this.initialPage = 0, super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        PageController(viewportFraction: 0.7, initialPage: initialPage);
    return Scaffold(
      backgroundColor: kBackgroundColour,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 46,
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
                  controller: pageController,
                  itemCount: journeys.length,
                  itemBuilder: (context, index) {
                    Journey journey = journeys[index];
                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (context, child) {
                        double value = index == initialPage ? 1 : 0;
                        double opacity = index == initialPage ? 1 : 0;
                        if (pageController.position.haveDimensions) {
                          value = pageController.page! - index;
                          opacity = (1 - (value.abs())).clamp(0.0, 1.0);
                          value = (1 - (value.abs() * .2)).clamp(0.0, 1.0);
                        }

                        return Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.symmetric(horizontal: 0.0),
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
                                    radius: Curves.easeOut.transform(value) *
                                        (23 -
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(journey.organization,
                                                      style: kBody1),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    width:
                                                        2.0, // or the size you want
                                                    height:
                                                        2.0, // or the size you want
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
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
                                                          ListView(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            shrinkWrap: true,
                                                            children: [
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                  journey.title,
                                                                  style:
                                                                      kHeading2),
                                                              Divider(
                                                                color:
                                                                    kBackgroundColour30,
                                                              ),
                                                              ListTile(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                tileColor:
                                                                    kBackgroundColour20,
                                                                trailing: Icon(
                                                                    Icons.edit),
                                                                title: Text(
                                                                    'Edit'),
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  GRBottomSheet
                                                                      .buildBottomSheet(
                                                                    context,
                                                                    EditJourneyModal(
                                                                        journey:
                                                                            journey),
                                                                  );
                                                                },
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              ListTile(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                tileColor:
                                                                    kBackgroundColour20,
                                                                trailing: Icon(
                                                                    Icons
                                                                        .delete),
                                                                title: Text(
                                                                    'Delete'),
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          ))
                                                }),
                                      ],
                                    ),
                                    Expanded(
                                      child: Opacity(
                                        opacity:
                                            Curves.easeOut.transform(opacity),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(journey.description,
                                                style: kBody1),
                                            SizedBox(height: 10),
                                            ProjectMediaCarousel(
                                              networkImages: [
                                                'https://egawjjsxibcluqdgfyvd.supabase.co/storage/v1/object/public/project_medias/35c383c4-b848-4341-85f8-5a361e6d19f0/c9fe2ae5-6a11-463e-957c-12aab35551ea/images/2024-04-29%2021:41:35.679748.png?t=2024-05-05T10%3A52%3A27.544Z',
                                                'https://egawjjsxibcluqdgfyvd.supabase.co/storage/v1/object/public/project_medias/35c383c4-b848-4341-85f8-5a361e6d19f0/c9fe2ae5-6a11-463e-957c-12aab35551ea/images/2024-04-29%2021:41:44.162008.png?t=2024-05-05T10%3A53%3A08.258Z'
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
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
                              radius: 25,
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

class EditJourneyModal extends StatelessWidget {
  const EditJourneyModal({
    super.key,
    required this.journey,
  });

  final Journey journey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10),
        Text('Edit Highlight Details', style: kHeading2),
        Divider(color: kBackgroundColour30),

        SizedBox(height: 20),
        TextFormField(
          initialValue: journey.title,
          decoration: kBoxedTextFieldDecoration.copyWith(labelText: 'Title'),
        ),
        SizedBox(height: 20),
        TextFormField(
          initialValue: journey.organization,
          decoration:
              kBoxedTextFieldDecoration.copyWith(labelText: 'Organization'),
        ),
        SizedBox(height: 20),

        // Date Picker
        TextFormField(
          initialValue: DateFormat('MMM yyyy').format(journey.startDate),
          decoration:
              kBoxedTextFieldDecoration.copyWith(labelText: 'Start Date'),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: journey.startDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != journey.startDate)
              print('Date Selected: ${pickedDate.toString()}');
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          initialValue: journey.description,
          decoration:
              kBoxedTextFieldDecoration.copyWith(labelText: 'Description'),
          maxLines: 5,
        ),
        SizedBox(height: 20),
        TextButton(
          onPressed: () {
            Journey.updateJourney(journey);
            Navigator.pop(context);
          },
          child: Text('Save'),
          style: kSmallAccentButtonStyle,
        ),
      ],
    );
  }
}
