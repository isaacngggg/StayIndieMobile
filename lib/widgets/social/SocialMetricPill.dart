import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/SocialMetric.dart';

class SocialMetricPill extends StatelessWidget {
  final SocialMetric socialMetric;

  const SocialMetricPill({
    required this.socialMetric,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: kPrimaryColour.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: kPrimaryColour.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 2),
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.transparent,
            child: Icon(
              SocialMetric.getIcon(socialMetric.name),
              color: kPrimaryColour40,
            ),
          ),
          SizedBox(width: 10),
          Text('${socialMetric.value} ${socialMetric.unit}', style: kCaption1),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
