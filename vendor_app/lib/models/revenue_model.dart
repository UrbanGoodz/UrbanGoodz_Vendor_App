class RevenueModel {
  final String id;
  final String source;
  final double amount;
  final String status;
  final DateTime date;
  final String description;
  final String transactionType;
  final String orderId;
  final String notes;

  RevenueModel({
    required this.id,
    required this.source,
    required this.amount,
    required this.status,
    required this.date,
    this.description = '',
    this.transactionType = 'sale',
    this.orderId = '',
    this.notes = '',
  });
}
