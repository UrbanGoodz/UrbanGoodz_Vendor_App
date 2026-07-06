enum RequestStatus {
  quote_pending,
  payment_pending,
  staged_test,
  cod_approved,
  paid,
  failed,
  refund_pending,
  refunded,
  assigned,
  accepted,
  arrived,
  picked_up,
  out_for_delivery,
  delivered,
  cancelled,
}

enum OrderAnywhereRequestStatus {
  draft,
  pendingPayment,
  submitted,
  adminReviewing,
  needsInfo,
  vendorRunnerAssigned,
  driverPending,
  driverAssigned,
  inProgress,
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
      case OrderAnywhereRequestStatus.draft:
        return 'draft';
      case OrderAnywhereRequestStatus.pendingPayment:
        return 'pending_payment';
      case OrderAnywhereRequestStatus.submitted:
        return 'submitted';
      case OrderAnywhereRequestStatus.adminReviewing:
        return 'admin_reviewing';
      case OrderAnywhereRequestStatus.needsInfo:
        return 'needs_info';
      case OrderAnywhereRequestStatus.vendorRunnerAssigned:
        return 'vendor_runner_assigned';
      case OrderAnywhereRequestStatus.driverPending:
        return 'driver_pending';
      case OrderAnywhereRequestStatus.driverAssigned:
        return 'driver_assigned';
      case OrderAnywhereRequestStatus.inProgress:
        return 'in_progress';
      case OrderAnywhereRequestStatus.purchasing:
        return 'purchasing';
      case OrderAnywhereRequestStatus.receiptUploaded:
        return 'receipt_uploaded';
      case OrderAnywhereRequestStatus.adjustmentRequired:
        return 'adjustment_required';
      case OrderAnywhereRequestStatus.outForDelivery:
        return 'out_for_delivery';
      case OrderAnywhereRequestStatus.delivered:
        return 'delivered';
      case OrderAnywhereRequestStatus.completed:
        return 'completed';
      case OrderAnywhereRequestStatus.cancelled:
        return 'cancelled';
      case OrderAnywhereRequestStatus.refunded:
        return 'refunded';
    }
  }

  static OrderAnywhereRequestStatus fromString(String s) {
    switch (s) {
      case 'draft':
        return OrderAnywhereRequestStatus.draft;
      case 'pending_payment':
        return OrderAnywhereRequestStatus.pendingPayment;
      case 'submitted':
        return OrderAnywhereRequestStatus.submitted;
      case 'admin_reviewing':
        return OrderAnywhereRequestStatus.adminReviewing;
      case 'needs_info':
        return OrderAnywhereRequestStatus.needsInfo;
      case 'vendor_runner_assigned':
        return OrderAnywhereRequestStatus.vendorRunnerAssigned;
      case 'driver_pending':
        return OrderAnywhereRequestStatus.driverPending;
      case 'driver_assigned':
        return OrderAnywhereRequestStatus.driverAssigned;
      case 'in_progress':
        return OrderAnywhereRequestStatus.inProgress;
      case 'purchasing':
        return OrderAnywhereRequestStatus.purchasing;
      case 'receipt_uploaded':
        return OrderAnywhereRequestStatus.receiptUploaded;
      case 'adjustment_required':
        return OrderAnywhereRequestStatus.adjustmentRequired;
      case 'out_for_delivery':
        return OrderAnywhereRequestStatus.outForDelivery;
      case 'delivered':
        return OrderAnywhereRequestStatus.delivered;
      case 'completed':
        return OrderAnywhereRequestStatus.completed;
      case 'cancelled':
        return OrderAnywhereRequestStatus.cancelled;
      case 'refunded':
        return OrderAnywhereRequestStatus.refunded;
      default:
        return OrderAnywhereRequestStatus.draft;
    }
  }

  bool get isPreDispatch =>
      this == OrderAnywhereRequestStatus.draft ||
      this == OrderAnywhereRequestStatus.pendingPayment ||
      this == OrderAnywhereRequestStatus.submitted;

  bool get isDispatchAllowed => this == OrderAnywhereRequestStatus.submitted;
}

enum OrderAnywherePaymentStatus {
  unpaid,
  quotePending,
  pendingPayment,
  authorized,
  paid,
  paidTest,
  refunded,
  failed;

  String get value {
    switch (this) {
      case OrderAnywherePaymentStatus.unpaid:
        return 'unpaid';
      case OrderAnywherePaymentStatus.quotePending:
        return 'quote_pending';
      case OrderAnywherePaymentStatus.pendingPayment:
        return 'pending_payment';
      case OrderAnywherePaymentStatus.authorized:
        return 'authorized';
      case OrderAnywherePaymentStatus.paid:
        return 'paid';
      case OrderAnywherePaymentStatus.paidTest:
        return 'paid_test';
      case OrderAnywherePaymentStatus.refunded:
        return 'refunded';
      case OrderAnywherePaymentStatus.failed:
        return 'failed';
    }
  }

  static OrderAnywherePaymentStatus fromString(String s) {
    switch (s) {
      case 'quote_pending':
        return OrderAnywherePaymentStatus.quotePending;
      case 'pending_payment':
        return OrderAnywherePaymentStatus.pendingPayment;
      case 'authorized':
        return OrderAnywherePaymentStatus.authorized;
      case 'paid':
        return OrderAnywherePaymentStatus.paid;
      case 'paid_test':
        return OrderAnywherePaymentStatus.paidTest;
      case 'refunded':
        return OrderAnywherePaymentStatus.refunded;
      case 'failed':
        return OrderAnywherePaymentStatus.failed;
      case 'unpaid':
      default:
        return OrderAnywherePaymentStatus.unpaid;
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

enum OrderAnywhereUrgency {
  standard,
  asap,
  scheduled;

  String get label {
    switch (this) {
      case OrderAnywhereUrgency.standard:
        return 'Standard';
      case OrderAnywhereUrgency.asap:
        return 'ASAP';
      case OrderAnywhereUrgency.scheduled:
        return 'Scheduled';
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
  String? adminNotes;
  String? vendorNotes;
  String? driverNotes;
  String? driverTaskStatus;
  bool backendLimited;
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
    this.adminNotes,
    this.vendorNotes,
    this.driverNotes,
    this.driverTaskStatus,
    this.backendLimited = false,
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
    String? adminNotes,
    String? vendorNotes,
    String? driverNotes,
    String? driverTaskStatus,
    bool? backendLimited,
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
      adminNotes: adminNotes ?? this.adminNotes,
      vendorNotes: vendorNotes ?? this.vendorNotes,
      driverNotes: driverNotes ?? this.driverNotes,
      driverTaskStatus: driverTaskStatus ?? this.driverTaskStatus,
      backendLimited: backendLimited ?? this.backendLimited,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderAnywhereRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderAnywhereRequestModel(
      id: json['id']?.toString(),
      customerId: json['customer_id']?.toString(),
      requestStatus: json['request_status'] != null
          ? OrderAnywhereRequestStatus.fromString(json['request_status'].toString())
          : OrderAnywhereRequestStatus.draft,
      businessName: json['business_name']?.toString() ?? '',
      businessAddress: json['business_address']?.toString(),
      businessAddressUnknown: json['business_address_unknown'] == true,
      assignedDriverId: json['assigned_driver_id']?.toString(),
      itemName: json['item_name']?.toString() ?? '',
      itemDescription: json['item_description']?.toString(),
      quantity: _intFromJson(json['quantity'], fallback: 1),
      estimatedItemCost: _doubleFromJson(json['estimated_item_cost']),
      customerNotes: json['customer_notes']?.toString(),
      pickupPreference: _pickupPreferenceFromJson(json['pickup_preference']),
      deliveryAddress: json['delivery_address']?.toString(),
      contactPhone: json['contact_phone']?.toString(),
      imagePath: json['image_path']?.toString(),
      urgency: _urgencyFromJson(json['urgency']),
      consentGiven: json['consent_given'] == true,
      deliveryFee: _doubleFromJson(json['delivery_fee'], fallback: 7.99),
      serviceFee: _doubleFromJson(json['service_fee'], fallback: 5.0),
      tip: _doubleFromJson(json['tip']),
      estimatedTotal: _doubleFromJson(json['estimated_total']),
      paymentStatus: json['payment_status'] != null
          ? OrderAnywherePaymentStatus.fromString(json['payment_status'].toString())
          : OrderAnywherePaymentStatus.unpaid,
      receiptAmount: _nullableDoubleFromJson(json['receipt_amount']),
      receiptDifference: _nullableDoubleFromJson(json['receipt_difference']),
      receiptImage: json['receipt_image']?.toString(),
      receiptNotes: json['receipt_notes']?.toString(),
      reconciliationStatus: json['reconciliation_status']?.toString(),
      adminNotes: json['admin_notes']?.toString(),
      vendorNotes: json['vendor_notes']?.toString(),
      driverNotes: json['driver_notes']?.toString(),
      driverTaskStatus: json['driver_task_status']?.toString(),
      backendLimited: json['backend_limited'] == true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
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
      if (adminNotes != null) 'admin_notes': adminNotes,
      if (vendorNotes != null) 'vendor_notes': vendorNotes,
      if (driverNotes != null) 'driver_notes': driverNotes,
      if (driverTaskStatus != null) 'driver_task_status': driverTaskStatus,
      'backend_limited': backendLimited,
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

class OrderAnywhereRequest {
  final String id;
  final String itemName;
  final RequestStatus requestStatus;
  final bool backendLimited;
  final String? adminNotes;

  OrderAnywhereRequest({
    required this.id,
    required this.itemName,
    required this.requestStatus,
    this.backendLimited = false,
    this.adminNotes,
  });

  factory OrderAnywhereRequest.fromJson(Map<String, dynamic> json) {
    final status = (json['request_status'] ?? json['status'] ?? 'quote_pending').toString();
    return OrderAnywhereRequest(
      id: (json['id'] ?? '').toString(),
      itemName: (json['item_name'] ?? json['itemName'] ?? '').toString(),
      requestStatus: _requestStatusFromJson(status),
      backendLimited: (json['backend_limited'] ?? json['backendLimited'] ?? false) == true,
      adminNotes: (json['admin_notes'] ?? json['adminNotes'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'request_status': requestStatus.name,
      'backend_limited': backendLimited,
      'admin_notes': adminNotes,
    };
  }
}

int _intFromJson(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _doubleFromJson(dynamic value, {double fallback = 0.0}) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

double? _nullableDoubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

OrderAnywherePickupPreference _pickupPreferenceFromJson(dynamic value) {
  return OrderAnywherePickupPreference.values.firstWhere(
    (preference) => preference.name == value?.toString(),
    orElse: () => OrderAnywherePickupPreference.driverPurchases,
  );
}

OrderAnywhereUrgency _urgencyFromJson(dynamic value) {
  return OrderAnywhereUrgency.values.firstWhere(
    (urgency) => urgency.name == value?.toString(),
    orElse: () => OrderAnywhereUrgency.standard,
  );
}

RequestStatus _requestStatusFromJson(String value) {
  final normalized = value.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  return RequestStatus.values.firstWhere(
    (status) => status.name == normalized,
    orElse: () => RequestStatus.quote_pending,
  );
}
