import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/utilities/input_fields.dart';

class DataDeletionPage extends StatelessWidget {
  static const String id = '/data-deletion-page';

  const DataDeletionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Deletion'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request to delete your data',
                    style: kHeading2,
                  ),
                  formSpacer,
                  InputFields(children: [
                    TextFormField(
                      decoration: kPlainTextFieldDecoration.copyWith(
                        labelText: 'Email',
                      ),
                    ),
                  ]),
                  formSpacer,
                  TextButton(
                    style: kPrimaryButtonStyle,
                    onPressed: () {},
                    child: Text('Delete My Data'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
