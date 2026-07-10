class ReelModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String type;
  final String duration;
  final int views;
  final int likes;
  final int comments;
  final int shares;
  final bool isPublished;
  final List<String> tags;
  final List<String> productTag;
  final DateTime createdAt;

  ReelModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.type = '',
    this.duration = '',
    required this.views,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isPublished,
    required this.tags,
    this.productTag = const [],
    required this.createdAt,
  });
}
