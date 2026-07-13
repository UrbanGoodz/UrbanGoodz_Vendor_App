class MeasurementProfileModel {
  final int? id;
  final int? userId;
  final String? profileName;
  final double? height; // in inches/cm
  final double? chestBust;
  final double? waist;
  final double? hips;
  final double? inseam;
  final double? sleeve;
  final double? shoulderWidth;
  final double? neck;
  final String? preferredFit; // e.g. "Slim", "Regular", "Loose"
  final String? notes;
  final DateTime? updatedAt;

  MeasurementProfileModel({
    this.id,
    this.userId,
    this.profileName,
    this.height,
    this.chestBust,
    this.waist,
    this.hips,
    this.inseam,
    this.sleeve,
    this.shoulderWidth,
    this.neck,
    this.preferredFit,
    this.notes,
    this.updatedAt,
  });

  factory MeasurementProfileModel.fromJson(Map<String, dynamic> json) {
    return MeasurementProfileModel(
      id: json['id'],
      userId: json['user_id'],
      profileName: json['profile_name'],
      height: json['height']?.toDouble(),
      chestBust: json['chest_bust']?.toDouble(),
      waist: json['waist']?.toDouble(),
      hips: json['hips']?.toDouble(),
      inseam: json['inseam']?.toDouble(),
      sleeve: json['sleeve']?.toDouble(),
      shoulderWidth: json['shoulder_width']?.toDouble(),
      neck: json['neck']?.toDouble(),
      preferredFit: json['preferred_fit'],
      notes: json['notes'],
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'profile_name': profileName,
      'height': height,
      'chest_bust': chestBust,
      'waist': waist,
      'hips': hips,
      'inseam': inseam,
      'sleeve': sleeve,
      'shoulder_width': shoulderWidth,
      'neck': neck,
      'preferred_fit': preferredFit,
      'notes': notes,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MeasurementProfileModel copyWith({
    int? id,
    int? userId,
    String? profileName,
    double? height,
    double? chestBust,
    double? waist,
    double? hips,
    double? inseam,
    double? sleeve,
    double? shoulderWidth,
    double? neck,
    String? preferredFit,
    String? notes,
    DateTime? updatedAt,
  }) {
    return MeasurementProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profileName: profileName ?? this.profileName,
      height: height ?? this.height,
      chestBust: chestBust ?? this.chestBust,
      waist: waist ?? this.waist,
      hips: hips ?? this.hips,
      inseam: inseam ?? this.inseam,
      sleeve: sleeve ?? this.sleeve,
      shoulderWidth: shoulderWidth ?? this.shoulderWidth,
      neck: neck ?? this.neck,
      preferredFit: preferredFit ?? this.preferredFit,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
