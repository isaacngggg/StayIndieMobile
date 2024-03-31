import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stay_indie/objects/Project.dart';

class AddProjectPage extends StatelessWidget {
  static const id = 'add_project_page';
  const AddProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project'),
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
                  name: 'title',
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                FormBuilderTextField(
                  name: 'description',
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                FormBuilderDateTimePicker(
                  name: 'project_start_date',
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
                      _formKey.currentState?.value;

                      var newProject = Project.fromMap(
                          _formKey.currentState?.value as Map<String, dynamic>);

                      Project.addProject(newProject);

                      print('Project Added');
                      // Navigator.pop(context);
                    },
                    child: Text('Add Project'),
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
