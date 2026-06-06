class ShoppableReelModel {
  final String id;
  final String title;
  final String creatorName;
  final String productName;
  final String priceLabel;
  final int likes;
  final int views;
  final bool featured;

  const ShoppableReelModel({
    required this.id,
    required this.title,
    required this.creatorName,
    required this.productName,
    required this.priceLabel,
    required this.likes,
    required this.views,
    this.featured = false,
  });
}
