class MeasurementRequestModel {
  final int? id;
  final int? userId;
  final int? profileId;
  final int? customerId;
  final int? vendorId;
  final int? tailorId;
  final int? frontPhotoId;
  final int? sidePhotoId;
  final int? backPhotoId;
  final String? measurementSource;
  final double? platformMeasurementFee;
  final double? vendorMeasurementReviewFee;
  final double? totalMeasurementFee;
  final String? currency;
  final bool? paymentRequired;
  final String? paymentStatus;
  final String? platformFeeStatus;
  final String? vendorPayoutStatus;
  final bool? vendorReviewFeeEnabled;
  final bool? adminFeeEnabled;
  final bool? freeTesterMode;
  final String? measurementStatus;
  final String? reviewStatus;
  final String? tailorNotes;
  final String? notes;
  final String? status; // "pending", "reviewed", "rejected"
  final DateTime? requestedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MeasurementRequestModel({
    this.id,
    this.userId,
    this.profileId,
    this.customerId,
    this.vendorId,
    this.tailorId,
    this.frontPhotoId,
    this.sidePhotoId,
    this.backPhotoId,
    this.measurementSource,
    this.platformMeasurementFee,
    this.vendorMeasurementReviewFee,
    this.totalMeasurementFee,
    this.currency,
    this.paymentRequired,
    this.paymentStatus,
    this.platformFeeStatus,
    this.vendorPayoutStatus,
    this.vendorReviewFeeEnabled,
    this.adminFeeEnabled,
    this.freeTesterMode,
    this.measurementStatus,
    this.reviewStatus,
    this.tailorNotes,
    this.notes,
    this.status,
    this.requestedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory MeasurementRequestModel.fromJson(Map<String, dynamic> json) {
    return MeasurementRequestModel(
      id: json['id'],
      userId: json['user_id'],
      profileId: json['profile_id'],
      customerId: json['customer_id'],
      vendorId: json['vendor_id'],
      tailorId: json['tailor_id'],
      frontPhotoId: json['front_photo_id'],
      sidePhotoId: json['side_photo_id'],
      backPhotoId: json['back_photo_id'],
      measurementSource: json['measurement_source'],
      platformMeasurementFee: double.tryParse(
        json['platform_measurement_fee']?.toString() ?? '',
      ),
      vendorMeasurementReviewFee: double.tryParse(
        json['vendor_measurement_review_fee']?.toString() ?? '',
      ),
      totalMeasurementFee: double.tryParse(
        json['total_measurement_fee']?.toString() ?? '',
      ),
      currency: json['currency'],
      paymentRequired: json['payment_required'],
      paymentStatus: json['payment_status'],
      platformFeeStatus: json['platform_fee_status'],
      vendorPayoutStatus: json['vendor_payout_status'],
      vendorReviewFeeEnabled: json['vendor_review_fee_enabled'],
      adminFeeEnabled: json['admin_fee_enabled'],
      freeTesterMode: json['free_tester_mode'],
      measurementStatus: json['measurement_status'],
      reviewStatus: json['review_status'],
      tailorNotes: json['tailor_notes'],
      notes: json['notes'],
      status: json['status'],
      requestedAt: json['requested_at'] != null
          ? DateTime.tryParse(json['requested_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'profile_id': profileId,
      'customer_id': customerId,
      'vendor_id': vendorId,
      'tailor_id': tailorId,
      'front_photo_id': frontPhotoId,
      'side_photo_id': sidePhotoId,
      'back_photo_id': backPhotoId,
      'measurement_source': measurementSource,
      'platform_measurement_fee': platformMeasurementFee,
      'vendor_measurement_review_fee': vendorMeasurementReviewFee,
      'total_measurement_fee': totalMeasurementFee,
      'currency': currency,
      'payment_required': paymentRequired,
      'payment_status': paymentStatus,
      'platform_fee_status': platformFeeStatus,
      'vendor_payout_status': vendorPayoutStatus,
      'vendor_review_fee_enabled': vendorReviewFeeEnabled,
      'admin_fee_enabled': adminFeeEnabled,
      'free_tester_mode': freeTesterMode,
      'measurement_status': measurementStatus,
      'review_status': reviewStatus,
      'tailor_notes': tailorNotes,
      'notes': notes,
      'status': status,
      'requested_at': requestedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
