import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stay_indie/models/Project.dart';
import 'package:stay_indie/widgets/projects/media_carousel.dart';

class AddProjectPage extends StatefulWidget {
  static const id = '/add_project_page';
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  List<String> _networkImages = [];
  @override
  Widget build(BuildContext context) {
    final _newProjectId = uuid.v4();
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
                  name: 'start_date',
                  inputType: InputType.date,
                  decoration: InputDecoration(labelText: 'Start Date'),
                  format: DateFormat("EEE, M-d-y"),
                ),
                MediaCarousel(
                  networkImages: _networkImages,
                ),
                TextButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image == null) return;
                      final imageBytes = await image.readAsBytes();
                      final userId = await supabase.auth.currentUser!.id;
                      final imageUrl =
                          '/$userId/$_newProjectId/images/${DateTime.now()}.png';
                      await supabase.storage
                          .from('project_medias')
                          .uploadBinary(imageUrl, imageBytes)
                          .whenComplete(() async {
                        print('Image uploaded');
                        final url = supabase.storage
                            .from('project_medias')
                            .getPublicUrl(imageUrl);
                        setState(() {
                          _networkImages.add(url);
                        });
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
                      Map<String, dynamic> formValue =
                          Map<String, dynamic>.from(_formKey.currentState?.value
                              as Map<String, dynamic>);
                      formValue.addEntries([
                        MapEntry('id', _newProjectId),
                      ]);
                      var newProject = Project.fromMap(formValue);
                      Project.addProject(newProject);

                      print('Project Added');

                      Navigator.pop(context);
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
