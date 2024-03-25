import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/objects/Project.dart';
import 'package:stay_indie/widgets/ImageCarousel.dart';
import 'package:stay_indie/widgets/CircleAvatarWBorder.dart';
import 'package:stay_indie/widgets/AvatarStack.dart';

class ProjectTile extends StatelessWidget {
  final Project project;

  const ProjectTile({
    required this.project,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: kOutlineBorder,
      child: Column(
        children: [
          Row(
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
              SizedBox(width: 10),
              CircleAvatarWBorder(
                radius: 20,
                image: 'assets/goodnotes_profile.jpeg',
              ),
            ],
          ),
          if (project.collaborators != null) SizedBox(height: 5),
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
          SizedBox(height: 10),
          ImageCarousel(),
        ],
      ),
    );
  }
}
