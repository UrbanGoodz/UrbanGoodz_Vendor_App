import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

class BookServicesScreen extends StatelessWidget {
  const BookServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Services')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppConstants.seasoningOrange.withValues(alpha: 0.12),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppConstants.seasoningOrange),
                SizedBox(width: 8),
                Expanded(child: Text('Preview — service provider booking is not yet available.', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                ListTile(title: Text('Barber')),
                ListTile(title: Text('Hair Stylist')),
                ListTile(title: Text('Braider')),
                ListTile(title: Text('Nail Tech')),
                ListTile(title: Text('Makeup Artist')),
                ListTile(title: Text('Mobile Mechanic')),
                ListTile(title: Text('Photographer')),
                ListTile(title: Text('DJ')),
                ListTile(title: Text('Contractor')),
                ListTile(title: Text('Tax Professional')),
                ListTile(title: Text('Home Health Provider')),
                ListTile(title: Text('Personal Trainer')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}