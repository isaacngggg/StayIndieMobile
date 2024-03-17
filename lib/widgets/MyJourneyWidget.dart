import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/widgets/JourneyHeadline.dart';

class MyJourneyWidget extends StatelessWidget {
  const MyJourneyWidget({
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
              Text('My Journey', style: kHeading2),
              // PrimarySmallButton(
              //   text: 'View all',
              //   onPressed: () {},
              // ),
              PrimaryButton(
                text: 'View all',
                onPressed: () {},
                buttonType: PrimaryButtonType.textButton,
              )
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              JourneyHeadline(),
              SizedBox(height: 10),
              JourneyHeadline(),
              SizedBox(height: 10),
              JourneyHeadline(),
            ],
          ),
        ],
      ),
    );
  }
}
