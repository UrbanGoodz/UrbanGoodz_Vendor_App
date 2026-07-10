class VendorStoreModel {
  final String id;
  final String name;
  final String type;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String category;
  final List<String> tags;
  final String logoUrl;
  final String bannerUrl;
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final double rating;
  final int reviewCount;
  final int totalOrders;
  final double totalRevenue;
  final String joinDate;
  final int totalReviews;
  final String hours;
  final List<String> categories;
  final Map<String, bool> features;

  const VendorStoreModel({
    required this.id,
    required this.name,
    this.type = 'grocery',
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.category = 'Grocery',
    this.tags = const [],
    required this.logoUrl,
    required this.bannerUrl,
    required this.isOpen,
    this.openTime = '06:00 AM',
    this.closeTime = '10:00 PM',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.totalOrders = 0,
    this.totalRevenue = 0.0,
    this.joinDate = '',
    this.totalReviews = 0,
    this.hours = '',
    this.categories = const [],
    this.features = const {},
  });
}
