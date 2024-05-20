import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';

class PagesButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final String pageId;

  const PagesButton({
    required this.title,
    required this.icon,
    required this.pageId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Wrap(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: kBackgroundColour10.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: kBackgroundColour30,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: kHeading4.copyWith(
                      color: kPrimaryColour,
                    ),
                  ),
                  // SizedBox(width: 15),
                  // FaIcon(
                  //   icon,
                  //   size: 26,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
      onTap: () => Navigator.pushNamed(context, pageId),
    );
  }
}
