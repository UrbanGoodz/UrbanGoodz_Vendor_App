class BookAnythingRecordModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String locationLabel;
  final String scheduleLabel;

  const BookAnythingRecordModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.locationLabel,
    required this.scheduleLabel,
  });

  factory BookAnythingRecordModel.fromJson(Map<String, dynamic> json) {
    return BookAnythingRecordModel(
      id: json['id']?.toString() ?? '',
      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          'Book Anything Request',
      description:
          json['description']?.toString() ?? json['notes']?.toString() ?? '',
      category:
          json['category']?.toString() ?? json['type']?.toString() ?? 'General',
      status: json['status']?.toString() ?? 'pending',
      locationLabel:
          json['location_label']?.toString() ??
          json['locationLabel']?.toString() ??
          json['location']?.toString() ??
          'Location pending',
      scheduleLabel:
          json['schedule_label']?.toString() ??
          json['scheduleLabel']?.toString() ??
          json['schedule']?.toString() ??
          'Flexible',
    );
  }
}
