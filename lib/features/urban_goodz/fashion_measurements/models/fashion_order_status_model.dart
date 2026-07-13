class FashionOrderStatusModel {
  final int? id;
  final int? orderId;
  final String?
  currentStatus; // "Draft", "Pending Review", "Quote Offered", "Measuring", "In Production", "Alterations", "Completed"
  final DateTime? updatedAt;
  final String? statusNotes;

  FashionOrderStatusModel({
    this.id,
    this.orderId,
    this.currentStatus,
    this.updatedAt,
    this.statusNotes,
  });

  factory FashionOrderStatusModel.fromJson(Map<String, dynamic> json) {
    return FashionOrderStatusModel(
      id: json['id'],
      orderId: json['order_id'],
      currentStatus: json['current_status'],
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      statusNotes: json['status_notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'current_status': currentStatus,
      'updated_at': updatedAt?.toIso8601String(),
      'status_notes': statusNotes,
    };
  }
}
