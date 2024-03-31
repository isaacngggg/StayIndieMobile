import 'package:stay_indie/constants.dart';

class Project {
  final String title;
  final String description;
  final String date;
  final DateTime? projectStartDate;
  final List<String>? images;
  final List<String>? collaborators;
  final List<String>? tags;

  Project({
    required this.title,
    required this.description,
    required this.date,
    this.projectStartDate,
    this.images,
    this.collaborators,
    this.tags,
  });

  Project.fromMap(Map<String?, dynamic> map)
      : title = map['title'],
        description = map['description'],
        date = map['project_start_date'].toString(),
        projectStartDate = map['project_start_date'],
        images = map['images'],
        collaborators = map['collaborators'],
        tags = map['tags'];

  static Future<List<Project>> getCurrentUserProjects() async {
    final currentUser = supabase.auth.currentUser;
    try {
      print(currentUser!.id);
      final response = await supabase
          .from('projects')
          .select()
          .eq('profile_id', currentUser.id);

      if (response.isEmpty) {
        print('No projects found');
        return [];
      }
      List<Project> projects = [];
      for (var project in response.toList()) {
        projects.add(Project.fromMap(project));
      }
      return projects;
    } catch (e) {
      print('Error' + e.toString());
      return [];
    }
  }

  static addProject(Project project) async {
    final currentUser = supabase.auth.currentUser;
    try {
      final response = await supabase.from('projects').insert([
        {
          'title': project.title,
          'description': project.description,
          'project_start_date': project.projectStartDate == null
              ? project.projectStartDate!.toIso8601String()
              : null,
          'profile_id': currentUser!.id,
        }
      ]);
      print(response);
    } catch (e) {
      print('Error' + e.toString());
    }
  }
}
