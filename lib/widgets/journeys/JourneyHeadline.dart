import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/utilities/LinePainter.dart';
import 'package:stay_indie/models/Journey.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stay_indie/widgets/projects/project_media_carousel.dart';
import 'package:timeago/timeago.dart';

class JourneyHeadline extends StatelessWidget {
  final Journey journey;

  const JourneyHeadline({
    required this.journey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.0, // or the size you want
                backgroundColor: kPrimaryColour20,
                child: CircleAvatar(
                  backgroundColor: journey.emojiBgColor,
                  radius: 19.0, // slightly smaller to create a border effect
                  // backgroundImage: AssetImage('assets/amazon.png'),
                  child: Text(
                    journey.emoji,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(journey.title, style: kHeading4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(journey.organization, style: kBody2),
                        SizedBox(width: 10),
                        Container(
                          width: 2.0, // or the size you want
                          height: 2.0, // or the size you want
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColour, // or the color you want
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(DateFormat('MMM yyyy').format(journey.startDate),
                            style: kCaption1),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.navigate_next),
            ],
          ),
        ),
        journey.imagesUrls.isNotEmpty
            ? ProjectMediaCarousel(
                leftMargin: 80,
                networkImages: journey.imagesUrls,
                height: 100,
              )
            : Container()
      ],
    );
  }
}
