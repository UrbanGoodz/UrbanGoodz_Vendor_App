import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/service_bookings_controller.dart';
import 'package:urban_goodz_vendor/models/service_booking_model.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';
import 'package:urban_goodz_vendor/screens/service_provider_tools_screen.dart';

class ServiceBookingsScreen extends StatelessWidget {
  const ServiceBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceBookingsController c = Get.put(ServiceBookingsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Bookings'),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const ServiceProviderToolsScreen()),
            icon: const Icon(Icons.settings),
          ),
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
    final filters = [
      'all',
      'requested',
      'quoted',
      'accepted',
      'confirmed',
      'en_route',
      'started',
      'completed',
      'declined',
      'canceled',
    ];
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
                  color: selected
                      ? AppTheme.dark
                      : AppTheme.dark.withOpacity(0.7),
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
    return Obx(() {
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (c.errorMessage.value != null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(c.errorMessage.value!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: c.fetchBookings,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      if (c.filteredBookings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 64,
                color: AppTheme.dark.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              Text(
                'No bookings found',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.dark.withOpacity(0.4),
                ),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: c.fetchBookings,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: c.filteredBookings.length,
          itemBuilder: (_, i) =>
              _BookingCard(booking: c.filteredBookings[i], controller: c),
        ),
      );
    });
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
                  child: const Icon(
                    Icons.room_service,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppTheme.dark,
                        ),
                      ),
                      Text(
                        booking.customerName,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.dark.withOpacity(0.6),
                        ),
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
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppTheme.dark.withOpacity(0.5),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_formatDate(booking.bookingDate)} at ${booking.timeSlot}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.dark.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  size: 14,
                  color: AppTheme.dark.withOpacity(0.5),
                ),
                const SizedBox(width: 6),
                Text(
                  '\$${booking.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            if (booking.notes != null && booking.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.notes,
                    size: 14,
                    color: AppTheme.dark.withOpacity(0.5),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      booking.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.dark.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (booking.status == 'requested') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionChip(
                    label: 'Accept fixed price',
                    color: Colors.blue,
                    onTap: () => controller.confirmBooking(booking.id),
                  ),
                  const SizedBox(width: 8),
                  _ActionChip(
                    label: 'Quote',
                    color: AppTheme.primary,
                    onTap: () => _showQuoteDialog(context),
                  ),
                  const SizedBox(width: 8),
                  _ActionChip(
                    label: 'Cancel',
                    color: Colors.red,
                    onTap: () =>
                        controller.cancelBooking(booking.id, 'Cancelled'),
                  ),
                ],
              ),
            ],
            if (booking.status == 'confirmed') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionChip(
                    label: 'En route',
                    color: Colors.blue,
                    onTap: () =>
                        controller.updateStatus(booking.id, 'en_route'),
                  ),
                  const SizedBox(width: 8),
                  _ActionChip(
                    label: 'Cancel',
                    color: Colors.red,
                    onTap: () => controller.cancelBooking(
                      booking.id,
                      'Declined by provider',
                    ),
                  ),
                ],
              ),
            ],
            if (booking.status == 'en_route') ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: _ActionChip(
                  label: 'Start service',
                  color: AppTheme.primary,
                  onTap: () => controller.updateStatus(booking.id, 'started'),
                ),
              ),
            ],
            if (booking.status == 'started') ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: _ActionChip(
                  label: 'Complete',
                  color: Colors.green,
                  onTap: () => controller.completeBooking(booking.id),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  void _showQuoteDialog(BuildContext context) {
    final amount = TextEditingController();
    final deposit = TextEditingController(text: '0');
    final notes = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Submit quote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total amount'),
            ),
            TextField(
              controller: deposit,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Deposit'),
            ),
            TextField(
              controller: notes,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final total = double.tryParse(amount.text);
              final down = double.tryParse(deposit.text) ?? 0;
              if (total == null || total <= 0) {
                Get.snackbar('Invalid quote', 'Enter a valid amount.');
                return;
              }
              controller.submitQuote(
                booking.id,
                total,
                down,
                booking.bookingDate,
                notes.text.trim(),
              );
              Get.back();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
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
      case 'requested':
        bgColor = Colors.orange;
        label = 'Requested';
        break;
      case 'quoted':
        bgColor = Colors.purple;
        label = 'Quoted';
        break;
      case 'accepted':
        bgColor = Colors.blueGrey;
        label = 'Accepted';
        break;
      case 'en_route':
        bgColor = Colors.blue;
        label = 'En route';
        break;
      case 'started':
        bgColor = AppTheme.primary;
        label = 'Started';
        break;
      case 'declined':
        bgColor = Colors.red;
        label = 'Declined';
        break;
      case 'canceled':
        bgColor = Colors.red;
        label = 'Canceled';
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
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: bgColor,
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

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
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
