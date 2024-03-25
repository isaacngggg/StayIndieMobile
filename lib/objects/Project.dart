class Project {
  final String title;
  final String description;
  final String date;
  final List<String>? images;
  final List<String>? collaborators;
  final List<String>? tags;

  Project({
    required this.title,
    required this.description,
    required this.date,
    this.images,
    this.collaborators,
    this.tags,
  });
}
