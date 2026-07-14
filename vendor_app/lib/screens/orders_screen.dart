import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/orders_controller.dart';
import 'package:urban_goodz_vendor/controllers/vendor_auth_controller.dart';
import 'package:urban_goodz_vendor/models/vendor_order_model.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController c = Get.put(OrdersController());
    final VendorAuthController auth = Get.find<VendorAuthController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders & Quotes'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Store Orders'),
              Tab(text: 'Fashion Fit Sizing'),
            ],
            labelColor: AppTheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primary,
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Regular Store Orders
            Column(
              children: [
                _buildSearchBar(c),
                _buildFilterChips(c),
                Expanded(child: _buildOrdersList(c)),
              ],
            ),
            // Tab 2: Fashion Fit Sizing Quote Requests
            _buildFashionFitList(auth, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(OrdersController c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        onChanged: (v) => c.searchOrders(v),
        decoration: InputDecoration(
          hintText: 'Search orders by name or ID...',
          prefixIcon: const Icon(Icons.search, color: AppTheme.dark),
          filled: true,
          fillColor: AppTheme.beige.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(OrdersController c) {
    final statuses = [
      'all',
      'pending',
      'confirmed',
      'preparing',
      'ready',
      'completed',
      'cancelled',
    ];
    return Obx(
      () => SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: statuses.map((s) {
            final selected = c.selectedFilter.value == s;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(s[0].toUpperCase() + s.substring(1)),
                selected: selected,
                onSelected: (_) => c.filterByStatus(s),
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

  Widget _buildOrdersList(OrdersController c) {
    return Obx(() {
      if (c.filteredOrders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                size: 64,
                color: AppTheme.dark.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              Text(
                'No orders found',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.dark.withOpacity(0.4),
                ),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: c.filteredOrders.length,
        itemBuilder: (_, i) =>
            _OrderCard(order: c.filteredOrders[i], controller: c),
      );
    });
  }

  Widget _buildFashionFitList(VendorAuthController auth, BuildContext context) {
    return Obx(() {
      if (auth.sizingQuoteRequests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.checkroom,
                size: 64,
                color: AppTheme.dark.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              Text(
                'No Fashion Fit requests',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.dark.withOpacity(0.4),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: auth.sizingQuoteRequests.length,
        itemBuilder: (context, index) {
          final req = auth.sizingQuoteRequests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(
                req.customerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.dark,
                ),
              ),
              subtitle: Text(
                'Sizing Code: ${req.id} • ${req.requestType}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.dark.withOpacity(0.6),
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: req.status == 'pending'
                      ? Colors.orange.withOpacity(0.15)
                       : AppTheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  req.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: req.status == 'pending'
                        ? Colors.orange
                        : AppTheme.primary,
                  ),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Customer Sizing Profile:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppTheme.dark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Chest Size: ${req.chestSize}'),
                          Text('Waist Size: ${req.waistSize}'),
                          Text('Inseam: ${req.inseam}'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Gender: ${req.gender}'),
                      Text('Phone: ${req.customerPhone}'),
                      if (req.status == 'quoted') ...[
                        const Divider(),
                        Text(
                          'Vendor Review Fee: \$${req.quoteAmount?.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        if (req.notes != null) Text('Notes: ${req.notes}'),
                        if (req.estCompletion != null)
                          Text('Est. Completion: ${req.estCompletion}'),
                      ],
                      if (req.status == 'pending') ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.dark,
                          ),
                          onPressed: () =>
                              _showQuoteSubmissionDialog(req, auth, context),
                          child: const Text('SUBMIT ALTERATION QUOTE'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _showQuoteSubmissionDialog(
    FashionFitQuoteRequest request,
    VendorAuthController auth,
    BuildContext context,
  ) {
    final amountController = TextEditingController(text: '45.00');
    final notesController = TextEditingController();
    final timeController = TextEditingController(text: '3 Days');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quote alteration for ${request.customerName}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Vendor Review Fee (\$)',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Est. Completion Time',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Tailoring / Material Notes',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.dark,
            ),
            onPressed: () async {
              final amt = double.tryParse(amountController.text) ?? 0.0;
              final notes = notesController.text;
              final ok = await auth.submitFashionReview(
                request,
                amt,
                notes.isEmpty
                    ? null
                    : '$notes Estimated completion: ${timeController.text}',
              );
              if (!context.mounted) return;
              Navigator.pop(context);
              Get.snackbar(
                ok ? 'Review Submitted' : 'Review Failed',
                ok
                    ? 'The Fashion Fit review was saved to the Vendor API.'
                    : (auth.errorMessage.value ??
                          'The backend rejected this review.'),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: ok ? AppTheme.primary : Colors.red,
                colorText: Colors.white,
              );
            },
            child: const Text('SUBMIT QUOTE'),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final VendorOrderModel order;
  final OrdersController controller;

  const _OrderCard({required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppTheme.dark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.itemCount} items • \$${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.dark.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            _StatusBadge(status: order.status),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            _timeAgo(order.createdAt),
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.dark.withOpacity(0.5),
            ),
          ),
        ),
        children: [
          const Divider(),
          _buildDetailRow('Order ID', order.id),
          _buildDetailRow('Phone', order.customerPhone),
          _buildDetailRow('Address', order.customerAddress),
          _buildDetailRow(
            'Payment',
            '${order.paymentMethod} - ${order.paymentStatus}',
          ),
          if (order.driverName != null)
            _buildDetailRow('Driver', order.driverName!),
          if (order.notes != null) _buildDetailRow('Notes', order.notes!),
          const SizedBox(height: 8),
          const Divider(),
          const Text(
            'Items',
            style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.dark),
          ),
          const SizedBox(height: 4),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.dark,
                      ),
                    ),
                  ),
                  Text(
                    'x${item.quantity}',
                    style: const TextStyle(fontSize: 13, color: AppTheme.dark),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 13, color: AppTheme.dark),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.dark,
                ),
              ),
              if (order.status == 'pending')
                _ActionChip(
                  label: 'Confirm',
                  color: AppTheme.accent,
                  onTap: () =>
                      controller.updateOrderStatus(order.id, 'confirmed'),
                ),
              if (order.status == 'confirmed')
                _ActionChip(
                  label: 'Start Prep',
                  color: AppTheme.primary,
                  onTap: () =>
                      controller.updateOrderStatus(order.id, 'preparing'),
                ),
              if (order.status == 'preparing')
                _ActionChip(
                  label: 'Mark Ready',
                  color: AppTheme.accent,
                  onTap: () => controller.updateOrderStatus(order.id, 'ready'),
                ),
              if (order.status == 'ready')
                _ActionChip(
                  label: 'Complete',
                  color: AppTheme.primary,
                  onTap: () =>
                      controller.updateOrderStatus(order.id, 'completed'),
                ),
              if (!['completed', 'cancelled'].contains(order.status))
                _ActionChip(
                  label: 'Cancel',
                  color: Colors.red,
                  onTap: () =>
                      controller.updateOrderStatus(order.id, 'cancelled'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.dark.withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: AppTheme.dark),
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
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
      case 'pending':
        bgColor = Colors.orange;
        label = 'Pending';
        break;
      case 'confirmed':
        bgColor = AppTheme.accent;
        label = 'Confirmed';
        break;
      case 'preparing':
        bgColor = AppTheme.primary;
        label = 'Preparing';
        break;
      case 'ready':
        bgColor = AppTheme.accent;
        label = 'Ready';
        break;
      case 'completed':
        bgColor = AppTheme.primary;
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
