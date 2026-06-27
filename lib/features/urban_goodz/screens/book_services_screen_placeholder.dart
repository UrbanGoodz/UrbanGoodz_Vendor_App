import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

class BookServicesScreen extends StatelessWidget {
  const BookServicesScreen({super.key});

  static const List<String> _services = [
    'Barber',
    'Hair Stylist',
    'Braider',
    'Nail Tech',
    'Makeup Artist',
    'Mobile Mechanic',
    'Photographer',
    'DJ',
    'Contractor',
    'Tax Professional',
    'Home Health Provider',
    'Personal Trainer',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text(
          'Book Services',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppConstants.ugBlack,
          ),
        ),
      ),
      body: Column(
        children: [
          const _PreviewBanner(
            message: 'Preview - service provider booking is not yet available.',
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _services.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _ServiceRow(title: _services[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewBanner extends StatelessWidget {
  final String message;

  const _PreviewBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppConstants.seasoningOrange.withValues(alpha: 0.14),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 18,
            color: AppConstants.seasoningOrange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstants.ugBlack,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final String title;

  const _ServiceRow({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.ugWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppConstants.ugBlack.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_available_outlined,
            color: AppConstants.seasoningOrange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppConstants.ugBlack,
              ),
            ),
          ),
          const Text(
            'Coming soon',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A4037),
            ),
          ),
        ],
      ),
    );
  }
}
