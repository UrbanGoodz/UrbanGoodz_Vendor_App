class VendorOrderModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String? driverId;
  final String? driverName;
  final String? notes;

  VendorOrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    this.deliveredAt,
    this.driverId,
    this.driverName,
    this.notes,
  });

  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);
}

class OrderItemModel {
  final String name;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
