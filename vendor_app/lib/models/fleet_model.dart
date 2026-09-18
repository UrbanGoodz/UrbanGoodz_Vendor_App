/// One of the vendor's own drivers, as returned by
/// GET urban-goodz/cross-app/ai/vendor/drivers.
class FleetDriver {
  final int id;
  final String name;
  final String phone;
  final String approvalStatus;
  final String dispatchStatus;
  final bool active;
  final int currentOrders;
  final int? activeOrderId;
  final String? activeOrderStatus;

  const FleetDriver({
    required this.id,
    required this.name,
    required this.phone,
    required this.approvalStatus,
    required this.dispatchStatus,
    required this.active,
    required this.currentOrders,
    this.activeOrderId,
    this.activeOrderStatus,
  });

  factory FleetDriver.fromJson(Map<String, dynamic> json) => FleetDriver(
    id: _int(json['id']),
    name: json['name']?.toString().trim().isNotEmpty == true
        ? json['name'].toString().trim()
        : 'Driver #${json['id']}',
    phone: json['phone']?.toString() ?? '',
    approvalStatus: json['approval_status']?.toString() ?? '',
    dispatchStatus: json['network_dispatch_status']?.toString() ?? '',
    active: json['active'] == true || json['active']?.toString() == '1',
    currentOrders: _int(json['current_orders']),
    activeOrderId: int.tryParse(json['active_order_id']?.toString() ?? ''),
    activeOrderStatus: json['active_order_status']?.toString(),
  );

  /// Mirrors the checks UrbanGoodzDriverNetworkService::assignToBusinessOrder
  /// makes, so the app only offers Assign when the server would accept it.
  bool get canAssign =>
      approvalStatus == 'approved' &&
      active &&
      currentOrders == 0 &&
      (dispatchStatus == 'available' || dispatchStatus == 'available_for_ug');

  /// The server refuses to release a driver who already has the goods.
  bool get canRelease =>
      activeOrderId != null && activeOrderStatus != 'picked_up';
}

/// An order the vendor can put one of their drivers on right now, from
/// GET urban-goodz/cross-app/ai/vendor/drivers/assignable-orders.
class AssignableOrder {
  final int id;
  final String status;
  final double amount;
  final String? customerName;
  final String? deliveryAddress;
  final DateTime? createdAt;

  const AssignableOrder({
    required this.id,
    required this.status,
    required this.amount,
    this.customerName,
    this.deliveryAddress,
    this.createdAt,
  });

  factory AssignableOrder.fromJson(Map<String, dynamic> json) =>
      AssignableOrder(
        id: _int(json['id']),
        status: json['order_status']?.toString() ?? '',
        amount: double.tryParse(json['order_amount']?.toString() ?? '') ?? 0,
        customerName: json['customer_name']?.toString(),
        deliveryAddress: json['delivery_address']?.toString(),
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      );
}

class FleetSummary {
  final int driversTotal;
  final int driversAvailable;
  final int driversOnJob;
  final int driversPending;
  final int deliveriesToday;
  final int deliveriesCompleted;
  final int deliveriesInProgress;

  const FleetSummary({
    this.driversTotal = 0,
    this.driversAvailable = 0,
    this.driversOnJob = 0,
    this.driversPending = 0,
    this.deliveriesToday = 0,
    this.deliveriesCompleted = 0,
    this.deliveriesInProgress = 0,
  });

  factory FleetSummary.fromJson(Map<String, dynamic> json) {
    final drivers = json['drivers'] is Map
        ? Map<String, dynamic>.from(json['drivers'])
        : <String, dynamic>{};
    final deliveries = json['deliveries_today'] is Map
        ? Map<String, dynamic>.from(json['deliveries_today'])
        : <String, dynamic>{};
    return FleetSummary(
      driversTotal: _int(drivers['total']),
      driversAvailable: _int(drivers['available']),
      driversOnJob: _int(drivers['on_business_job']),
      driversPending: _int(drivers['pending_approval']),
      deliveriesToday: _int(deliveries['total']),
      deliveriesCompleted: _int(deliveries['completed']),
      deliveriesInProgress: _int(deliveries['in_progress']),
    );
  }
}

int _int(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;
