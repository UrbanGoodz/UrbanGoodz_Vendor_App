class TailorQuoteModel {
  final int? id;
  final int? requestId;
  final int? serviceId;
  final double? quoteAmount;
  final String? comments;
  final bool? isAccepted;
  final DateTime? offeredAt;

  TailorQuoteModel({
    this.id,
    this.requestId,
    this.serviceId,
    this.quoteAmount,
    this.comments,
    this.isAccepted,
    this.offeredAt,
  });

  factory TailorQuoteModel.fromJson(Map<String, dynamic> json) {
    return TailorQuoteModel(
      id: json['id'],
      requestId: json['request_id'],
      serviceId: json['service_id'],
      quoteAmount: json['quote_amount']?.toDouble(),
      comments: json['comments'],
      isAccepted: json['is_accepted'],
      offeredAt: json['offered_at'] != null ? DateTime.tryParse(json['offered_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'service_id': serviceId,
      'quote_amount': quoteAmount,
      'comments': comments,
      'is_accepted': isAccepted,
      'offered_at': offeredAt?.toIso8601String(),
    };
  }
}
