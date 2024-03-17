import 'package:flutter/material.dart';

class NavIconButton extends StatelessWidget {
  final IconData iconData;
  final String NavRoute;
  final String navTitle;

  const NavIconButton(this.iconData, this.NavRoute, this.navTitle);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            iconSize: 30,
            onPressed: () {
              // Navigator.pushNamedAndRemoveUntil(context, NavRoute, (route) => false);
              Navigator.pushReplacementNamed(context, NavRoute);
            },
            icon: Icon(iconData),
          ),
          Text(
            navTitle,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
