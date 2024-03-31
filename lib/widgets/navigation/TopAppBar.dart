import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        SizedBox(
          width: 10,
        ),
        IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
