import 'package:flutter/material.dart';

/// Minimal badge widgets for Urban Goodz store screen.
/// These are lightweight placeholders to satisfy analyzer/build during tester mode.
/// Replace with branded widgets or real implementations as needed.

class UrbanGoodzPartnerBadge extends StatelessWidget {
  final double? size;
  const UrbanGoodzPartnerBadge({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Urban Goodz Partner',
        style: TextStyle(color: Colors.white, fontSize: size ?? 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class ClaimedBusinessBadge extends StatelessWidget {
  final double? size;
  const ClaimedBusinessBadge({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Claimed Business',
        style: TextStyle(color: Colors.white, fontSize: size ?? 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class PublicListingBadge extends StatelessWidget {
  final double? size;
  const PublicListingBadge({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Public Listing',
        style: TextStyle(color: Colors.white, fontSize: size ?? 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class OrderAnywhereAvailableBadge extends StatelessWidget {
  final double? size;
  const OrderAnywhereAvailableBadge({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Order Anywhere Available',
        style: TextStyle(color: Colors.white, fontSize: size ?? 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
