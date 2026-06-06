class UrbanGoodzZoneContextModel {
  final int? zoneId;
  final String zoneName;
  final String city;
  final String state;
  final String serviceArea;
  final double? latitude;
  final double? longitude;
  final bool isNationwide;
  final List<int> supportedZoneIds;

  const UrbanGoodzZoneContextModel({
    this.zoneId,
    required this.zoneName,
    required this.city,
    required this.state,
    required this.serviceArea,
    this.latitude,
    this.longitude,
    this.isNationwide = false,
    this.supportedZoneIds = const [],
  });

  factory UrbanGoodzZoneContextModel.fromJson(Map<String, dynamic> json) {
    return UrbanGoodzZoneContextModel(
      zoneId: int.tryParse(json['zone_id']?.toString() ?? json['zoneId']?.toString() ?? ''),
      zoneName: json['zone_name']?.toString() ?? json['zoneName']?.toString() ?? 'Nationwide',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      serviceArea: json['service_area']?.toString() ?? json['serviceArea']?.toString() ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
      isNationwide: json['is_nationwide'] == true || json['isNationwide'] == true,
      supportedZoneIds: (json['supported_zone_ids'] is List)
          ? (json['supported_zone_ids'] as List).map((zone) => int.tryParse(zone.toString()) ?? 0).where((zone) => zone > 0).toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'zone_id': zoneId,
    'zone_name': zoneName,
    'city': city,
    'state': state,
    'service_area': serviceArea,
    'latitude': latitude,
    'longitude': longitude,
    'is_nationwide': isNationwide,
    'supported_zone_ids': supportedZoneIds,
  };
}
