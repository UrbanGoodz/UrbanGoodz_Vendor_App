// Minimal Order Anywhere models and enums to satisfy UI & controller references.
// Expand as needed to match backend API shape.

enum RequestStatus {
  // Tester-friendly statuses
  quote_pending,
  payment_pending,
  staged_test,
  cod_approved,
  paid,
  failed,
  refund_pending,
  refunded,

  // Operational / dispatch statuses (add as needed)
  assigned,
  accepted,
  arrived,
  picked_up,
  out_for_delivery,
  delivered,
  cancelled,
}

enum OrderAnywherePickupPreference {
  delivery,
  pickup,
  dropoff,
}

extension PickupPreferenceLabel on OrderAnywherePickupPreference {
  String get label {
    switch (this) {
      case OrderAnywherePickupPreference.delivery:
        return 'Delivery';
      case OrderAnywherePickupPreference.pickup:
        return 'Pickup';
      case OrderAnywherePickupPreference.dropoff:
        return 'Dropoff';
    }
  }
}

enum OrderAnywhereUrgency {
  standard,
  scheduled,
  asap,
}

extension UrgencyLabel on OrderAnywhereUrgency {
  String get label {
    switch (this) {
      case OrderAnywhereUrgency.standard:
        return 'Standard';
      case OrderAnywhereUrgency.scheduled:
        return 'Scheduled';
      case OrderAnywhereUrgency.asap:
        return 'ASAP';
    }
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
    String status = (json['request_status'] as String?) ?? json['status'] ?? 'quote_pending';
    return OrderAnywhereRequest(
      id: (json['id'] ?? '').toString(),
      itemName: (json['item_name'] ?? json['itemName'] ?? '').toString(),
      requestStatus: _parseStatus(status),
      backendLimited: (json['backend_limited'] ?? json['backendLimited'] ?? false) == true,
      adminNotes: json['admin_notes'] ?? json['adminNotes'],
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

  static RequestStatus _parseStatus(String s) {
    try {
      return RequestStatus.values.firstWhere((e) => e.name == s);
    } catch (_) {
      // Fallback mapping for common variants
      switch (s.toLowerCase()) {
        case 'quote_pending':
        case 'quote-pending':
        case 'quote pending':
          return RequestStatus.quote_pending;
        case 'payment_pending':
        case 'payment-pending':
          return RequestStatus.payment_pending;
        case 'staged_test':
        case 'staged-test':
          return RequestStatus.staged_test;
        case 'cod_approved':
        case 'cod-approved':
          return RequestStatus.cod_approved;
        case 'paid':
          return RequestStatus.paid;
        case 'failed':
          return RequestStatus.failed;
        case 'refund_pending':
        case 'refund-pending':
          return RequestStatus.refund_pending;
        case 'refunded':
          return RequestStatus.refunded;
        case 'assigned':
          return RequestStatus.assigned;
        case 'accepted':
          return RequestStatus.accepted;
        case 'arrived':
          return RequestStatus.arrived;
        case 'picked_up':
        case 'picked-up':
          return RequestStatus.picked_up;
        case 'out_for_delivery':
        case 'out-for-delivery':
          return RequestStatus.out_for_delivery;
        case 'delivered':
          return RequestStatus.delivered;
        default:
          return RequestStatus.quote_pending;
      }
    }
  }
}
