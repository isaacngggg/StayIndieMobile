import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter/material.dart';
import 'package:stay_indie/models/Project.dart';
import 'package:stay_indie/screens/project/story_screen.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});
  static String id = 'projects';

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late final PageController _pageController;
  List<Project> projects = [];

  void initState() {
    // TODO: implement initState
    Project.getProfileProjects(currentUserId).then((value) {
      setState(() {
        projects = value;
      });
    });
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      // onTap: () => Navigator.push(
                      //   // StoryScreen(profile: profile, storyPage: storyPage, meta: meta, title: title, body: body, images: images);
                      // ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: projects[index].images != []
                              ? DecorationImage(
                                  image:
                                      NetworkImage(projects[index].images![0]),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: Stack(
                          children: [
                            GradientShadowOverlay(),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          projects[index].title,
                                          style: kHeading1,
                                        ),
                                        Text(
                                          projects[index].description,
                                          style: kBody1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              projects[index]
                                                  .startDate
                                                  .toString(),
                                              style: kBody1,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Wrap(
                children: [
                  TextButton(
                    style: kSmallPrimaryButtonStyle,
                    onPressed: () {
                      // Navigator.pushNamed(context, AddProjectPage.id);
                    },
                    child: Text('Add Project'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientShadowOverlay extends StatelessWidget {
  const GradientShadowOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, -0.5),
          end: Alignment.bottomCenter,
          stops: [0.2, 0.8, 1.0],
          colors: [
            kBackgroundColour.withOpacity(0.0),
            kBackgroundColour.withOpacity(0.8),
            kBackgroundColour.withOpacity(1),
          ],
        ),
      ),
    );
  }
}
