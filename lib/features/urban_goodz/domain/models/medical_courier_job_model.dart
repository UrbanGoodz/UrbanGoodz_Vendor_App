import 'package:flutter/material.dart';

class MedicalCourierJobModel {
  final String id;
  final String title;
  final String deliveryType;
  final String status;
  final String pickupLabel;
  final String dropoffLabel;
  final String payLabel;
  final String scheduleLabel;
  final String complianceLabel;
  final IconData icon;
  final bool statDelivery;

  const MedicalCourierJobModel({
    required this.id,
    required this.title,
    required this.deliveryType,
    required this.status,
    required this.pickupLabel,
    required this.dropoffLabel,
    required this.payLabel,
    required this.scheduleLabel,
    required this.complianceLabel,
    required this.icon,
    this.statDelivery = false,
  });

  factory MedicalCourierJobModel.fromJson(Map<String, dynamic> json) {
    final String deliveryType = json['delivery_type']?.toString() ?? json['deliveryType']?.toString() ?? 'Medical Courier';

    return MedicalCourierJobModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Medical Courier Job',
      deliveryType: deliveryType,
      status: json['status']?.toString() ?? 'available',
      pickupLabel: json['pickup_label']?.toString() ?? json['pickupLabel']?.toString() ?? 'Pickup pending',
      dropoffLabel: json['dropoff_label']?.toString() ?? json['dropoffLabel']?.toString() ?? 'Dropoff pending',
      payLabel: json['pay_label']?.toString() ?? json['payLabel']?.toString() ?? 'Varies',
      scheduleLabel: json['schedule_label']?.toString() ?? json['scheduleLabel']?.toString() ?? 'Flexible',
      complianceLabel: json['compliance_label']?.toString() ?? json['complianceLabel']?.toString() ?? 'Chain of custody required',
      icon: iconForType(deliveryType),
      statDelivery: json['stat_delivery'] == true || json['statDelivery'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'delivery_type': deliveryType,
      'status': status,
      'pickup_label': pickupLabel,
      'dropoff_label': dropoffLabel,
      'pay_label': payLabel,
      'schedule_label': scheduleLabel,
      'compliance_label': complianceLabel,
      'stat_delivery': statDelivery,
    };
  }

  static IconData iconForType(String type) {
    final String normalized = type.toLowerCase();
    if (normalized.contains('specimen')) return Icons.science_outlined;
    if (normalized.contains('blood')) return Icons.bloodtype_outlined;
    if (normalized.contains('pharmaceutical')) return Icons.medication_outlined;
    if (normalized.contains('equipment')) return Icons.medical_information_outlined;
    if (normalized.contains('records')) return Icons.folder_copy_outlined;
    if (normalized.contains('imaging')) return Icons.image_search_outlined;
    if (normalized.contains('stat')) return Icons.priority_high_outlined;
    if (normalized.contains('route')) return Icons.route_outlined;
    return Icons.local_hospital_outlined;
  }
}
