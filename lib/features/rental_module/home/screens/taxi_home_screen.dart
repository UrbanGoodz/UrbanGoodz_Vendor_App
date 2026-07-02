import 'package:flutter/material.dart';
import 'package:sixam_mart/features/rental_module/common/widgets/car_rental_preview_widget.dart';

class TaxiHomeScreen extends StatefulWidget {
  const TaxiHomeScreen({super.key});

  @override
  State<TaxiHomeScreen> createState() => _TaxiHomeScreenState();
}

class _TaxiHomeScreenState extends State<TaxiHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return const CarRentalPreviewWidget(title: 'Car Rental Hub');
  }
}




