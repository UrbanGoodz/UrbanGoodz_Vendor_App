import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/inventory_item_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class InventoryController extends GetxController {
  final repository = Get.find<VendorRepository>();
  final items = <InventoryItemModel>[].obs;
  final filteredItems = <InventoryItemModel>[].obs;
  final selectedCategory = 'all'.obs;
  final sortBy = 'name'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  List<InventoryItemModel> get lowStockItems =>
      items.where((item) => item.isLowStock).toList();
  List<InventoryItemModel> get outOfStockItems =>
      items.where((item) => item.isOutOfStock).toList();

  @override
  void onInit() {
    super.onInit();
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final response = await repository.items(search: searchQuery.value);
      final rows = response['items'];
      items.assignAll(
        rows is List
            ? rows.whereType<Map>().map(
                (row) => fromJson(Map<String, dynamic>.from(row)),
              )
            : const <InventoryItemModel>[],
      );
      _applyFilters();
    } on VendorApiException catch (error) {
      items.clear();
      _applyFilters();
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
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
          .where(
            (item) =>
                item.category.toLowerCase() ==
                selectedCategory.value.toLowerCase(),
          )
          .toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result
          .where(
            (item) =>
                item.name.toLowerCase().contains(query) ||
                item.sku.toLowerCase().contains(query),
          )
          .toList();
    }
    if (sortBy.value == 'price') {
      result.sort((a, b) => a.price.compareTo(b.price));
    }
    if (sortBy.value == 'stock') {
      result.sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));
    }
    if (sortBy.value == 'name') {
      result.sort((a, b) => a.name.compareTo(b.name));
    }
    filteredItems.assignAll(result);
  }

  Future<void> updateStock(String id, int quantity) async {
    try {
      await repository.updateStock(id, quantity);
      await fetchInventory();
      Get.snackbar(
        'Stock updated',
        'Inventory quantity saved to the Vendor API.',
      );
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      Get.snackbar('Stock update failed', error.message);
    }
  }

  Future<bool> saveProduct({
    String? id,
    required String name,
    required String description,
    required String categoryId,
    required double price,
    required int stock,
    String? imagePath,
  }) async {
    try {
      await repository.saveProduct(
        id: id,
        name: name,
        description: description,
        categoryId: categoryId,
        price: price,
        stock: stock,
        imagePath: imagePath,
      );
      await fetchInventory();
      Get.snackbar(
        'Product saved',
        'Product data and media were saved to the Vendor API.',
      );
      return true;
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      Get.snackbar('Product save failed', error.message);
      return false;
    }
  }

  static InventoryItemModel fromJson(Map<String, dynamic> json) =>
      InventoryItemModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? 'Unnamed item',
        sku: json['slug']?.toString() ?? 'ITEM-${json['id'] ?? ''}',
        category:
            json['category_name']?.toString() ??
            json['category_id']?.toString() ??
            'Uncategorized',
        description: json['description']?.toString() ?? '',
        price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
        stockQuantity: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
        lowStockThreshold:
            int.tryParse(json['minimum_stock_for_warning']?.toString() ?? '') ??
            10,
        unit: json['unit']?.toString() ?? json['unit_id']?.toString() ?? 'unit',
        imageUrl: json['image_full_url']?.toString() ?? '',
        isActive:
            json['status'] == true ||
            json['status'] == 1 ||
            json['status']?.toString() == '1',
      );
}
