class CommunityCommentModel {
  final String id;
  final String postId;
  final String authorName;
  final String comment;
  final String? countryCode;
  final String? state;
  final String? city;
  final int? zoneId;
  final String? zoneName;
  final bool isNationwide;
  final bool isWorldwide;
  final bool isLaunchMarket;
  final DateTime? createdAt;

  const CommunityCommentModel({
    required this.id,
    required this.postId,
    required this.authorName,
    required this.comment,
    this.countryCode,
    this.state,
    this.city,
    this.zoneId,
    this.zoneName,
    this.isNationwide = false,
    this.isWorldwide = false,
    this.isLaunchMarket = false,
    this.createdAt,
  });

  factory CommunityCommentModel.fromJson(Map<String, dynamic> json) {
    return CommunityCommentModel(
      id: json['id']?.toString() ?? '',
      postId: json['post_id']?.toString() ?? json['postId']?.toString() ?? '',
      authorName: json['author_name']?.toString() ?? json['authorName']?.toString() ?? 'Community Member',
      comment: json['comment']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? json['countryCode']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      zoneId: int.tryParse(json['zone_id']?.toString() ?? json['zoneId']?.toString() ?? ''),
      zoneName: json['zone_name']?.toString() ?? json['zoneName']?.toString(),
      isNationwide: json['is_nationwide'] == true || json['isNationwide'] == true,
      isWorldwide: json['is_worldwide'] == true || json['isWorldwide'] == true,
      isLaunchMarket: json['is_launch_market'] == true || json['isLaunchMarket'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? json['createdAt']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'post_id': postId,
    'author_name': authorName,
    'comment': comment,
    'country_code': countryCode,
    'state': state,
    'city': city,
    'zone_id': zoneId,
    'zone_name': zoneName,
    'is_nationwide': isNationwide,
    'is_worldwide': isWorldwide,
    'is_launch_market': isLaunchMarket,
    'created_at': createdAt?.toIso8601String(),
  };
}
