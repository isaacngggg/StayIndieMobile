import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/buttons/PrimarySmallButton.dart';

class ConnectionWidget extends StatelessWidget {
  const ConnectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      right: 30,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: kOutlineLight,
              color: kPrimaryColour20.withOpacity(0.7),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14.0,
                      backgroundImage: AssetImage('assets/amazon.png'),
                    ),
                    CircleAvatar(
                      radius: 14.0,
                      backgroundImage: AssetImage('assets/amazon.png'),
                    ),
                  ],
                ),
                Text('29 Mutual Connections', style: kCaption1),
                PrimarySmallButton(text: 'Connect', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
