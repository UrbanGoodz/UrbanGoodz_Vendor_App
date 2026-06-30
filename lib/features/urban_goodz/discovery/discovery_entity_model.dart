class DiscoveryEntityModel {
  final int? id;
  final String? name;
  final String? type;
  final String? status;
  final String? city;
  final String? state;

  const DiscoveryEntityModel({
    this.id,
    this.name,
    this.type,
    this.status,
    this.city,
    this.state,
  });

  factory DiscoveryEntityModel.fromJson(Map<String, dynamic> json) {
    return DiscoveryEntityModel(
      id: int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      status: json['status']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'status': status,
    'city': city,
    'state': state,
  };
}
