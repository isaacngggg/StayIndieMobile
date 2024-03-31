import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/screens/project/addProjectFlow/add_project_screen.dart';
import 'package:stay_indie/widgets/journeys/JourneyHeadline.dart';
import 'package:stay_indie/objects/Journey.dart';

class MyJourneyWidget extends StatefulWidget {
  MyJourneyWidget({
    super.key,
  });

  @override
  State<MyJourneyWidget> createState() => _MyJourneyWidgetState();
}

class _MyJourneyWidgetState extends State<MyJourneyWidget> {
  List<Journey> journeys = [];
  @override
  void initState() {
    Journey.getCurrentUserJourneys().then((value) {
      setState(() {
        journeys = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(20.0),
      decoration: kOutlineBorder,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Journey', style: kHeading2),
              PrimaryButton(
                text: 'View all',
                onPressed: () {},
                buttonType: PrimaryButtonType.textButton,
              ),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushNamed(context, AddProjectPage.id);
                  }),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              for (var journey in journeys) ...[
                JourneyHeadline(journey: journey),
                SizedBox(height: 10),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
