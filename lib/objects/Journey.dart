class Journey {
  final String title;
  final String? company;
  final String description;
  final String startDate;
  final String? endDate;
  final List<String>? images;
  final List<String>? collaborators;
  final List<String>? tags;

  Journey({
    required this.title,
    this.company,
    required this.description,
    required this.startDate,
    this.endDate,
    this.images,
    this.collaborators,
    this.tags,
  });
}
