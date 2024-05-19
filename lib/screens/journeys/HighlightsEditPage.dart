import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Journey.dart';
import 'package:stay_indie/screens/templates/stepper_form.dart';
import 'package:stay_indie/models/SingleFormPage.dart';

class HighlightsEditPage extends StatefulWidget {
  HighlightsEditPage({super.key});
  static const String id = 'highlightseditpage';
  final List<Journey> highlights = [
    Journey(
      id: '1',
      title: 'First Highlight',
      description: 'This is the first highlight',
      startDate: DateTime.now(),
      organization: 'Organization Name',
    ),
    Journey(
      id: '2',
      title: 'Second Highlight',
      description: 'This is the second highlight',
      startDate: DateTime.now(),
      organization: 'Organization Name',
    ),
    Journey(
      id: '3',
      title: 'Third Highlight',
      description: 'This is the third highlight',
      startDate: DateTime.now(),
      organization: 'Organization Name',
    ),
  ];

  @override
  State<HighlightsEditPage> createState() => _HighlightsEditPageState();
}

class _HighlightsEditPageState extends State<HighlightsEditPage> {
  Map<String?, bool?> checkboxStates = {};
  @override
  Widget build(BuildContext context) {
    List<Journey> highlights = widget.highlights;

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Highlights'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                ReorderableListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  onReorder: (oldIndex, newIndex) => {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = highlights.removeAt(oldIndex);
                      highlights.insert(newIndex, item);
                    })
                  },
                  children: [
                    for (final highlight in highlights)
                      ListTile(
                        contentPadding: EdgeInsets.only(
                            right: 10, top: 5, bottom: 5, left: 5),
                        leading: Checkbox(
                          value: checkboxStates[highlight.id] ?? false,
                          onChanged: (value) {
                            setState(() {
                              checkboxStates[highlight.id] = value;
                            });
                          },
                        ),
                        key: ValueKey(highlight.id),
                        title: Text(highlight.title),
                        trailing: Icon(Icons.drag_handle),
                      ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            maintainState: false,
                            allowSnapshotting: false,
                            barrierDismissible: false,
                            builder: (context) {
                              return StepperForm(
                                  title: 'Add a Project',
                                  pages: SingleFormPage.addJourneyPage,
                                  mediaBucket: 'project_medias',
                                  onSubmit: (formValue) {
                                    print(formValue);
                                    var newJourney = Journey.fromMap(formValue);
                                    Journey.addJourney(newJourney);
                                  });
                            }));
                  },
                  style: kSmallAccentButtonStyle,
                  child: Text('Add Highlight'),
                )
              ],
            ),
          ),
        ));
  }
}
