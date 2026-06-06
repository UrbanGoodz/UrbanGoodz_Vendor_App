import 'package:flutter/material.dart';

class EarnMoneyOpportunityModel {
  final String id;
  final String title;
  final String type;
  final String description;
  final String earningLabel;
  final String distanceLabel;
  final String scheduleLabel;
  final IconData icon;
  final bool recommended;

  const EarnMoneyOpportunityModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.earningLabel,
    required this.distanceLabel,
    required this.scheduleLabel,
    required this.icon,
    this.recommended = false,
  });

  factory EarnMoneyOpportunityModel.fromJson(Map<String, dynamic> json) {
    return EarnMoneyOpportunityModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Earn Money Opportunity',
      type: json['type']?.toString() ?? 'General',
      description: json['description']?.toString() ?? '',
      earningLabel: json['earning_label']?.toString() ?? json['earningLabel']?.toString() ?? 'Varies',
      distanceLabel: json['distance_label']?.toString() ?? json['distanceLabel']?.toString() ?? 'Nearby',
      scheduleLabel: json['schedule_label']?.toString() ?? json['scheduleLabel']?.toString() ?? 'Flexible',
      icon: iconForType(json['type']?.toString() ?? ''),
      recommended: json['recommended'] == true || json['is_recommended'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'earning_label': earningLabel,
      'distance_label': distanceLabel,
      'schedule_label': scheduleLabel,
      'recommended': recommended,
    };
  }

  static IconData iconForType(String type) {
    final String normalized = type.toLowerCase();
    if (normalized.contains('food')) return Icons.delivery_dining;
    if (normalized.contains('shopping')) return Icons.shopping_bag_outlined;
    if (normalized.contains('order anywhere')) return Icons.add_location_alt_outlined;
    if (normalized.contains('logistics') || normalized.contains('loads')) return Icons.local_shipping_outlined;
    if (normalized.contains('medical')) return Icons.medical_services_outlined;
    if (normalized.contains('scheduled')) return Icons.event_available_outlined;
    if (normalized.contains('creator')) return Icons.video_camera_back_outlined;
    if (normalized.contains('merchant') || normalized.contains('referral')) return Icons.handshake_outlined;
    if (normalized.contains('service')) return Icons.home_repair_service_outlined;
    return Icons.work_outline;
  }
}
