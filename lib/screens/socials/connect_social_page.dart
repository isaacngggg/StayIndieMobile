import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ConnectSocialPage extends StatelessWidget {
  static const id = 'connect_social_page';
  const ConnectSocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect your socials'),
      ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text('Connect Facebook'),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white)),
                TextButton(
                    onPressed: () {},
                    child: Text('Connect YouTube'),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white)),
                TextButton(
                    onPressed: () {},
                    child: Text('Connect Instagram'),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white)),
              ],
            )),
      ),
    );
  }
}
