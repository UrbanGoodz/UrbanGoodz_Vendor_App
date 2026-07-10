class CustomerReviewModel {
  final String id;
  final String customerName;
  final String customerAvatar;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String? vendorReply;
  final DateTime? replyDate;
  final int helpfulCount;
  final String serviceName;
  final String orderId;
  final List<String> images;
  final bool isVerified;

  const CustomerReviewModel({
    required this.id,
    required this.customerName,
    required this.customerAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.vendorReply,
    this.replyDate,
    this.helpfulCount = 0,
    this.serviceName = '',
    this.orderId = '',
    this.images = const [],
    this.isVerified = false,
  });
}
