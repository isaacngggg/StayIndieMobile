import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter/material.dart';
import 'package:stay_indie/models/Journey.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:intl/intl.dart';
import 'package:stay_indie/models/Project.dart';
import 'package:stay_indie/utilities/LinePainter.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/widgets/images/UploadButton.dart';
import 'package:stay_indie/widgets/projects/project_media_carousel.dart';
import 'package:stay_indie/widgets/GRBottomSheet.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FullStoryPage extends StatefulWidget {
  final List<Journey> journeys;
  final int initialPage;
  FullStoryPage({required this.journeys, this.initialPage = 0, super.key});

  @override
  State<FullStoryPage> createState() => _FullStoryPageState();
}

class _FullStoryPageState extends State<FullStoryPage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        PageController(viewportFraction: 0.7, initialPage: widget.initialPage);
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
                  controller: pageController,
                  itemCount: widget.journeys.length,
                  itemBuilder: (context, index) {
                    Journey journey = widget.journeys[index];
                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (context, child) {
                        double value = index == widget.initialPage ? 1 : 0;
                        double opacity = index == widget.initialPage ? 1 : 0;
                        if (pageController.position.haveDimensions) {
                          value = pageController.page! - index;
                          opacity = (1 - (value.abs())).clamp(0.0, 1.0);
                          value = (1 - (value.abs() * .2)).clamp(0.0, 1.0);
                        }

                        return Container(
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
                                                          MoreActionModel(
                                                              journey: journey))
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
                                                height: 300,
                                                networkImages:
                                                    journey.imagesUrls!),
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
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class EditJourneyModal extends StatefulWidget {
  const EditJourneyModal({
    super.key,
    required this.journey,
  });

  final Journey journey;

  @override
  State<EditJourneyModal> createState() => _EditJourneyModalState();
}

class _EditJourneyModalState extends State<EditJourneyModal>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final TextEditingController titleController;
  late final TextEditingController organizationController;
  late final TextEditingController startDateController;
  late final TextEditingController descriptionController;

  List<String> _networkImages = [];

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    _networkImages.addAll(widget.journey.imagesUrls);

    titleController = TextEditingController(text: widget.journey.title);
    organizationController =
        TextEditingController(text: widget.journey.organization);
    startDateController =
        TextEditingController(text: widget.journey.startDate.toIso8601String());
    descriptionController =
        TextEditingController(text: widget.journey.description);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text('Edit Highlight Details', style: kHeading2),
          Divider(color: kBackgroundColour30),
          TabBar(
            controller: tabController,
            tabs: [
              Tab(
                text: 'Details',
              ),
              Tab(
                text: 'Media',
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            child: TabBarView(
              controller: tabController,
              children: [
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: titleController,
                      decoration: kBoxedTextFieldDecoration.copyWith(
                          labelText: 'Title'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: organizationController,
                      decoration: kBoxedTextFieldDecoration.copyWith(
                          labelText: 'Organization'),
                    ),
                    SizedBox(height: 20),

                    FormBuilderDateTimePicker(
                      name: 'start_date',
                      inputType: InputType.date,
                      decoration: kBoxedTextFieldDecoration.copyWith(
                        labelText: 'Start Date',
                      ),
                      format: DateFormat("EEE, M-d-y"),
                      controller: startDateController,
                    ),
                    // Date Picker

                    SizedBox(height: 20),
                    TextFormField(
                      controller: descriptionController,
                      decoration: kBoxedTextFieldDecoration.copyWith(
                          labelText: 'Description'),
                      maxLines: 4,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    UploadButton(
                      itemId: widget.journey.id,
                      bucket: 'project_medias',
                      updateNetworkImagesFunc: (url) {
                        setState(() {
                          Journey.addImageUrl(url, widget.journey.id);
                          _networkImages.add(url);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ProjectMediaCarousel(
                      networkImages: _networkImages,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Journey.updateJourney({
                'title': titleController.text,
                'organization': organizationController.text,
                'start_date': DateFormat("EEE, d-M-yyyy")
                    .parse(startDateController.text)
                    .toIso8601String(),
                'description': descriptionController.text,
              }, widget.journey.id);
              Navigator.pop(context);
            },
            child: Text('Save'),
            style: kPrimaryButtonStyle,
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
            style: kTextButtonStyle,
          ),
        ],
      ),
    );
  }
}
