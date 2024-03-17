import 'package:flutter/material.dart';

class TopSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    ));
  }
}
