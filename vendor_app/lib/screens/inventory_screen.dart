import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/inventory_controller.dart';
import 'package:urban_goodz_vendor/models/inventory_item_model.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InventoryController c = Get.put(InventoryController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          Obx(
            () => Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${c.items.length} items',
                  style: const TextStyle(fontSize: 13, color: AppTheme.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndSort(c),
          _buildCategoryChips(c),
          Obx(() {
            if (c.lowStockItems.isNotEmpty) {
              return _buildWarningSection('Low Stock', c.lowStockItems, c);
            }
            return const SizedBox.shrink();
          }),
          Obx(() {
            if (c.outOfStockItems.isNotEmpty) {
              return _buildWarningSection('Out of Stock', c.outOfStockItems, c);
            }
            return const SizedBox.shrink();
          }),
          Expanded(child: _buildInventoryList(context, c)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, c),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.dark),
      ),
    );
  }

  Widget _buildSearchAndSort(InventoryController c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => c.searchItems(v),
              decoration: InputDecoration(
                hintText: 'Search inventory...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.dark,
                  size: 20,
                ),
                filled: true,
                fillColor: AppTheme.beige.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => PopupMenuButton<String>(
              icon: const Icon(Icons.sort, color: AppTheme.dark),
              onSelected: (v) => c.sortItems(v),
              itemBuilder: (_) => [
                CheckedPopupMenuItem(
                  value: 'name',
                  checked: c.sortBy.value == 'name',
                  child: const Text('Sort by Name'),
                ),
                CheckedPopupMenuItem(
                  value: 'price',
                  checked: c.sortBy.value == 'price',
                  child: const Text('Sort by Price'),
                ),
                CheckedPopupMenuItem(
                  value: 'stock',
                  checked: c.sortBy.value == 'stock',
                  child: const Text('Sort by Stock'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(InventoryController c) {
    final categories = [
      'all',
      'Produce',
      'Bakery',
      'Meat',
      'Meal Kits',
      'Beverages',
      'Condiments',
      'Dairy',
      'Pantry',
    ];
    return Obx(
      () => SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: categories.map((cat) {
            final selected =
                c.selectedCategory.value.toLowerCase() == cat.toLowerCase();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(cat[0].toUpperCase() + cat.substring(1)),
                selected: selected,
                onSelected: (_) => c.filterByCategory(cat),
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

  Widget _buildWarningSection(
    String title,
    List<InventoryItemModel> items,
    InventoryController c,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: title == 'Out of Stock'
            ? Colors.red.withOpacity(0.08)
            : AppTheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: title == 'Out of Stock'
              ? Colors.red.withOpacity(0.3)
              : AppTheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                title == 'Out of Stock'
                    ? Icons.error_outline
                    : Icons.warning_amber,
                size: 16,
                color: title == 'Out of Stock' ? Colors.red : AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                '$title (${items.length})',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: title == 'Out of Stock' ? Colors.red : AppTheme.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...items.map(
            (item) => Text(
              '${item.name} - ${item.stockQuantity} ${item.unit}',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.dark.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(BuildContext context, InventoryController c) {
    return Obx(() {
      if (c.filteredItems.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2,
                size: 64,
                color: AppTheme.dark.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              Text(
                'No items found',
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
        itemCount: c.filteredItems.length,
        itemBuilder: (_, i) => _InventoryCard(
          item: c.filteredItems[i],
          controller: c,
          onEdit: () =>
              _showProductDialog(context, c, item: c.filteredItems[i]),
        ),
      );
    });
  }

  void _showAddItemDialog(BuildContext context, InventoryController c) =>
      _showProductDialog(context, c);

  void _showProductDialog(
    BuildContext context,
    InventoryController c, {
    InventoryItemModel? item,
  }) {
    final nameCtrl = TextEditingController(text: item?.name);
    final descriptionCtrl = TextEditingController(text: item?.description);
    final categoryCtrl = TextEditingController(
      text: item == null ? '' : item.category,
    );
    final priceCtrl = TextEditingController(text: item?.price.toString());
    final stockCtrl = TextEditingController(
      text: item?.stockQuantity.toString(),
    );
    XFile? image;
    final picker = ImagePicker();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(
            item == null ? 'Add Product' : 'Edit Product',
            style: TextStyle(color: AppTheme.dark),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g. Organic Avocados',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: categoryCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Category ID'),
                ),
                TextField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'e.g. 5.99',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: stockCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Stock Qty',
                    hintText: 'e.g. 50',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(
                    image?.name ??
                        (item == null
                            ? 'Select product image'
                            : 'Replace product image (optional)'),
                  ),
                  onTap: () async {
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) setLocal(() => image = picked);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final price = double.tryParse(priceCtrl.text);
                final stock = int.tryParse(stockCtrl.text);
                final category = int.tryParse(categoryCtrl.text);
                if (nameCtrl.text.trim().isEmpty ||
                    price == null ||
                    stock == null ||
                    category == null ||
                    (item == null && image == null)) {
                  Get.snackbar(
                    'Missing information',
                    'Name, numeric category ID, price, stock, and a new-product image are required.',
                  );
                  return;
                }
                final saved = await c.saveProduct(
                  id: item?.id,
                  name: nameCtrl.text.trim(),
                  description: descriptionCtrl.text.trim(),
                  categoryId: category.toString(),
                  price: price,
                  stock: stock,
                  imagePath: image?.path,
                );
                if (saved) Get.back();
              },
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final InventoryItemModel item;
  final InventoryController controller;
  final VoidCallback onEdit;

  const _InventoryCard({
    required this.item,
    required this.controller,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showEditStockDialog(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.beige.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: AppTheme.primary.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.dark,
                      ),
                    ),
                    Text(
                      'SKU: ${item.sku}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.dark.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.stockQuantity} ${item.unit}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: item.isOutOfStock
                          ? Colors.red
                          : item.isLowStock
                          ? AppTheme.primary
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditStockDialog(BuildContext context) {
    final qtyCtrl = TextEditingController(text: item.stockQuantity.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Update Stock - ${item.name}',
          style: const TextStyle(color: AppTheme.dark),
        ),
        content: TextField(
          controller: qtyCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantity',
            hintText: 'Enter new stock quantity',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(qtyCtrl.text);
              if (qty != null) {
                controller.updateStock(item.id, qty);
                Get.back();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
