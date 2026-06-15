enum OrderAnywhereStatus {
  draft,
  pendingPayment,
  paidTest,
  submitted,
  driverPending,
  driverAssigned,
  purchasing,
  receiptUploaded,
  adjustmentRequired,
  outForDelivery,
  delivered,
  completed,
  cancelled,
  refunded;

  String get value {
    switch (this) {
      case OrderAnywhereStatus.draft: return 'draft';
      case OrderAnywhereStatus.pendingPayment: return 'pending_payment';
      case OrderAnywhereStatus.paidTest: return 'paid_test';
      case OrderAnywhereStatus.submitted: return 'submitted';
      case OrderAnywhereStatus.driverPending: return 'driver_pending';
      case OrderAnywhereStatus.driverAssigned: return 'driver_assigned';
      case OrderAnywhereStatus.purchasing: return 'purchasing';
      case OrderAnywhereStatus.receiptUploaded: return 'receipt_uploaded';
      case OrderAnywhereStatus.adjustmentRequired: return 'adjustment_required';
      case OrderAnywhereStatus.outForDelivery: return 'out_for_delivery';
      case OrderAnywhereStatus.delivered: return 'delivered';
      case OrderAnywhereStatus.completed: return 'completed';
      case OrderAnywhereStatus.cancelled: return 'cancelled';
      case OrderAnywhereStatus.refunded: return 'refunded';
    }
  }

  static OrderAnywhereStatus fromString(String s) {
    switch (s) {
      case 'draft': return OrderAnywhereStatus.draft;
      case 'pending_payment': return OrderAnywhereStatus.pendingPayment;
      case 'paid_test': return OrderAnywhereStatus.paidTest;
      case 'submitted': return OrderAnywhereStatus.submitted;
      case 'driver_pending': return OrderAnywhereStatus.driverPending;
      case 'driver_assigned': return OrderAnywhereStatus.driverAssigned;
      case 'purchasing': return OrderAnywhereStatus.purchasing;
      case 'receipt_uploaded': return OrderAnywhereStatus.receiptUploaded;
      case 'adjustment_required': return OrderAnywhereStatus.adjustmentRequired;
      case 'out_for_delivery': return OrderAnywhereStatus.outForDelivery;
      case 'delivered': return OrderAnywhereStatus.delivered;
      case 'completed': return OrderAnywhereStatus.completed;
      case 'cancelled': return OrderAnywhereStatus.cancelled;
      case 'refunded': return OrderAnywhereStatus.refunded;
      default: return OrderAnywhereStatus.draft;
    }
  }

  bool get isPreDispatch =>
      this == OrderAnywhereStatus.draft ||
      this == OrderAnywhereStatus.pendingPayment ||
      this == OrderAnywhereStatus.paidTest ||
      this == OrderAnywhereStatus.submitted;

  bool get isDispatchAllowed =>
      this == OrderAnywhereStatus.paidTest ||
      this == OrderAnywhereStatus.submitted;
}

enum OrderAnywherePickupPreference {
  driverPurchases,
  customerAlreadyPaid,
  locateItem;

  String get label {
    switch (this) {
      case OrderAnywherePickupPreference.driverPurchases:
        return 'Driver purchases at store';
      case OrderAnywherePickupPreference.customerAlreadyPaid:
        return 'Customer already paid, driver picks up';
      case OrderAnywherePickupPreference.locateItem:
        return 'Need Urban Goodz to locate item';
    }
  }
}

enum OrderAnywhereUrgency { standard, asap, scheduled;

  String get label {
    switch (this) {
      case OrderAnywhereUrgency.standard: return 'Standard';
      case OrderAnywhereUrgency.asap: return 'ASAP';
      case OrderAnywhereUrgency.scheduled: return 'Scheduled';
    }
  }
}

class OrderAnywhereRequestModel {
  String? id;
  OrderAnywhereStatus status;
  String businessName;
  String? businessAddress;
  String itemName;
  String? itemDescription;
  int quantity;
  double estimatedItemCost;
  String? customerNotes;
  OrderAnywherePickupPreference pickupPreference;
  String? deliveryAddress;
  String? contactPhone;
  String? imagePath;
  OrderAnywhereUrgency urgency;
  bool consentGiven;

  double estimatedDeliveryFee;
  double estimatedServiceFee;
  double tip;
  double estimatedTotal;

  String paymentStatus;

  double? receiptActualAmount;
  double? receiptDifference;
  String? receiptReconciliationStatus;

  String? createdAt;
  String? updatedAt;

  OrderAnywhereRequestModel({
    this.id,
    this.status = OrderAnywhereStatus.draft,
    this.businessName = '',
    this.businessAddress,
    this.itemName = '',
    this.itemDescription,
    this.quantity = 1,
    this.estimatedItemCost = 0.0,
    this.customerNotes,
    this.pickupPreference = OrderAnywherePickupPreference.driverPurchases,
    this.deliveryAddress,
    this.contactPhone,
    this.imagePath,
    this.urgency = OrderAnywhereUrgency.standard,
    this.consentGiven = false,
    this.estimatedDeliveryFee = 7.99,
    this.estimatedServiceFee = 5.0,
    this.tip = 0.0,
    this.estimatedTotal = 0.0,
    this.paymentStatus = 'unpaid',
    this.receiptActualAmount,
    this.receiptDifference,
    this.receiptReconciliationStatus,
    this.createdAt,
    this.updatedAt,
  });

  OrderAnywhereRequestModel copyWith({
    String? id,
    OrderAnywhereStatus? status,
    String? businessName,
    String? businessAddress,
    String? itemName,
    String? itemDescription,
    int? quantity,
    double? estimatedItemCost,
    String? customerNotes,
    OrderAnywherePickupPreference? pickupPreference,
    String? deliveryAddress,
    String? contactPhone,
    String? imagePath,
    OrderAnywhereUrgency? urgency,
    bool? consentGiven,
    double? estimatedDeliveryFee,
    double? estimatedServiceFee,
    double? tip,
    double? estimatedTotal,
    String? paymentStatus,
    double? receiptActualAmount,
    double? receiptDifference,
    String? receiptReconciliationStatus,
    String? createdAt,
    String? updatedAt,
  }) {
    return OrderAnywhereRequestModel(
      id: id ?? this.id,
      status: status ?? this.status,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      itemName: itemName ?? this.itemName,
      itemDescription: itemDescription ?? this.itemDescription,
      quantity: quantity ?? this.quantity,
      estimatedItemCost: estimatedItemCost ?? this.estimatedItemCost,
      customerNotes: customerNotes ?? this.customerNotes,
      pickupPreference: pickupPreference ?? this.pickupPreference,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      contactPhone: contactPhone ?? this.contactPhone,
      imagePath: imagePath ?? this.imagePath,
      urgency: urgency ?? this.urgency,
      consentGiven: consentGiven ?? this.consentGiven,
      estimatedDeliveryFee: estimatedDeliveryFee ?? this.estimatedDeliveryFee,
      estimatedServiceFee: estimatedServiceFee ?? this.estimatedServiceFee,
      tip: tip ?? this.tip,
      estimatedTotal: estimatedTotal ?? this.estimatedTotal,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      receiptActualAmount: receiptActualAmount ?? this.receiptActualAmount,
      receiptDifference: receiptDifference ?? this.receiptDifference,
      receiptReconciliationStatus: receiptReconciliationStatus ?? this.receiptReconciliationStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderAnywhereRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderAnywhereRequestModel(
      id: json['id']?.toString(),
      status: json['status'] != null ? OrderAnywhereStatus.fromString(json['status']) : OrderAnywhereStatus.draft,
      businessName: json['business_name'] ?? '',
      businessAddress: json['business_address'],
      itemName: json['item_name'] ?? '',
      itemDescription: json['item_description'],
      quantity: json['quantity'] != null ? (json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity'].toString()) ?? 1) : 1,
      estimatedItemCost: json['estimated_item_cost'] != null ? (json['estimated_item_cost'] is double ? json['estimated_item_cost'] : double.tryParse(json['estimated_item_cost'].toString()) ?? 0.0) : 0.0,
      customerNotes: json['customer_notes'],
      pickupPreference: json['pickup_preference'] != null
          ? OrderAnywherePickupPreference.values.firstWhere(
              (p) => p.name == json['pickup_preference'],
              orElse: () => OrderAnywherePickupPreference.driverPurchases)
          : OrderAnywherePickupPreference.driverPurchases,
      deliveryAddress: json['delivery_address'],
      contactPhone: json['contact_phone'],
      imagePath: json['image_path'],
      urgency: json['urgency'] != null
          ? OrderAnywhereUrgency.values.firstWhere(
              (u) => u.name == json['urgency'],
              orElse: () => OrderAnywhereUrgency.standard)
          : OrderAnywhereUrgency.standard,
      consentGiven: json['consent_given'] == true,
      estimatedDeliveryFee: json['estimated_delivery_fee'] != null ? (json['estimated_delivery_fee'] is double ? json['estimated_delivery_fee'] : double.tryParse(json['estimated_delivery_fee'].toString()) ?? 7.99) : 7.99,
      estimatedServiceFee: json['estimated_service_fee'] != null ? (json['estimated_service_fee'] is double ? json['estimated_service_fee'] : double.tryParse(json['estimated_service_fee'].toString()) ?? 5.0) : 5.0,
      tip: json['tip'] != null ? (json['tip'] is double ? json['tip'] : double.tryParse(json['tip'].toString()) ?? 0.0) : 0.0,
      estimatedTotal: json['estimated_total'] != null ? (json['estimated_total'] is double ? json['estimated_total'] : double.tryParse(json['estimated_total'].toString()) ?? 0.0) : 0.0,
      paymentStatus: json['payment_status'] ?? 'unpaid',
      receiptActualAmount: json['receipt_actual_amount'] != null ? (json['receipt_actual_amount'] is double ? json['receipt_actual_amount'] : double.tryParse(json['receipt_actual_amount'].toString())) : null,
      receiptDifference: json['receipt_difference'] != null ? (json['receipt_difference'] is double ? json['receipt_difference'] : double.tryParse(json['receipt_difference'].toString())) : null,
      receiptReconciliationStatus: json['receipt_reconciliation_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'status': status.value,
      'business_name': businessName,
      if (businessAddress != null) 'business_address': businessAddress,
      'item_name': itemName,
      if (itemDescription != null) 'item_description': itemDescription,
      'quantity': quantity,
      'estimated_item_cost': estimatedItemCost,
      if (customerNotes != null) 'customer_notes': customerNotes,
      'pickup_preference': pickupPreference.name,
      if (deliveryAddress != null) 'delivery_address': deliveryAddress,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (imagePath != null) 'image_path': imagePath,
      'urgency': urgency.name,
      'consent_given': consentGiven,
      'estimated_delivery_fee': estimatedDeliveryFee,
      'estimated_service_fee': estimatedServiceFee,
      'tip': tip,
      'estimated_total': estimatedTotal,
      'payment_status': paymentStatus,
      if (receiptActualAmount != null) 'receipt_actual_amount': receiptActualAmount,
      if (receiptDifference != null) 'receipt_difference': receiptDifference,
      if (receiptReconciliationStatus != null) 'receipt_reconciliation_status': receiptReconciliationStatus,
    };
  }

  void recalculateTotal() {
    estimatedTotal = estimatedItemCost + estimatedDeliveryFee + estimatedServiceFee + tip;
  }

  double get estimatedServiceFeeCalculated {
    final pct = estimatedItemCost * 0.15;
    return pct < 5.0 ? 5.0 : pct;
  }
}
