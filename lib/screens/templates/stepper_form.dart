import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stay_indie/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';

import 'package:im_stepper/stepper.dart';
import 'package:stay_indie/models/SingleFormPage.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stay_indie/models/Project.dart';
import 'package:stay_indie/widgets/projects/project_media_carousel.dart';
import 'package:stay_indie/widgets/images/ImageTile.dart';
import 'package:timeago/timeago.dart';
import 'package:intl/intl.dart';

class StepperForm extends StatefulWidget {
  final String title;
  StepperForm({required this.title, required this.pages, super.key});
  static const id = 'stepper_form';
  final _newProjectId = uuid.v4();
  List<SingleFormPage> pages;
  @override
  State<StepperForm> createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  int activeStep = 0;
  late int upperBound;
  SingleFormPage get currentPage => widget.pages[activeStep];
  List<Icon> icons = [];
  late final _newProjectId;
  List<String> _networkImages = [];

  @override
  void initState() {
    // Initial step set to 5.
    _newProjectId = widget._newProjectId;
    activeStep = 0;
    icons = widget.pages.map((page) => page.icon).toList();
    upperBound = widget
        .pages.length; // upperBound MUST BE total number of icons minus 1.
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: kBackgroundColour,
        appBar: AppBar(
          backgroundColor: kBackgroundColour,
          // title: Text(widget.title, style: kSubheading1),
          actions: [
            IconButton(
              onPressed: () {
                // _formKey.currentState?.reset();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mainContent(_networkImages),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return IconButton.filled(
      icon: FaIcon(FontAwesomeIcons.arrowRight),
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return IconButton.filled(
      icon: FaIcon(FontAwesomeIcons.arrowLeft),
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
    );
  }

  Widget submitButton() {
    return IconButton.filled(
      icon: FaIcon(FontAwesomeIcons.check),
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          // _formKey.currentState!.save();
        }
      },
    );
  }

  /// Returns the mainContent wrapping the mainContent text.
  Widget mainContent(var _networkImages) {
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    );
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 60),
          SizedBox(
            height: 70,
            child: Stack(
              children: [
                Positioned(
                  left: activeStep == 0 ? -15 : 0,
                  child: Container(
                    width: double.maxFinite,
                    child: IconStepper(
                      alignment: Alignment.topLeft,
                      enableNextPreviousButtons: false,
                      lineLength: 10,
                      lineColor: Colors.transparent,
                      stepColor: Colors.black,
                      stepRadius: 5,
                      stepPadding: 0,
                      // stepReachedAnimationEffect: Curves.bounceOut,
                      // stepReachedAnimationDuration: Duration(milliseconds: 600),
                      activeStepRadius: 30,
                      activeStepBorderWidth: 0,
                      activeStepBorderPadding: 0,
                      activeStepBorderColor: Colors.transparent,
                      activeStepColor: Colors.white,
                      icons: icons,

                      // activeStep property set to activeStep variable defined above.
                      activeStep: activeStep,

                      // This ensures step-tapping updates the activeStep.
                      onStepReached: (index) {
                        setState(() {
                          activeStep = index;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              currentPage.titleQuestion,
              style: GoogleFonts.ebGaramond(
                  textStyle: kHeading1.copyWith(height: 1.1)),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              currentPage.suportingText,
              style: kSubheading2.copyWith(color: Colors.grey.shade700),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentPage.inputType == FormInputFieldType.media) ...[
                      TextButton(
                        child: Text('Upload'),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image == null) return;
                          final imageBytes = await image.readAsBytes();

                          final imagePath =
                              '/$currentUserId/$_newProjectId/images/${DateTime.now()}.png';
                          await supabase.storage
                              .from('project_medias')
                              .uploadBinary(imagePath, imageBytes)
                              .whenComplete(() async {
                            print('Image uploaded');
                            final url = await supabase.storage
                                .from('project_medias')
                                .getPublicUrl(imagePath);
                            print('url got');
                            setState(() {
                              print(url);
                              _networkImages.add(url);
                            });
                          });
                        },
                        style: kPrimaryButtonSmall,
                      ),
                      ProjectMediaCarousel(networkImages: _networkImages),
                    ],
                    if (currentPage.inputType == FormInputFieldType.date)
                      FormBuilderDateTimePicker(
                        name: currentPage.storageKey,
                        inputType: InputType.date,
                        decoration: InputDecoration(
                          labelText: currentPage.inputLabel,
                          labelStyle:
                              GoogleFonts.ebGaramond(textStyle: kSubheading1),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        format: DateFormat("EEE, M-d-y"),
                        controller: currentPage.controller,
                      ),
                    if (currentPage.inputType == FormInputFieldType.text)
                      FormBuilderTextField(
                        name: currentPage.storageKey,
                        decoration: InputDecoration(
                          labelText: currentPage.inputLabel,
                          labelStyle:
                              GoogleFonts.ebGaramond(textStyle: kSubheading1),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        style: GoogleFonts.ebGaramond(textStyle: kHeading2),
                        controller: currentPage.controller,
                        scrollPadding: EdgeInsets.all(10),
                      ),
                    if (currentPage.inputType == FormInputFieldType.grid)
                      Expanded(
                        child: GridView(gridDelegate: gridDelegate, children: [
                          ImageTile(
                            title: 'Music',
                            image: 'assets/music.png',
                          ),
                          ImageTile(
                            title: 'Film',
                            image: 'assets/film.png',
                          ),
                          ImageTile(
                            title: 'Freelance',
                            image: 'assets/freelance.png',
                          ),
                        ]),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          activeStep == 0 ? SizedBox() : previousButton(),
                          Spacer(),
                          activeStep > 0
                              ? TextButton(
                                  onPressed: () {},
                                  child: Text('Restart'),
                                  style: kDeleteButtonSmall,
                                )
                              : SizedBox(),
                          Spacer(),
                          activeStep == upperBound - 1
                              ? IconButton.filled(
                                  icon: FaIcon(FontAwesomeIcons.check),
                                  onPressed: () {
                                    // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
                                    List values = [_newProjectId];
                                    List<String> keys = ['id'];
                                    _formKey.currentState?.saveAndValidate();
                                    for (var page in widget.pages) {
                                      keys.add(page.storageKey);
                                      if (page.inputType ==
                                          FormInputFieldType.date) {
                                        values.add(DateFormat("EEE, d-M-yyyy")
                                            .parse(page.controller.text));
                                      } else {
                                        values.add(page.controller.text);
                                      }
                                    }
                                    Map<String, dynamic> formValue =
                                        Map.fromEntries(keys
                                            .asMap()
                                            .entries
                                            .map((entry) => MapEntry(
                                                entry.value,
                                                values[entry.key])));
                                    _formKey.currentState?.saveAndValidate();

                                    print(formValue);
                                    var newProject = Project.fromMap(formValue);
                                    Project.addProject(newProject);
                                  },
                                )
                              : Container(),
                          activeStep == upperBound - 1
                              ? SizedBox()
                              : nextButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
