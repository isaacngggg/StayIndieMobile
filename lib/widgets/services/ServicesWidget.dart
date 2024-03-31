import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/widgets/journeys/JourneyHeadline.dart';

class ServicesWidget extends StatelessWidget {
  const ServicesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(20.0),
      decoration: kOutlineBorder,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Offered Services', style: kHeading2),
              TextButton(
                child: Text('View all'),
                onPressed: () {},
              ),
              PrimaryButton(
                text: 'View all',
                onPressed: () {},
                buttonType: PrimaryButtonType.textButton,
              )
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [],
          ),
        ],
      ),
    );
  }
}
