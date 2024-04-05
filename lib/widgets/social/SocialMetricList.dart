import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/widgets/social/SocialMetricPill.dart';
import 'package:stay_indie/models/SocialMetric.dart';

class SocialMetricList extends StatelessWidget {
  const SocialMetricList({
    super.key,
    required this.socialMetrics,
  });

  final List socialMetrics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
          clipBehavior: Clip.none,
          padding: EdgeInsets.all(0),
          scrollDirection: Axis.horizontal,
          children: [
            for (var socialMetric in socialMetrics) ...[
              SocialMetricPill(socialMetric: socialMetric),
              SizedBox(width: 5),
            ]
          ]),
    );
  }
}
