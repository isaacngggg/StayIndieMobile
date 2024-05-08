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
}
