class InventoryItemModel {
  final String id;
  final String name;
  final String sku;
  final String category;
  final String description;
  final double price;
  final int stockQuantity;
  final int lowStockThreshold;
  final String unit;
  final String imageUrl;
  final bool isActive;
  final double costPrice;
  final String? supplierName;
  final bool isFeatured;
  final int reorderPoint;

  const InventoryItemModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    this.description = '',
    required this.price,
    required this.stockQuantity,
    this.lowStockThreshold = 10,
    required this.unit,
    this.imageUrl = '',
    this.isActive = true,
    this.costPrice = 0.0,
    this.supplierName,
    this.isFeatured = false,
    this.reorderPoint = 0,
  });

  bool get isLowStock => stockQuantity <= lowStockThreshold && stockQuantity > 0;
  bool get isOutOfStock => stockQuantity == 0;
}
