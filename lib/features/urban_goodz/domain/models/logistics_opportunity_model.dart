import 'package:flutter/material.dart';

class LogisticsOpportunityModel {
  final String id;
  final String title;
  final String category;
  final String pickupLabel;
  final String dropoffLabel;
  final String vehicleType;
  final String payLabel;
  final String distanceLabel;
  final String scheduleLabel;
  final IconData icon;

  const LogisticsOpportunityModel({
    required this.id,
    required this.title,
    required this.category,
    required this.pickupLabel,
    required this.dropoffLabel,
    required this.vehicleType,
    required this.payLabel,
    required this.distanceLabel,
    required this.scheduleLabel,
    required this.icon,
  });

  factory LogisticsOpportunityModel.fromJson(Map<String, dynamic> json) {
    final String category =
        json['category']?.toString() ??
        json['load_type']?.toString() ??
        'Logistics Load';
    final String vehicleType =
        json['vehicle_type']?.toString() ??
        json['vehicleType']?.toString() ??
        json['equipment_type']?.toString() ??
        'Car';
    final String? origin = _formatLocation(
      name: json['origin_name'],
      city: json['origin_city'],
      state: json['origin_state'],
    );
    final String? destination = _formatLocation(
      name: json['destination_name'],
      city: json['destination_city'],
      state: json['destination_state'],
    );
    final String? payout = _formatMoney(json['payout_amount']);
    final String? distance = json['distance_miles'] == null
        ? null
        : '${json['distance_miles']} mi';

    return LogisticsOpportunityModel(
      id: json['id']?.toString() ?? '',
      title:
          json['title']?.toString() ??
          json['load_number']?.toString() ??
          'Logistics Opportunity',
      category: category,
      pickupLabel:
          json['pickup_label']?.toString() ??
          json['pickupLabel']?.toString() ??
          origin ??
          'Pickup pending',
      dropoffLabel:
          json['dropoff_label']?.toString() ??
          json['dropoffLabel']?.toString() ??
          destination ??
          'Dropoff pending',
      vehicleType: vehicleType,
      payLabel:
          json['pay_label']?.toString() ??
          json['payLabel']?.toString() ??
          payout ??
          'Varies',
      distanceLabel:
          json['distance_label']?.toString() ??
          json['distanceLabel']?.toString() ??
          distance ??
          'Nearby',
      scheduleLabel:
          json['schedule_label']?.toString() ??
          json['scheduleLabel']?.toString() ??
          json['status']?.toString() ??
          'Flexible',
      icon: iconForVehicle(vehicleType),
    );
  }

  static String? _formatLocation({
    required dynamic name,
    required dynamic city,
    required dynamic state,
  }) {
    final parts = <String>[
      if (name != null && name.toString().trim().isNotEmpty) name.toString(),
      [
        if (city != null && city.toString().trim().isNotEmpty) city.toString(),
        if (state != null && state.toString().trim().isNotEmpty) state.toString(),
      ].join(', '),
    ].where((part) => part.trim().isNotEmpty).toList();
    if (parts.isEmpty) return null;
    return parts.join(' - ');
  }

  static String? _formatMoney(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    final amount = num.tryParse(value.toString());
    if (amount == null) return '\$${value.toString()}';
    return '\$${amount.toStringAsFixed(2)}';
  }

  static IconData iconForVehicle(String vehicleType) {
    final String normalized = vehicleType.toLowerCase();
    if (normalized.contains('cargo') || normalized.contains('sprinter')) return Icons.airport_shuttle_outlined;
    if (normalized.contains('pickup')) return Icons.local_shipping_outlined;
    if (normalized.contains('box')) return Icons.inventory_2_outlined;
    if (normalized.contains('enterprise')) return Icons.business_outlined;
    return Icons.route_outlined;
  }
}
