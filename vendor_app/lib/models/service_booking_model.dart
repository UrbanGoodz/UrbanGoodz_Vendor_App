class ServiceBookingModel {
  final String id;
  final String serviceName;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final DateTime bookingDate;
  final String timeSlot;
  final double amount;
  final String status;
  final String? notes;
  final DateTime createdAt;

  ServiceBookingModel({
    required this.id,
    required this.serviceName,
    required this.customerName,
    this.customerPhone = '',
    required this.customerEmail,
    required this.bookingDate,
    required this.timeSlot,
    required this.amount,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory ServiceBookingModel.fromJson(Map<String, dynamic> json) {
    final scheduled =
        DateTime.tryParse(
          (json['scheduled_at'] ?? json['requested_start_at'] ?? '').toString(),
        ) ??
        DateTime.now();
    final minor =
        int.tryParse((json['quoted_amount_minor'] ?? 0).toString()) ?? 0;
    return ServiceBookingModel(
      id: json['id']?.toString() ?? '',
      serviceName:
          json['service_type']?.toString().replaceAll('_', ' ') ?? 'Service',
      customerName: json['customer_name']?.toString() ?? 'Customer',
      customerPhone: json['customer_phone']?.toString() ?? '',
      customerEmail: json['customer_email']?.toString() ?? '',
      bookingDate: scheduled.toLocal(),
      timeSlot:
          '${scheduled.toLocal().hour.toString().padLeft(2, '0')}:${scheduled.toLocal().minute.toString().padLeft(2, '0')}',
      amount: minor / 100,
      status: json['status']?.toString() ?? 'requested',
      notes: (json['provider_notes'] ?? json['description'])?.toString(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
