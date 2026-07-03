import 'package:flutter/material.dart';
import 'package:sixam_mart/features/rental_module/common/car_rental_state.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class TripOrderViewWidget extends StatelessWidget {
  final bool isRunning;
  const TripOrderViewWidget({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    final list = CarRentalState.requests;

    // Split requests: running shows "Pending Provider Review", history shows nothing or completed
    final filteredList = isRunning 
        ? list 
        : const <Map<String, dynamic>>[]; // keep history empty for preview initial state

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 14),
            Text(
              isRunning 
                  ? 'Your rental requests will appear here.'
                  : 'No past rental trips found.',
              style: robotoMedium.copyWith(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      itemCount: filteredList.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final r = filteredList[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFED9914).withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_car, color: Color(0xFFED9914), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        r['vehicleName'] ?? '',
                        style: robotoBold.copyWith(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const UrbanGoodzStatusBadge(status: 'Pending Review', isCompact: true),
                ],
              ),
              const SizedBox(height: 12),

              // Route details
              _buildDetailRow(Icons.location_on, 'Location', r['pickupLocation'] ?? ''),
              const SizedBox(height: 6),
              _buildDetailRow(Icons.calendar_today, 'Dates', '${r['pickupDate']} to ${r['returnDate']}'),
              const SizedBox(height: 6),
              _buildDetailRow(Icons.person, 'Renter', '${r['renterName']} (${r['phone']})'),
              if (r['notes'] != null && r['notes'].toString().isNotEmpty) ...[
                const SizedBox(height: 6),
                _buildDetailRow(Icons.chat_bubble_outline, 'Notes', r['notes']),
              ],

              const Divider(color: Colors.white12, height: 20),

              // Total Estimated Cost
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimated Cost',
                    style: robotoRegular.copyWith(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    '\$${(r['total'] as double).toStringAsFixed(2)}',
                    style: robotoBold.copyWith(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_tethering, color: Color(0xFFE5E276), size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tester Preview - Local simulation only',
                        style: robotoMedium.copyWith(
                          color: const Color(0xFFE5E276),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(0xFFE2D3BF)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: robotoBold.copyWith(
            fontSize: 11,
            color: const Color(0xFFE2D3BF),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: robotoRegular.copyWith(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
