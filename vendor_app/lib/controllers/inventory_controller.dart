import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/inventory_item_model.dart';
import 'package:urban_goodz_vendor/repositories/mock_vendor_data.dart';

class InventoryController extends GetxController {
  final items = <InventoryItemModel>[].obs;
  final filteredItems = <InventoryItemModel>[].obs;
  final selectedCategory = 'all'.obs;
  final sortBy = 'name'.obs;
  final searchQuery = ''.obs;

  List<InventoryItemModel> get lowStockItems =>
      items.where((i) => i.isLowStock).toList();

  List<InventoryItemModel> get outOfStockItems =>
      items.where((i) => i.isOutOfStock).toList();

  @override
  void onInit() {
    super.onInit();
    fetchInventory();
  }

  void fetchInventory() {
    items.value = MockVendorData.inventory;
    _applyFilters();
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

  void updateStock(String id, int qty) {
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

  void addItem(InventoryItemModel item) {
    items.add(item);
    _applyFilters();
  }
}
