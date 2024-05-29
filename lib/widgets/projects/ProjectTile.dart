import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Project.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stay_indie/screens/project/manage_story_screen.dart';
import 'package:stay_indie/screens/project/story_screen.dart';

import 'package:stay_indie/widgets/projects/media_carousel.dart';

import 'package:stay_indie/models/StoryPage.dart';
import 'package:stay_indie/models/Profile.dart';

class ProjectTile extends StatefulWidget {
  final Project project;
  final List<StoryPage> storyPages;
  final Profile profile;

  ProjectTile({
    required this.profile,
    required this.project,
    this.storyPages = const [
      const StoryPage(
        id: '1',
        metaTitle: 'metaTitle',
        title: 'title',
        body: 'body',
        images_url: [
          'https://images.unsplash.com/photo-1632218616824-4b3b3b3b3b3b',
          'https://images.unsplash.com/photo-1632218616824-4b3b3b3b3b3b',
          'https://images.unsplash.com/photo-1632218616824-4b3b3b3b3b3b',
        ],
      ),
    ],
    super.key,
  });

  @override
  State<ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile> {
  @override
  void initState() {
    Project.getProjectImages(widget.project.id, currentUserId).then((images) {
      setState(() {
        _networkImages = images;
      });
    });
    super.initState();
  }

  List<String> _networkImages = [];

  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      padding: EdgeInsets.all(15),
      decoration: kOutlineBorder,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      widget.project.title,
                      style: kHeading3,
                    ),
                    Text(
                      widget.project.description,
                      style: kBody2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade300,
                    child: IconButton(
                      icon: Icon(Icons.web_stories,
                          color: Colors.white, size: 16),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return StoryScreen(
                            profile: widget.profile,
                            storyPage: widget.storyPages[0],
                            meta: widget.project.title,
                            title: widget.project.title,
                            body: widget.project.description,
                            images: _networkImages,
                          );
                        }));
                      },
                    )
                    // I

                    ),
              ),
            ],
          ),
          if (widget.project.collaborators != null) ...[
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 15),
                    Icon(Icons.verified, color: kPrimaryColour, size: 14),
                    SizedBox(width: 5),
                    Text(
                        'In Collaboration with & ${widget.project.collaborators?[0]} 2 others.',
                        style: kCaption1),
                  ],
                ),
                Text(widget.project.startDate.toString(), style: kCaption1),
              ],
            ),
          ],
          SizedBox(height: 10),
          // ImageCarousel(),
          _networkImages.length > 0
              ? MediaCarousel(
                  networkImages: _networkImages,
                )
              : Container(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.heart),
                  onPressed: () {},
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.comment),
                  onPressed: () {},
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.retweet),
                  onPressed: () {},
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.paperPlane),
                  onPressed: () {},
                ),
              ]),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: 300,
                      child: CupertinoListSection.insetGrouped(
                        children: [
                          CupertinoListTile(
                            title: Text('Edit'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoListTile(
                            title: Text('Delete'),
                            onTap: () {
                              Project.deleteProject(
                                  widget.project.id.toString());
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoListTile(
                            title: Text('Hide'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoListTile(
                            title: Text('Edit Stories'),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ManageStoryScreen(
                                    storyPages: widget.storyPages);
                              }));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
