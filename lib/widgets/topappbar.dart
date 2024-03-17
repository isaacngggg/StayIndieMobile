import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Stay Indie'),
      actions: <Widget>[
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          foregroundDecoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: TextField(
            decoration: InputDecoration(
                fillColor: Colors.black38,
                icon: Icon(Icons.search),
                border: InputBorder.none),
          ),
        )),
        IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        IconButton(icon: Icon(Icons.chat_bubble_rounded), onPressed: () {}),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
