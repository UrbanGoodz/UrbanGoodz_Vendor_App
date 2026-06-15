enum OrderAnywhereRequestStatus {
  draft,
  pendingPayment,
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
      case OrderAnywhereRequestStatus.draft: return 'draft';
      case OrderAnywhereRequestStatus.pendingPayment: return 'pending_payment';
      case OrderAnywhereRequestStatus.submitted: return 'submitted';
      case OrderAnywhereRequestStatus.driverPending: return 'driver_pending';
      case OrderAnywhereRequestStatus.driverAssigned: return 'driver_assigned';
      case OrderAnywhereRequestStatus.purchasing: return 'purchasing';
      case OrderAnywhereRequestStatus.receiptUploaded: return 'receipt_uploaded';
      case OrderAnywhereRequestStatus.adjustmentRequired: return 'adjustment_required';
      case OrderAnywhereRequestStatus.outForDelivery: return 'out_for_delivery';
      case OrderAnywhereRequestStatus.delivered: return 'delivered';
      case OrderAnywhereRequestStatus.completed: return 'completed';
      case OrderAnywhereRequestStatus.cancelled: return 'cancelled';
      case OrderAnywhereRequestStatus.refunded: return 'refunded';
    }
  }

  static OrderAnywhereRequestStatus fromString(String s) {
    switch (s) {
      case 'draft': return OrderAnywhereRequestStatus.draft;
      case 'pending_payment': return OrderAnywhereRequestStatus.pendingPayment;
      case 'submitted': return OrderAnywhereRequestStatus.submitted;
      case 'driver_pending': return OrderAnywhereRequestStatus.driverPending;
      case 'driver_assigned': return OrderAnywhereRequestStatus.driverAssigned;
      case 'purchasing': return OrderAnywhereRequestStatus.purchasing;
      case 'receipt_uploaded': return OrderAnywhereRequestStatus.receiptUploaded;
      case 'adjustment_required': return OrderAnywhereRequestStatus.adjustmentRequired;
      case 'out_for_delivery': return OrderAnywhereRequestStatus.outForDelivery;
      case 'delivered': return OrderAnywhereRequestStatus.delivered;
      case 'completed': return OrderAnywhereRequestStatus.completed;
      case 'cancelled': return OrderAnywhereRequestStatus.cancelled;
      case 'refunded': return OrderAnywhereRequestStatus.refunded;
      default: return OrderAnywhereRequestStatus.draft;
    }
  }

  bool get isPreDispatch =>
      this == OrderAnywhereRequestStatus.draft ||
      this == OrderAnywhereRequestStatus.pendingPayment ||
      this == OrderAnywhereRequestStatus.submitted;

  bool get isDispatchAllowed =>
      this == OrderAnywhereRequestStatus.submitted;
}

enum OrderAnywherePaymentStatus {
  unpaid,
  pendingPayment,
  authorized,
  paid,
  paidTest,
  refunded,
  failed;

  String get value {
    switch (this) {
      case OrderAnywherePaymentStatus.unpaid: return 'unpaid';
      case OrderAnywherePaymentStatus.pendingPayment: return 'pending_payment';
      case OrderAnywherePaymentStatus.authorized: return 'authorized';
      case OrderAnywherePaymentStatus.paid: return 'paid';
      case OrderAnywherePaymentStatus.paidTest: return 'paid_test';
      case OrderAnywherePaymentStatus.refunded: return 'refunded';
      case OrderAnywherePaymentStatus.failed: return 'failed';
    }
  }

  static OrderAnywherePaymentStatus fromString(String s) {
    switch (s) {
      case 'unpaid': return OrderAnywherePaymentStatus.unpaid;
      case 'pending_payment': return OrderAnywherePaymentStatus.pendingPayment;
      case 'authorized': return OrderAnywherePaymentStatus.authorized;
      case 'paid': return OrderAnywherePaymentStatus.paid;
      case 'paid_test': return OrderAnywherePaymentStatus.paidTest;
      case 'refunded': return OrderAnywherePaymentStatus.refunded;
      case 'failed': return OrderAnywherePaymentStatus.failed;
      default: return OrderAnywherePaymentStatus.unpaid;
    }
  }
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
  String? customerId;
  OrderAnywhereRequestStatus requestStatus;
  String businessName;
  String? businessAddress;
  bool businessAddressUnknown;
  String? assignedDriverId;
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

  double deliveryFee;
  double serviceFee;
  double tip;
  double estimatedTotal;

  OrderAnywherePaymentStatus paymentStatus;

  double? receiptAmount;
  double? receiptDifference;
  String? receiptImage;
  String? receiptNotes;
  String? reconciliationStatus;

  String? createdAt;
  String? updatedAt;

  OrderAnywhereRequestModel({
    this.id,
    this.customerId,
    this.requestStatus = OrderAnywhereRequestStatus.draft,
    this.businessName = '',
    this.businessAddress,
    this.businessAddressUnknown = false,
    this.assignedDriverId,
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
    this.deliveryFee = 7.99,
    this.serviceFee = 5.0,
    this.tip = 0.0,
    this.estimatedTotal = 0.0,
    this.paymentStatus = OrderAnywherePaymentStatus.unpaid,
    this.receiptAmount,
    this.receiptDifference,
    this.receiptImage,
    this.receiptNotes,
    this.reconciliationStatus,
    this.createdAt,
    this.updatedAt,
  });

  OrderAnywhereRequestModel copyWith({
    String? id,
    String? customerId,
    OrderAnywhereRequestStatus? requestStatus,
    String? businessName,
    String? businessAddress,
    bool? businessAddressUnknown,
    String? assignedDriverId,
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
    double? deliveryFee,
    double? serviceFee,
    double? tip,
    double? estimatedTotal,
    OrderAnywherePaymentStatus? paymentStatus,
    double? receiptAmount,
    double? receiptDifference,
    String? receiptImage,
    String? receiptNotes,
    String? reconciliationStatus,
    String? createdAt,
    String? updatedAt,
  }) {
    return OrderAnywhereRequestModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      requestStatus: requestStatus ?? this.requestStatus,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      businessAddressUnknown: businessAddressUnknown ?? this.businessAddressUnknown,
      assignedDriverId: assignedDriverId ?? this.assignedDriverId,
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
      deliveryFee: deliveryFee ?? this.deliveryFee,
      serviceFee: serviceFee ?? this.serviceFee,
      tip: tip ?? this.tip,
      estimatedTotal: estimatedTotal ?? this.estimatedTotal,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      receiptAmount: receiptAmount ?? this.receiptAmount,
      receiptDifference: receiptDifference ?? this.receiptDifference,
      receiptImage: receiptImage ?? this.receiptImage,
      receiptNotes: receiptNotes ?? this.receiptNotes,
      reconciliationStatus: reconciliationStatus ?? this.reconciliationStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderAnywhereRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderAnywhereRequestModel(
      id: json['id']?.toString(),
      customerId: json['customer_id']?.toString(),
      requestStatus: json['request_status'] != null
          ? OrderAnywhereRequestStatus.fromString(json['request_status'])
          : OrderAnywhereRequestStatus.draft,
      businessName: json['business_name'] ?? '',
      businessAddress: json['business_address'],
      businessAddressUnknown: json['business_address_unknown'] == true,
      assignedDriverId: json['assigned_driver_id']?.toString(),
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
      deliveryFee: json['delivery_fee'] != null ? (json['delivery_fee'] is double ? json['delivery_fee'] : double.tryParse(json['delivery_fee'].toString()) ?? 7.99) : 7.99,
      serviceFee: json['service_fee'] != null ? (json['service_fee'] is double ? json['service_fee'] : double.tryParse(json['service_fee'].toString()) ?? 5.0) : 5.0,
      tip: json['tip'] != null ? (json['tip'] is double ? json['tip'] : double.tryParse(json['tip'].toString()) ?? 0.0) : 0.0,
      estimatedTotal: json['estimated_total'] != null ? (json['estimated_total'] is double ? json['estimated_total'] : double.tryParse(json['estimated_total'].toString()) ?? 0.0) : 0.0,
      paymentStatus: json['payment_status'] != null
          ? OrderAnywherePaymentStatus.fromString(json['payment_status'])
          : OrderAnywherePaymentStatus.unpaid,
      receiptAmount: json['receipt_amount'] != null ? (json['receipt_amount'] is double ? json['receipt_amount'] : double.tryParse(json['receipt_amount'].toString())) : null,
      receiptDifference: json['receipt_difference'] != null ? (json['receipt_difference'] is double ? json['receipt_difference'] : double.tryParse(json['receipt_difference'].toString())) : null,
      receiptImage: json['receipt_image'],
      receiptNotes: json['receipt_notes'],
      reconciliationStatus: json['reconciliation_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      'request_status': requestStatus.value,
      'business_name': businessName,
      if (businessAddress != null) 'business_address': businessAddress,
      'business_address_unknown': businessAddressUnknown,
      if (assignedDriverId != null) 'assigned_driver_id': assignedDriverId,
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
      'delivery_fee': deliveryFee,
      'service_fee': serviceFee,
      'tip': tip,
      'estimated_total': estimatedTotal,
      'payment_status': paymentStatus.value,
      if (receiptAmount != null) 'receipt_amount': receiptAmount,
      if (receiptDifference != null) 'receipt_difference': receiptDifference,
      if (receiptImage != null) 'receipt_image': receiptImage,
      if (receiptNotes != null) 'receipt_notes': receiptNotes,
      if (reconciliationStatus != null) 'reconciliation_status': reconciliationStatus,
    };
  }

  void recalculateTotal() {
    estimatedTotal = (estimatedItemCost * quantity) + deliveryFee + serviceFee + tip;
  }

  double get serviceFeeCalculated {
    final pct = (estimatedItemCost * quantity) * 0.15;
    return pct < 5.0 ? 5.0 : pct;
  }
}
