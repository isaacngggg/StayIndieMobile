import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/utilities/LinePainter.dart';
import 'package:stay_indie/objects/Journey.dart';

class JourneyHeadline extends StatelessWidget {
  final Journey journey;

  const JourneyHeadline({
    required this.journey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20.0, // or the size you want
              backgroundColor: kPrimaryColour40,
              child: CircleAvatar(
                radius: 19.0, // slightly smaller to create a border effect
                backgroundImage: AssetImage('assets/amazon.png'),
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(journey.title, style: kHeading3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(journey.organization, style: kBody1),
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
                    Text(journey.startDate, style: kCaption1),
                  ],
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.navigate_next),
          ],
        ),
        Positioned(
          top: 40,
          left: 20,
          child: CustomPaint(
            size: Size(0, 0),
            painter: LinePainter(height: 30),
          ),
        ),
      ],
    );
  }
}
