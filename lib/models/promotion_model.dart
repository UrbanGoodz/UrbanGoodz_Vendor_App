class PromotionModel {
  final String id;
  final String title;
  final String description;
  final String discountType;
  final double discountValue;
  final String? code;
  final double? minOrderAmount;
  final DateTime startDate;
  final DateTime endDate;
  final int usageLimit;
  final int usageCount;
  final bool isActive;
  final String imageUrl;

  PromotionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.code,
    this.minOrderAmount,
    required this.startDate,
    required this.endDate,
    required this.usageLimit,
    required this.usageCount,
    required this.isActive,
    required this.imageUrl,
  });
}
