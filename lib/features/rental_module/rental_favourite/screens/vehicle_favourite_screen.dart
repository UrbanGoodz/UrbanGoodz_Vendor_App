import 'package:flutter/material.dart';
import 'package:sixam_mart/features/rental_module/common/widgets/car_rental_preview_widget.dart';

class VehicleFavouriteScreen extends StatefulWidget {
  const VehicleFavouriteScreen({super.key});

  @override
  VehicleFavouriteScreenState createState() => VehicleFavouriteScreenState();
}

class VehicleFavouriteScreenState extends State<VehicleFavouriteScreen> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return const CarRentalPreviewWidget(title: 'Rental Wishlist');
  }
}
