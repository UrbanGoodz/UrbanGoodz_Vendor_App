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
}
