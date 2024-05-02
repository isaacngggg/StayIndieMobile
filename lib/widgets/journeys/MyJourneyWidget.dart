import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/screens/journeys/add_journey_screen.dart';
import 'package:stay_indie/screens/journeys/full_story_screen.dart';
import 'package:stay_indie/screens/project/addProjectFlow/add_project_screen.dart';
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
            Text('Journey Highlights', style: kHeading2),
            CircleAvatar(
                backgroundColor: Colors.deepPurple.shade300,
                child: IconButton(
                  icon: Icon(Icons.web_stories, color: Colors.white, size: 16),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FullStoryPage(journeys: journeys);
                    }));
                  },
                )
                // I

                ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(25.0),
          decoration: kOutlineBorder,
          child: StreamBuilder<List<Journey>>(
            stream: _JourneyStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var journeysSnaps = snapshot.data!;
                return Column(
                  children: [
                    for (var journey in journeysSnaps) ...[
                      JourneyHeadline(journey: journey),
                      SizedBox(height: 10),
                    ]
                  ],
                );
              } else {
                return Column(
                  children: [
                    for (var journey in journeys) ...[
                      JourneyHeadline(journey: journey),
                      SizedBox(height: 10),
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



// Column(
//             children: [
//               for (var journey in journeys) ...[
//                 JourneyHeadline(journey: journey),
//                 SizedBox(height: 10),
//               ]
//             ],
//           ),