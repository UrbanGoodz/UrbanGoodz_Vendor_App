class UrbanGoodzEventModel {
  final String id;
  final String title;
  final String description;
  final String locationLabel;
  final String scheduleLabel;
  final String status;

  const UrbanGoodzEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.locationLabel,
    required this.scheduleLabel,
    required this.status,
  });

  factory UrbanGoodzEventModel.fromJson(Map<String, dynamic> json) {
    return UrbanGoodzEventModel(
      id: json['id']?.toString() ?? '',
      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          'Urban Goodz Event',
      description: json['description']?.toString() ?? '',
      locationLabel:
          json['location_label']?.toString() ??
          json['locationLabel']?.toString() ??
          json['location']?.toString() ??
          'Location pending',
      scheduleLabel:
          json['schedule_label']?.toString() ??
          json['scheduleLabel']?.toString() ??
          json['date']?.toString() ??
          'Date pending',
      status: json['status']?.toString() ?? 'available',
    );
  }
}
