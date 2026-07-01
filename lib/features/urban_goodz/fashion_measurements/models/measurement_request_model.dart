class MeasurementRequestModel {
  final int? id;
  final int? userId;
  final int? profileId;
  final int? frontPhotoId;
  final int? sidePhotoId;
  final String? notes;
  final String? status; // "pending", "reviewed", "rejected"
  final DateTime? requestedAt;

  MeasurementRequestModel({
    this.id,
    this.userId,
    this.profileId,
    this.frontPhotoId,
    this.sidePhotoId,
    this.notes,
    this.status,
    this.requestedAt,
  });

  factory MeasurementRequestModel.fromJson(Map<String, dynamic> json) {
    return MeasurementRequestModel(
      id: json['id'],
      userId: json['user_id'],
      profileId: json['profile_id'],
      frontPhotoId: json['front_photo_id'],
      sidePhotoId: json['side_photo_id'],
      notes: json['notes'],
      status: json['status'],
      requestedAt: json['requested_at'] != null ? DateTime.tryParse(json['requested_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'profile_id': profileId,
      'front_photo_id': frontPhotoId,
      'side_photo_id': sidePhotoId,
      'notes': notes,
      'status': status,
      'requested_at': requestedAt?.toIso8601String(),
    };
  }
}
