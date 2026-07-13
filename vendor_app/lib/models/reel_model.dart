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
  final String publicationStatus;
  final String moderationStatus;
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
    this.publicationStatus = 'draft',
    this.moderationStatus = 'pending',
    required this.tags,
    this.productTag = const [],
    required this.createdAt,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] is Map
        ? Map<String, dynamic>.from(json['stats'])
        : json;
    final rawTags = json['commerce_tags'] ?? json['tags'];
    final productTags = rawTags is List
        ? rawTags
              .whereType<Map>()
              .map((tag) => tag['taggable_id']?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toList()
        : <String>[];
    final publication =
        json['publication_status']?.toString() ??
        (json['status'].toString() == '1' ? 'published' : 'draft');
    return ReelModel(
      id: json['id']?.toString() ?? json['reel_id']?.toString() ?? '',
      title: json['description']?.toString() ?? 'Reel',
      description: json['description']?.toString() ?? '',
      videoUrl:
          json['video_full_url']?.toString() ??
          json['video_url']?.toString() ??
          '',
      thumbnailUrl:
          json['thumbnail_full_url']?.toString() ??
          json['thumbnail_url']?.toString() ??
          '',
      views:
          int.tryParse(
            (json['total_views'] ?? stats['total_views'] ?? 0).toString(),
          ) ??
          0,
      likes:
          int.tryParse(
            (json['total_likes'] ?? stats['total_likes'] ?? 0).toString(),
          ) ??
          0,
      comments: 0,
      shares: 0,
      isPublished: publication == 'published',
      publicationStatus: publication,
      moderationStatus: json['moderation_status']?.toString() ?? 'pending',
      tags: productTags,
      productTag: productTags,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
