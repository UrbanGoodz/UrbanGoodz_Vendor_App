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
    final String category = json['category']?.toString() ?? 'Logistics Load';
    final String vehicleType = json['vehicle_type']?.toString() ?? json['vehicleType']?.toString() ?? 'Car';

    return LogisticsOpportunityModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Logistics Opportunity',
      category: category,
      pickupLabel: json['pickup_label']?.toString() ?? json['pickupLabel']?.toString() ?? 'Pickup pending',
      dropoffLabel: json['dropoff_label']?.toString() ?? json['dropoffLabel']?.toString() ?? 'Dropoff pending',
      vehicleType: vehicleType,
      payLabel: json['pay_label']?.toString() ?? json['payLabel']?.toString() ?? 'Varies',
      distanceLabel: json['distance_label']?.toString() ?? json['distanceLabel']?.toString() ?? 'Nearby',
      scheduleLabel: json['schedule_label']?.toString() ?? json['scheduleLabel']?.toString() ?? 'Flexible',
      icon: iconForVehicle(vehicleType),
    );
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
