import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

class ImageTile extends StatefulWidget {
  final String image;
  final String title;

  const ImageTile({
    required this.title,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: isSelected ? kSelectedOutlineBorder : kOutlineBorder,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(widget.image, width: 100, height: 100),
              SizedBox(height: 5),
              Text(
                widget.title,
                style: kSubheading2,
              ),
            ]),
      ),
    );
  }
}
