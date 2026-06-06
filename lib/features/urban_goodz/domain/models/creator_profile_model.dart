class CreatorProfileModel {
  final String id;
  final String name;
  final String handle;
  final String bio;
  final int followers;
  final double rating;
  final String revenueLabel;
  final List<String> categories;

  const CreatorProfileModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.bio,
    required this.followers,
    required this.rating,
    required this.revenueLabel,
    required this.categories,
  });

  factory CreatorProfileModel.fromJson(Map<String, dynamic> json) {
    return CreatorProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Creator',
      handle: json['handle']?.toString() ?? '@creator',
      bio: json['bio']?.toString() ?? '',
      followers: int.tryParse(json['followers']?.toString() ?? '') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      revenueLabel: json['revenue_label']?.toString() ?? json['revenueLabel']?.toString() ?? 'Revenue pending',
      categories: (json['categories'] is List) ? List<String>.from(json['categories']) : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      'bio': bio,
      'followers': followers,
      'rating': rating,
      'revenue_label': revenueLabel,
      'categories': categories,
    };
  }
}
