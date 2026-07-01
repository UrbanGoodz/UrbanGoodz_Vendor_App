class TailorServiceModel {
  final int? id;
  final int? storeId;
  final String? serviceName;
  final String? description;
  final double? basePrice;
  final int? durationDays;

  TailorServiceModel({
    this.id,
    this.storeId,
    this.serviceName,
    this.description,
    this.basePrice,
    this.durationDays,
  });

  factory TailorServiceModel.fromJson(Map<String, dynamic> json) {
    return TailorServiceModel(
      id: json['id'],
      storeId: json['store_id'],
      serviceName: json['service_name'],
      description: json['description'],
      basePrice: json['base_price']?.toDouble(),
      durationDays: json['duration_days'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'service_name': serviceName,
      'description': description,
      'base_price': basePrice,
      'duration_days': durationDays,
    };
  }
}
