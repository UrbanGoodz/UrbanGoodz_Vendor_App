class MeasurementRequestModel {
  final int? id;
  final String? uuid;
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
  final String? stylistNotes;
  final double? quoteAmount;
  final String? mockupReference;
  final String? notes;
  final String? itemWanted;
  final String? requestType;
  final String? inspirationImageReference;
  final DateTime? dueDate;
  final double? budget;
  final bool? consentToSharePhotos;
  final Map<String, dynamic>? customerProfile;
  final Map<String, dynamic>? measurements;
  final Map<String, dynamic>? photoReferences;
  final bool? backendSynced;
  final String? backendMessage;
  final String? status; // "pending", "reviewed", "rejected"
  final DateTime? requestedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MeasurementRequestModel({
    this.id,
    this.uuid,
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
    this.stylistNotes,
    this.quoteAmount,
    this.mockupReference,
    this.notes,
    this.itemWanted,
    this.requestType,
    this.inspirationImageReference,
    this.dueDate,
    this.budget,
    this.consentToSharePhotos,
    this.customerProfile,
    this.measurements,
    this.photoReferences,
    this.backendSynced,
    this.backendMessage,
    this.status,
    this.requestedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory MeasurementRequestModel.fromJson(Map<String, dynamic> json) {
    return MeasurementRequestModel(
      id: json['id'],
      uuid: json['uuid']?.toString(),
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
      stylistNotes: json['stylist_notes'] ?? json['tailor_notes'],
      quoteAmount: double.tryParse(json['quote_amount']?.toString() ?? ''),
      mockupReference: json['mockup_reference'],
      notes: json['notes'],
      itemWanted: json['item_wanted'],
      requestType: json['request_type'],
      inspirationImageReference: json['inspiration_image_reference'],
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'])
          : null,
      budget: double.tryParse(json['budget']?.toString() ?? ''),
      consentToSharePhotos: json['consent_to_share_photos'],
      customerProfile: json['customer_profile'] is Map
          ? Map<String, dynamic>.from(json['customer_profile'])
          : null,
      measurements: json['measurements'] is Map
          ? Map<String, dynamic>.from(json['measurements'])
          : null,
      photoReferences: json['photo_references'] is Map
          ? Map<String, dynamic>.from(json['photo_references'])
          : null,
      backendSynced: json['backend_synced'],
      backendMessage: json['backend_message'],
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
      'uuid': uuid,
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
      'stylist_notes': stylistNotes,
      'quote_amount': quoteAmount,
      'mockup_reference': mockupReference,
      'notes': notes,
      'item_wanted': itemWanted,
      'request_type': requestType,
      'inspiration_image_reference': inspirationImageReference,
      'due_date': dueDate?.toIso8601String(),
      'budget': budget,
      'consent_to_share_photos': consentToSharePhotos,
      'customer_profile': customerProfile,
      'measurements': measurements,
      'photo_references': photoReferences,
      'backend_synced': backendSynced,
      'backend_message': backendMessage,
      'status': status,
      'requested_at': requestedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
