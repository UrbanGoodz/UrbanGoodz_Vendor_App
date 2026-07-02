import 'package:flutter/material.dart';
import 'package:sixam_mart/features/rental_module/common/widgets/car_rental_preview_widget.dart';

class TripOrderViewWidget extends StatelessWidget {
  final bool isRunning;
  const TripOrderViewWidget({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return const CarRentalPreviewWidget(title: 'Rental Trips');
  }
}
