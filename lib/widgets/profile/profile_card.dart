import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/constants.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String company;

  const ProfileCard(this.name, this.role, this.company);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 10,
            right: 20,
            child: FaIcon(
              FontAwesomeIcons.solidCircleXmark,
              color: Colors.grey.shade300,
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
                child: Text(name,
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  role,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              // Text(
              //   company,
              //   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              // ),
              TextButton(
                child: Text('Follow'),
                onPressed: () {},
                style: kSmallPrimaryButtonStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
