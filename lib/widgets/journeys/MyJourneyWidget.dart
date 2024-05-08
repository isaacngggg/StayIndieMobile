import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/screens/journeys/add_journey_screen.dart';
import 'package:stay_indie/screens/journeys/full_story_screen.dart';
import 'package:stay_indie/screens/journeys/HighlightsEditPage.dart';
import 'package:stay_indie/widgets/journeys/JourneyHeadline.dart';
import 'package:stay_indie/models/Journey.dart';

class MyJourneyWidget extends StatefulWidget {
  MyJourneyWidget({
    required this.profileId,
    super.key,
  });
  final String profileId;
  @override
  State<MyJourneyWidget> createState() => _MyJourneyWidgetState();
}

class _MyJourneyWidgetState extends State<MyJourneyWidget> {
  List<Journey> journeys = [];
  late final Stream<List<Journey>> _JourneyStream;
  @override
  void initState() {
    _JourneyStream = supabase
        .from('journey_entries')
        .stream(primaryKey: ['id'])
        .eq('profile_id', widget.profileId)
        .order('created_at')
        .map((maps) {
          return maps.map((map) => Journey.fromMap(map)).toList();
        });

    Journey.getCurrentUserJourneys().then((value) {
      setState(() {
        journeys = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Highlights', style: kHeading2),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HighlightsEditPage()));
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(20.0),
          decoration: kOutlineBorder,
          child: StreamBuilder<List<Journey>>(
            stream: _JourneyStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var journeysSnaps = snapshot.data!;
                return Column(
                  children: [
                    for (var entry in journeys.asMap().entries) ...[
                      GestureDetector(
                        child: Container(
                            color: Colors.transparent,
                            child: JourneyHeadline(journey: entry.value)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FullStoryPage(
                              journeys: journeys,
                              initialPage: entry.key,
                            );
                          }));
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                );
              } else {
                return Column(
                  children: [
                    for (var entry in journeys.asMap().entries) ...[
                      GestureDetector(
                        child: JourneyHeadline(journey: entry.value),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FullStoryPage(
                              journeys: journeys,
                              initialPage: entry.key,
                            );
                          }));
                        },
                      ),
                      const SizedBox(height: 10),
                    ]
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
