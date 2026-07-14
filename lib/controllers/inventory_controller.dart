import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/inventory_item_model.dart';
import 'package:urban_goodz_vendor/repositories/api_client.dart';
import 'package:urban_goodz_vendor/controllers/vendor_auth_controller.dart';

class InventoryController extends GetxController {
  final items = <InventoryItemModel>[].obs;
  final filteredItems = <InventoryItemModel>[].obs;
  final selectedCategory = 'all'.obs;
  final sortBy = 'name'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  List<InventoryItemModel> get lowStockItems =>
      items.where((i) => i.isLowStock).toList();

  List<InventoryItemModel> get outOfStockItems =>
      items.where((i) => i.isOutOfStock).toList();

  @override
  void onInit() {
    super.onInit();
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    final auth = Get.find<VendorAuthController>();
    if (auth.token.isEmpty) {
      items.value = [];
      _applyFilters();
      return;
    }

    isLoading.value = true;
    try {
      final client = Get.find<ApiClient>();
      final response = await client.get('/vendor/get-items-list?limit=100');
      
      if (response.status.isOk && response.body != null) {
        final rawData = response.body;
        final List<dynamic> itemsList = rawData['items'] is List ? rawData['items'] : [];
        
        final mapped = itemsList.map((json) {
          final priceVal = double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0;
          final stockVal = int.tryParse(json['stock']?.toString() ?? '0') ?? 0;
          final lowStock = int.tryParse(json['low_stock_limit']?.toString() ?? '10') ?? 10;
          
          return InventoryItemModel(
            id: json['id']?.toString() ?? '',
            name: json['name'] ?? '',
            sku: json['sku'] ?? '',
            category: json['category_id']?.toString() ?? 'General',
            description: json['description'] ?? '',
            price: priceVal,
            stockQuantity: stockVal,
            lowStockThreshold: lowStock,
            unit: json['unit_type'] ?? 'pcs',
            imageUrl: json['image'] ?? '',
            isActive: json['status'] == 1,
          );
        }).toList();

        items.value = mapped;
        _applyFilters();
        isLoading.value = false;
        return;
      }
    } catch (e) {
      debugPrint('Error fetching inventory list: $e');
    }
    
    // Offline preview fallback
    items.value = [];
    _applyFilters();
    isLoading.value = false;
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void sortItems(String by) {
    sortBy.value = by;
    _applyFilters();
  }

  void searchItems(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var result = List<InventoryItemModel>.from(items);

    if (selectedCategory.value != 'all') {
      result = result
          .where((i) =>
              i.category.toLowerCase() == selectedCategory.value.toLowerCase())
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result
          .where((i) =>
              i.name.toLowerCase().contains(query) ||
              i.sku.toLowerCase().contains(query))
          .toList();
    }

    switch (sortBy.value) {
      case 'price':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'stock':
        result.sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));
        break;
      case 'name':
      default:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    filteredItems.value = result;
  }

  Future<void> updateStock(String id, int qty) async {
    try {
      final client = Get.find<ApiClient>();
      final response = await client.put('/vendor/item/stock-update', {
        'product_id': int.tryParse(id) ?? 0,
        'current_stock': qty,
      });

      if (response.status.isOk) {
        Get.snackbar(
          'Stock Updated',
          'Successfully synced new stock ($qty) to database.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
        );
        await fetchInventory();
      } else {
        Get.snackbar(
          'Update Failed',
          'Could not update stock on backend.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Error updating stock: $e');
      Get.snackbar(
        'Offline Mode',
        'Staged stock change locally.',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Offline fallback
      final index = items.indexWhere((i) => i.id == id);
      if (index != -1) {
        final item = items[index];
        final updated = InventoryItemModel(
          id: item.id,
          name: item.name,
          sku: item.sku,
          category: item.category,
          description: item.description,
          price: item.price,
          stockQuantity: qty,
          lowStockThreshold: item.lowStockThreshold,
          unit: item.unit,
          imageUrl: item.imageUrl,
          isActive: item.isActive,
        );
        items[index] = updated;
        _applyFilters();
      }
    }
  }

  Future<void> addItem(InventoryItemModel item) async {
    try {
      final client = Get.find<ApiClient>();
      final response = await client.post('/vendor/item/store', {
        'name': item.name,
        'price': item.price,
        'sku': item.sku,
        'category_id': item.category,
        'stock': item.stockQuantity,
        'unit_type': item.unit,
        'description': item.description,
        'status': item.isActive ? 1 : 0,
      });

      if (response.status.isOk) {
        Get.snackbar(
          'Item Added',
          '${item.name} has been added to catalog database.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
        );
        await fetchInventory();
      }
    } catch (e) {
      debugPrint('Error adding item: $e');
      // Local fallback
      items.add(item);
      _applyFilters();
    }
  }
}
