import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/service_bookings_controller.dart';
import 'package:urban_goodz_vendor/models/service_booking_model.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

class ServiceBookingsScreen extends StatelessWidget {
  const ServiceBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceBookingsController c = Get.put(ServiceBookingsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Bookings'),
        actions: [
          Obx(
            () => Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${c.bookings.length} total',
                  style: const TextStyle(fontSize: 13, color: AppTheme.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(c),
          Expanded(child: _buildBookingsList(c)),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ServiceBookingsController c) {
    final filters = ['all', 'upcoming', 'confirmed', 'completed', 'cancelled'];
    return Obx(
      () => SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: filters.map((f) {
            final selected = c.selectedFilter.value == f;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(f[0].toUpperCase() + f.substring(1)),
                selected: selected,
                onSelected: (_) => c.filterByStatus(f),
                selectedColor: AppTheme.primary,
                checkmarkColor: AppTheme.dark,
                backgroundColor: AppTheme.beige.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: selected ? AppTheme.dark : AppTheme.dark.withOpacity(0.7),
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBookingsList(ServiceBookingsController c) {
    return Obx(
      () {
        if (c.filteredBookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 64, color: AppTheme.dark.withOpacity(0.2)),
                const SizedBox(height: 16),
                Text(
                  'No bookings found',
                  style: TextStyle(fontSize: 16, color: AppTheme.dark.withOpacity(0.4)),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: c.filteredBookings.length,
          itemBuilder: (_, i) => _BookingCard(booking: c.filteredBookings[i], controller: c),
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final ServiceBookingModel booking;
  final ServiceBookingsController controller;

  const _BookingCard({required this.booking, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.room_service, color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceName,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.dark),
                      ),
                      Text(
                        booking.customerName,
                        style: TextStyle(fontSize: 13, color: AppTheme.dark.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppTheme.dark.withOpacity(0.5)),
                const SizedBox(width: 6),
                Text(
                  '${_formatDate(booking.bookingDate)} at ${booking.timeSlot}',
                  style: TextStyle(fontSize: 12, color: AppTheme.dark.withOpacity(0.6)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.attach_money, size: 14, color: AppTheme.dark.withOpacity(0.5)),
                const SizedBox(width: 6),
                Text(
                  '\$${booking.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                ),
              ],
            ),
            if (booking.notes != null && booking.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.notes, size: 14, color: AppTheme.dark.withOpacity(0.5)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      booking.notes!,
                      style: TextStyle(fontSize: 12, color: AppTheme.dark.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
            ],
            if (booking.status == 'upcoming') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionChip(label: 'Confirm', color: Colors.blue, onTap: () => controller.confirmBooking(booking.id)),
                  const SizedBox(width: 8),
                  _ActionChip(label: 'Cancel', color: Colors.red, onTap: () => controller.cancelBooking(booking.id, 'Cancelled')),
                ],
              ),
            ],
            if (booking.status == 'confirmed') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionChip(label: 'Mark Complete', color: Colors.green, onTap: () => controller.completeBooking(booking.id)),
                  const SizedBox(width: 8),
                  _ActionChip(label: 'Cancel', color: Colors.red, onTap: () => controller.cancelBooking(booking.id, 'Cancelled by vendor')),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    String label;
    switch (status) {
      case 'upcoming':
        bgColor = Colors.blue;
        label = 'Upcoming';
        break;
      case 'confirmed':
        bgColor = AppTheme.primary;
        label = 'Confirmed';
        break;
      case 'completed':
        bgColor = Colors.green;
        label = 'Completed';
        break;
      case 'cancelled':
        bgColor = Colors.red;
        label = 'Cancelled';
        break;
      default:
        bgColor = Colors.grey;
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: bgColor),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      ),
    );
  }
}
