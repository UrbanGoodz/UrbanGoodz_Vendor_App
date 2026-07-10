import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/revenue_tracking_controller.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

class RevenueTrackingScreen extends StatelessWidget {
  const RevenueTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RevenueTrackingController c = Get.put(RevenueTrackingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Tracking'),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _PeriodSelector(
                selected: c.selectedPeriod.value,
                onChanged: (p) => c.changePeriod(p),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(c),
            const SizedBox(height: 20),
            _buildRevenueBySource(c),
            const SizedBox(height: 20),
            _buildTransactionList(c),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPayoutDialog(context, c),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.payments, color: AppTheme.dark),
        label: const Text('Request Payout', style: TextStyle(color: AppTheme.dark)),
      ),
    );
  }

  Widget _buildSummaryCards(RevenueTrackingController c) {
    return Obx(
      () => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
        children: [
          _buildSummaryCard('Total Revenue', '\$${c.totalRevenue.toStringAsFixed(0)}', Icons.account_balance, AppTheme.primary),
          _buildSummaryCard('Pending Payout', '\$${c.pendingPayout.toStringAsFixed(0)}', Icons.hourglass_empty, Colors.orange),
          _buildSummaryCard('Available', '\$${c.availableForPayout.toStringAsFixed(0)}', Icons.check_circle, Colors.green),
          _buildSummaryCard('Total Paid Out', '\$${c.totalPayouts.toStringAsFixed(0)}', Icons.payments, AppTheme.accent),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.beige.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11, color: AppTheme.dark.withOpacity(0.6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBySource(RevenueTrackingController c) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.beige.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue by Source',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.dark),
            ),
            const SizedBox(height: 16),
            ...c.revenueBySource.entries.map((entry) {
              final total = c.revenueBySource.values.fold<double>(0, (a, b) => a + b);
              final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontSize: 13, color: AppTheme.dark)),
                        Row(
                          children: [
                            Text(
                              '\$${entry.value.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.dark),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${percentage.toStringAsFixed(1)}%)',
                              style: TextStyle(fontSize: 12, color: AppTheme.dark.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: AppTheme.beige.withOpacity(0.5),
                        color: AppTheme.primary,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(RevenueTrackingController c) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.dark),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All', style: TextStyle(color: AppTheme.primary, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (c.filteredEntries.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.receipt, size: 48, color: AppTheme.dark.withOpacity(0.2)),
                    const SizedBox(height: 8),
                    Text(
                      'No transactions in this period',
                      style: TextStyle(color: AppTheme.dark.withOpacity(0.4)),
                    ),
                  ],
                ),
              ),
            )
          else
            ...c.filteredEntries.map((entry) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.beige.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _sourceColor(entry.source).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          entry.source == 'Payout' ? Icons.payments : Icons.receipt,
                          color: _sourceColor(entry.source),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.source,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.dark),
                            ),
                            Text(
                              entry.description,
                              style: TextStyle(fontSize: 11, color: AppTheme.dark.withOpacity(0.5)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${entry.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: entry.source == 'Payout' ? Colors.red : Colors.green,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          _StatusBadge(status: entry.status),
                        ],
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Color _sourceColor(String source) {
    switch (source) {
      case 'Order Revenue':
        return AppTheme.primary;
      case 'Service Booking':
        return Colors.blue;
      case 'Payout':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showPayoutDialog(BuildContext context, RevenueTrackingController c) {
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Payout', style: TextStyle(color: AppTheme.dark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Text(
                'Available for payout: \$${c.availableForPayout.toStringAsFixed(2)}',
                style: TextStyle(color: AppTheme.dark.withOpacity(0.6), fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: '0.00',
                prefixText: '\$ ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountCtrl.text);
              if (amount != null && amount > 0) {
                c.requestPayout(amount);
                Get.back();
              }
            },
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PeriodSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: ['7d', '30d', '90d'].map((p) {
        final isSelected = selected == p;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: InkWell(
            onTap: () => onChanged(p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                p,
                style: TextStyle(
                  color: isSelected ? AppTheme.dark : AppTheme.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
      case 'settled':
        bgColor = Colors.green;
        label = 'Settled';
        break;
      case 'pending':
        bgColor = Colors.orange;
        label = 'Pending';
        break;
      case 'completed':
        bgColor = Colors.blue;
        label = 'Completed';
        break;
      default:
        bgColor = Colors.grey;
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: bgColor),
      ),
    );
  }
}
