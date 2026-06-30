class DiscoveryOpportunityModel {
  final int? id;
  final String? title;
  final String? type;
  final String? status;
  final String? city;
  final String? state;

  const DiscoveryOpportunityModel({
    this.id,
    this.title,
    this.type,
    this.status,
    this.city,
    this.state,
  });

  factory DiscoveryOpportunityModel.fromJson(Map<String, dynamic> json) {
    return DiscoveryOpportunityModel(
      id: int.tryParse(json['id']?.toString() ?? ''),
      title: json['title']?.toString() ?? json['name']?.toString(),
      type: json['type']?.toString(),
      status: json['status']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'status': status,
    'city': city,
    'state': state,
  };
}
