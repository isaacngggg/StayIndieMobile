class StoryPage {
  final String id;
  final String metaTitle;
  final String title;
  final String body;
  final List<String> images_url;

  const StoryPage({
    required this.id,
    required this.metaTitle,
    required this.title,
    required this.body,
    required this.images_url,
  });

  StoryPage.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        metaTitle = map['meta_title'],
        title = map['title'],
        body = map['body'],
        images_url = map['images_url'];
}
