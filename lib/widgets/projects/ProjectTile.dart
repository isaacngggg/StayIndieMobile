import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Project.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:stay_indie/widgets/projects/project_media_carousel.dart';

class ProjectTile extends StatefulWidget {
  final Project project;

  ProjectTile({
    required this.project,
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
                    backgroundColor: Colors.black,
                  )),
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
              ? ProjectMediaCarousel(networkImages: _networkImages)
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
                      height: 200,
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
