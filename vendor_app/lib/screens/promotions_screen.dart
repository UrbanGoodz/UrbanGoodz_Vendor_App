import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/promotions_controller.dart';
import 'package:urban_goodz_vendor/models/promotion_model.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PromotionsController c = Get.put(PromotionsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
        actions: [
          Obx(
            () => Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${c.promotions.length} promos',
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
          Expanded(child: _buildPromotionsList(c)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePromotionDialog(context, c),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.dark),
      ),
    );
  }

  Widget _buildFilterChips(PromotionsController c) {
    final filters = ['all', 'active', 'scheduled', 'expired'];
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
                onSelected: (_) => c.filterPromotions(f),
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

  Widget _buildPromotionsList(PromotionsController c) {
    return Obx(() {
      if (c.filteredPromotions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_offer,
                size: 64,
                color: AppTheme.dark.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              Text(
                'No promotions found',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.dark.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap + to create your first promotion',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.dark.withOpacity(0.3),
                ),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: c.filteredPromotions.length,
        itemBuilder: (_, i) =>
            _PromotionCard(promotion: c.filteredPromotions[i], controller: c),
      );
    });
  }

  void _showCreatePromotionDialog(
    BuildContext context,
    PromotionsController c,
  ) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final discountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Create Promotion',
          style: TextStyle(color: AppTheme.dark),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. Summer Harvest Sale',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your promotion',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Promo Code',
                  hintText: 'e.g. SUMMER20',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: discountCtrl,
                decoration: const InputDecoration(
                  labelText: 'Discount %',
                  hintText: 'e.g. 20',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                c.createPromotion(
                  PromotionModel(
                    id: 'PROMO-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text,
                    description: descCtrl.text,
                    discountType: 'percentage',
                    discountValue: double.tryParse(discountCtrl.text) ?? 0,
                    code: codeCtrl.text.isEmpty ? null : codeCtrl.text,
                    startDate: DateTime.now(),
                    endDate: DateTime.now().add(const Duration(days: 30)),
                    usageLimit: 100,
                    usageCount: 0,
                    isActive: true,
                    imageUrl: '',
                  ),
                );
                Get.back();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _PromotionCard extends StatelessWidget {
  final PromotionModel promotion;
  final PromotionsController controller;

  const _PromotionCard({required this.promotion, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isActive =
        promotion.isActive && promotion.endDate.isAfter(DateTime.now());
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
                    color: (isActive ? AppTheme.primary : Colors.grey)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_offer,
                    color: isActive ? AppTheme.primary : Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promotion.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppTheme.dark,
                        ),
                      ),
                      Text(
                        promotion.code ?? 'No code required',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Switch(
                    value: promotion.isActive,
                    onChanged: (_) => controller.toggleActive(promotion.id),
                    activeColor: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              promotion.description,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.dark.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  Icons.percent,
                  promotion.discountType == 'percentage'
                      ? '${promotion.discountValue.toInt()}% OFF'
                      : '\$${promotion.discountValue.toStringAsFixed(0)} OFF',
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  Icons.date_range,
                  '${_formatDate(promotion.startDate)} - ${_formatDate(promotion.endDate)}',
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  Icons.people,
                  '${promotion.usageCount}/${promotion.usageLimit} used',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => controller.deletePromotion(promotion.id),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.beige.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.dark.withOpacity(0.5)),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.dark.withOpacity(0.7),
            ),
          ),
        ],
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
    return '${months[dt.month - 1]} ${dt.day}';
  }
}
