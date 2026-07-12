import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/analytics_controller.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AnalyticsController c = Get.put(AnalyticsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
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
            _buildRevenueTrendChart(c),
            const SizedBox(height: 20),
            _buildCategoryPerformance(c),
            const SizedBox(height: 20),
            _buildPeakHoursChart(c),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(AnalyticsController c) {
    return Obx(
      () => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
        children: c.analyticsData.map((a) => _AnalyticsCard(data: a)).toList(),
      ),
    );
  }

  Widget _buildRevenueTrendChart(AnalyticsController c) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Revenue Trend',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.dark),
                ),
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '+${c.revenueGrowth.toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.show_chart, size: 48, color: AppTheme.primary.withOpacity(0.3)),
                    const SizedBox(height: 8),
                    Text(
                      'Revenue chart for ${c.selectedPeriod.value} period',
                      style: TextStyle(color: AppTheme.dark.withOpacity(0.4)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tracking revenue growth at +${c.revenueGrowth.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 12, color: AppTheme.dark.withOpacity(0.3)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPerformance(AnalyticsController c) {
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
              'Category Performance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.dark),
            ),
            const SizedBox(height: 16),
            ...c.categoryBreakdown.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontSize: 13, color: AppTheme.dark)),
                        Text(
                          '${entry.value.toStringAsFixed(1)}%',
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: entry.value / 100,
                        backgroundColor: AppTheme.beige.withOpacity(0.5),
                        color: _categoryColor(entry.key),
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

  Widget _buildPeakHoursChart(AnalyticsController c) {
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
              'Peak Order Hours',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.dark),
            ),
            const SizedBox(height: 16),
            ...c.popularTimeSlots.map((slot) {
              final maxCount = c.popularTimeSlots.fold<int>(0, (max, s) => s.value > max ? s.value : max);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(slot.key, style: TextStyle(fontSize: 11, color: AppTheme.dark.withOpacity(0.7))),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: slot.value / maxCount,
                          backgroundColor: AppTheme.beige.withOpacity(0.5),
                          color: AppTheme.accent,
                          minHeight: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '${slot.value}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.dark),
                        textAlign: TextAlign.right,
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

  Color _categoryColor(String category) {
    final colors = [AppTheme.primary, AppTheme.accent, Colors.blue, Colors.green, Colors.purple, Colors.teal];
    return colors[category.hashCode.abs() % colors.length];
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

class _AnalyticsCard extends StatelessWidget {
  final dynamic data;

  const _AnalyticsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isPositive = data.growthPercentage >= 0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.beige.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.label,
            style: TextStyle(fontSize: 11, color: AppTheme.dark.withOpacity(0.6)),
          ),
          const SizedBox(height: 4),
          Text(
            data.category == 'revenue' ? '\$${data.value.toStringAsFixed(0)}' : data.value.toStringAsFixed(0),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.dark),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: isPositive ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 2),
              Text(
                '${isPositive ? '+' : ''}${data.growthPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
