import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/widgets/profile/CoverButton.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 10,
            right: 20,
            child: FaIcon(
              FontAwesomeIcons.solidCircleXmark,
              color: kAccentColour,
            )),
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 150,
          decoration: kOutlineBorder,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/profile_example.jpeg'),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(profile.name,
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              Align(
                alignment: Alignment.center,
                child: profile.headline != null
                    ? Text(
                        profile.headline!,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 10),
                      )
                    : null,
              ),
              SizedBox(
                height: 2,
              ),
              // Text(
              //   company,
              //   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              // ),
              CoverButton(userProfile: profile),
            ],
          ),
        ),
      ],
    );
  }
}
