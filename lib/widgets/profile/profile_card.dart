import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String company;

  const ProfileCard(this.name, this.role, this.company);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: -5,
            color: Colors.black26,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            height: 100,
            child: Image.asset('assets/profile_example.jpeg'),
          ),
          SizedBox(
            height: 5,
          ),
          Text(name,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          Text(role),
          SizedBox(
            height: 2,
          ),
          // Text(
          //   company,
          //   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          // ),
          PrimaryButton(text: 'Follow', onPressed: () => print('followed'))
        ],
      ),
    );
  }
}
