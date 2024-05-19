import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/screens/journeys/add_journey_screen.dart';
import 'package:stay_indie/screens/journeys/full_story_screen.dart';
import 'package:stay_indie/screens/journeys/HighlightsEditPage.dart';
import 'package:stay_indie/widgets/journeys/JourneyHeadline.dart';
import 'package:stay_indie/models/Journey.dart';
import 'package:stay_indie/utilities/LinePainter.dart';
import 'package:stay_indie/models/SingleFormPage.dart';
import 'package:stay_indie/screens/templates/stepper_form.dart';

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
  late Future<List<Journey>> journeys;
  late final Stream<List<Journey>> _JourneyStream;
  late final bool _isCurrentUser;
  @override
  void initState() {
    _isCurrentUser = widget.profileId == currentUserId;
    setState(() {
      journeys = Journey.getUserJourneys(widget.profileId);
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
              icon: Icon(Icons.more_horiz),
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
          decoration: kOutlineBorder.copyWith(
              color: kPrimaryColour60.withOpacity(0.1),
              border: Border.all(
                color: kPrimaryColour50.withOpacity(0.5),
                width: 1,
              )),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 40,
                child: CustomPaint(
                  size: Size(0, MediaQuery.of(context).size.height - 400),
                  painter: LinePainter(
                      height: MediaQuery.of(context).size.height - 400,
                      color: kPrimaryColour50.withOpacity(0.5)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: FutureBuilder<List<Journey>>(
                  future: journeys,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var journeys = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var entries in journeys.asMap().entries) ...[
                            GestureDetector(
                              child: Container(
                                  color: Colors.transparent,
                                  child:
                                      JourneyHeadline(journey: entries.value)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FullStoryPage(
                                    journeys: journeys,
                                    initialPage: entries.key,
                                  );
                                }));
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                          _isCurrentUser
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 20.0, // or the size you want
                                        backgroundColor:
                                            kPrimaryColour50.withOpacity(0.5),
                                        child: CircleAvatar(
                                          radius:
                                              19.0, // slightly smaller to create a border effect
                                          backgroundColor: kPrimaryColour80,

                                          child: Center(
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                size: 20,
                                              ),
                                              color: kPrimaryColour,
                                              onPressed: () async {
                                                var result =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            maintainState:
                                                                false,
                                                            allowSnapshotting:
                                                                false,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (context) {
                                                              return StepperForm(
                                                                  title:
                                                                      'Add a Project',
                                                                  pages: SingleFormPage
                                                                      .addJourneyPage,
                                                                  mediaBucket:
                                                                      'project_medias',
                                                                  onSubmit:
                                                                      (formValue) {
                                                                    print(
                                                                        formValue);
                                                                    var newJourney =
                                                                        Journey.fromMap(
                                                                            formValue);
                                                                    Journey.addJourney(
                                                                        newJourney);
                                                                  });
                                                            }));
                                                if (result != null) {
                                                  setState(() {
                                                    var newJourney =
                                                        Journey.fromMap(result);
                                                    newJourney
                                                        .initializeImagesUrls(
                                                            widget.profileId);
                                                    journeys.add(newJourney);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                          child: Text('Add a journey',
                                              style: kHeading4)),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      );
                    } else {
                      return Container(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
