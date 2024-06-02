import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stay_indie/constants.dart';

class GRBottomSheet {
  static Future buildBottomSheet(BuildContext context, Widget content) {
    return showMaterialModalBottomSheet(
      backgroundColor: kBackgroundColour10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      enableDrag: true,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Wrap(
          children: [
            SafeArea(
              top: false,
              child: Padding(
                  padding: MediaQuery.of(context).viewInsets, child: content),
            ),
          ],
        ),
      ),
    );
  }

  static Future buildFixedHeightBottomSheet(
      BuildContext context, Widget content, double height) {
    return showMaterialModalBottomSheet(
      backgroundColor: kBackgroundColour10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      enableDrag: true,
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * height,
        padding: EdgeInsets.all(20),
        child: SafeArea(
          top: false,
          child: Padding(
              padding: MediaQuery.of(context).viewInsets, child: content),
        ),
      ),
    );
  }
}
