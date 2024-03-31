import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/objects/Project.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class ProjectTile extends StatelessWidget {
  final Project project;

  ProjectTile({
    required this.project,
    super.key,
  });

  @override
  List<String> images = [
    'assets/image1.png',
    'assets/image2.png',
    'assets/image3.png',
    // Add more image paths
  ];

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
                      project.title,
                      style: kHeading3,
                    ),
                    Text(
                      project.description,
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
          if (project.collaborators != null) ...[
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // AvatarStack(
                    //   images: [
                    //     'assets/goodnotes_profile.jpeg',
                    //     'assets/figma_profile.png'
                    //   ],
                    //   radius: 10,
                    // ),
                    SizedBox(width: 15),
                    Icon(Icons.verified, color: kPrimaryColour, size: 14),
                    SizedBox(width: 5),
                    Text(
                        'In Collaboration with & ${project.collaborators?[0]} 2 others.',
                        style: kCaption1),
                  ],
                ),
                Text(project.date, style: kCaption1),
              ],
            ),
          ],
          SizedBox(height: 10),
          // ImageCarousel(),
          SizedBox(
            height: 200,
            child: ListView.builder(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: kOutlineBorder,
                    child: Image.asset(images[index]),
                  ),
                  onTap: () {
                    showImageViewerPager(
                      context,
                      MultiImageProvider(
                          images.map((image) => AssetImage(image)).toList()),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.comment),
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
