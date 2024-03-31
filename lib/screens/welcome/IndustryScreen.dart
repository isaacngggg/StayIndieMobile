import 'package:flutter/material.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/widgets/images/ImageTile.dart';

class IndustryScreen extends StatelessWidget {
  IndustryScreen({super.key});
  static String id = 'industry_screen';

  final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 64,
              ),
              Text(
                'Pick your industry',
                style: kHeading1,
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: GridView(gridDelegate: gridDelegate, children: [
                  ImageTile(
                    title: 'Music',
                    image: 'assets/music.png',
                  ),
                  ImageTile(
                    title: 'Film',
                    image: 'assets/film.png',
                  ),
                  ImageTile(
                    title: 'Freelance',
                    image: 'assets/freelance.png',
                  ),
                ]),
              ),
              SizedBox(
                height: 32,
              ),
              PrimaryButton(
                  text: 'Next',
                  onPressed: () {
                    Navigator.pushNamed(context, '/home_screen');
                  }),
              PrimaryButton(
                  text: 'Go Back',
                  buttonType: PrimaryButtonType.textButton,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home_screen');
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}
