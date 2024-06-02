import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stay_indie/models/Journey.dart';
import 'package:stay_indie/models/Organisation.dart';

class AddJourneyPage extends StatefulWidget {
  static const id = '/add-journey';
  const AddJourneyPage({super.key});

  @override
  State<AddJourneyPage> createState() => _AddJourneyPageState();
}

class _AddJourneyPageState extends State<AddJourneyPage> {
  List<Organisation> _organisations = [];
  bool _showOrganisationField = false;
  final TextEditingController _NameController = TextEditingController();

  @override
  void initState() {
    Organisation.getOrganisations().then((value) {
      setState(() {
        _organisations = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Journey'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormBuilderTextField(
                  controller: _NameController,
                  name: 'title',
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                FormBuilderDropdown(
                  name: 'organisation',
                  items: [
                    for (var org in _organisations)
                      DropdownMenuItem(value: org.id, child: Text(org.name)),
                    DropdownMenuItem(
                      value: 'add_new',
                      child: Text('Add new...'),
                    ),
                  ],
                  decoration: InputDecoration(labelText: 'Organisation'),
                  onChanged: (val) {
                    setState(() {
                      if (val == 'add_new') {
                        _showOrganisationField = true;
                      } else {
                        _showOrganisationField = false;
                      }
                    });
                  },
                ),
                _showOrganisationField
                    ? FormBuilderTextField(
                        name: 'specify',
                        decoration: InputDecoration(
                            labelText: 'If Other, please specify'),
                        validator: (val) {
                          if (_formKey.currentState!.fields['organisation']
                                      ?.value ==
                                  'add_new' &&
                              (val == null || val.isEmpty)) {
                            return 'Kindly specify your language';
                          }
                          return null;
                        },
                      )
                    : SizedBox(),
                FormBuilderTextField(
                  name: 'description',
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                FormBuilderDateTimePicker(
                  name: 'start_date',
                  inputType: InputType.date,
                  decoration: InputDecoration(labelText: 'Start Date'),
                  format: DateFormat("EEE, M-d-y"),
                ),
                TextButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image == null) return;
                      final imageBytes = await image.readAsBytes();
                      final userId = await supabase.auth.currentUser!.id;
                      final imageUrl = '/$userId/images/${DateTime.now()}.png';
                      await supabase.storage
                          .from('project_medias')
                          .uploadBinary(imageUrl, imageBytes)
                          .whenComplete(() async {
                        print('Image uploaded');
                        print('Retrieving image');
                        final url = supabase.storage
                            .from('project_medias')
                            .getPublicUrl(imageUrl);
                        print(url);
                      });
                    },
                    child: Text('Add Image')),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    style: kSecondaryButtonStyle,
                    onPressed: () {
                      _formKey.currentState?.saveAndValidate();
                      var date = _formKey.currentState?.value['start_date'];
                      print(date.runtimeType);

                      var newJourney = Journey.fromMap(
                          _formKey.currentState?.value as Map<String, dynamic>);

                      Journey.addJourney(newJourney);

                      Navigator.pop(context);
                    },
                    child: Text('Add Journey'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
