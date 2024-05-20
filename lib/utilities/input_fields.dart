import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

class InputFields extends StatelessWidget {
  final List<Widget> children;
  const InputFields({required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kMultiInputBoxDecoraction,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }
}
