class MeasurementPhotoModel {
  final int? id;
  final int? userId;
  final String? photoUrl;
  final String? orientation; // "front", "side", "back"
  final double? heightRef; // height reference of the user during photo session
  final DateTime? uploadedAt;
  final String? status; // "pending", "approved", "rejected"

  MeasurementPhotoModel({
    this.id,
    this.userId,
    this.photoUrl,
    this.orientation,
    this.heightRef,
    this.uploadedAt,
    this.status,
  });

  factory MeasurementPhotoModel.fromJson(Map<String, dynamic> json) {
    return MeasurementPhotoModel(
      id: json['id'],
      userId: json['user_id'],
      photoUrl: json['photo_url'],
      orientation: json['orientation'],
      heightRef: json['height_ref']?.toDouble(),
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.tryParse(json['uploaded_at'])
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'photo_url': photoUrl,
      'orientation': orientation,
      'height_ref': heightRef,
      'uploaded_at': uploadedAt?.toIso8601String(),
      'status': status,
    };
  }
}
