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
      quoteAmount: double.tryParse(
        (json['amount'] ?? json['quote_amount'])?.toString() ?? '',
      ),
      comments: (json['notes'] ?? json['comments'])?.toString(),
      isAccepted: json['status'] == 'accepted' || json['is_accepted'] == true,
      offeredAt: DateTime.tryParse(
        (json['created_at'] ?? json['offered_at'])?.toString() ?? '',
      ),
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
