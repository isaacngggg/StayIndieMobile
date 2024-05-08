import 'package:stay_indie/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Project {
  final String id;
  final String title;
  final String summary;
  final String description;
  final DateTime startDate;
  final List<String>? images;
  final List<String>? collaborators;
  final List<String>? tags;

  static Map<String, Future<List<Project>>> _projectCache = {};

  Project({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.startDate,
    this.images,
    this.collaborators,
    this.tags,
  });

  Project.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        title = map['title'],
        summary = map['summary'],
        description = map['description'],
        startDate = map['start_date'] is DateTime
            ? map['start_date']
            : DateTime.parse(map['start_date']),
        images = map['images'],
        collaborators = map['collaborators'],
        tags = map['tags'];

  static Future<List<Project>> getProfileProjects(profileID) async {
    try {
      if (_projectCache[profileID] != null) {
        return _projectCache[profileID]!;
      } else {
        final response = await supabase
            .from('projects')
            .select()
            .eq('profile_id', profileID);

        if (response.isEmpty) {
          print('No projects found');
          return [];
        }
        List<Project> projects = [];
        for (var project in response.toList()) {
          projects.add(Project.fromMap(project));
        }
        _projectCache[profileID] = Future.value(projects);
        return projects;
      }
    } catch (e) {
      print('error here !');
      print('Error' + e.toString());
      return [];
    }
  }

  static addProject(Project project) async {
    final currentUser = supabase.auth.currentUser;
    try {
      final response = await supabase.from('projects').upsert([
        {
          'id': project.id,
          'title': project.title,
          'description': project.description,
          'summary': project.summary,
          'start_date': project.startDate.toIso8601String(),
          'profile_id': currentUser!.id,
        }
      ]);
      print(response);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static deleteProject(String projectID) async {
    try {
      final response =
          await supabase.from('projects').delete().eq('id', projectID);
      print(response);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static updateProject(Project project) async {
    try {
      final response = await supabase.from('projects').update({
        'title': project.title,
        'description': project.description,
        'project_start_date': project.startDate.toIso8601String(),
      }).eq('id', project.id.toString());
      print(response);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static Future<List<String>> getProjectImages(
      String projectId, String userID) async {
    try {
      String imagesPath = '$userID/$projectId/images/';
      List<String> images = [];
      final List<FileObject> objects =
          await supabase.storage.from('project_medias').list(path: imagesPath);
      if (objects.isEmpty) {
        print('No images found $imagesPath');
        return images;
      }
      objects
          .where((object) => object.name != '.emptyFolderPlaceholder')
          .forEach((object) async {
        var url = await supabase.storage
            .from('project_medias')
            .getPublicUrl(imagesPath + object.name);
        images.add(url);
      });
      return images;
    } catch (e) {
      print('Error' + e.toString());
      return [];
    }
  }

  static void clearCache() {
    _projectCache = {};
  }
}
