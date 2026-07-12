import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/vendor_store_model.dart';
import 'package:urban_goodz_vendor/models/vendor_order_model.dart';
import 'package:urban_goodz_vendor/models/inventory_item_model.dart';
import 'package:urban_goodz_vendor/repositories/mock_vendor_data.dart';

class DashboardController extends GetxController {
  final store = Rx<VendorStoreModel?>(null);
  final todayRevenue = 0.0.obs;
  final weeklyRevenue = 0.0.obs;
  final monthlyRevenue = 0.0.obs;
  final totalOrders = 0.obs;
  final activeOrders = 0.obs;
  final pendingBookings = 0.obs;
  final averageRating = 0.0.obs;
  final lowStockItems = 0.obs;
  final recentOrders = <VendorOrderModel>[].obs;
  final topProducts = <InventoryItemModel>[].obs;
  final revenueChart = <double>[].obs;
  final storeStatus = 'open'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  void fetchDashboard() {
    store.value = MockVendorData.store;
    storeStatus.value = MockVendorData.store.isOpen ? 'open' : 'closed';

    final orders = MockVendorData.orders;
    todayRevenue.value = orders
        .where((o) =>
            o.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .fold<double>(0, (sum, o) => sum + o.total);
    weeklyRevenue.value = orders
        .where((o) =>
            o.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .fold<double>(0, (sum, o) => sum + o.total);
    monthlyRevenue.value = orders
        .where((o) =>
            o.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 30))))
        .fold<double>(0, (sum, o) => sum + o.total);
    totalOrders.value = orders.length;
    activeOrders.value =
        orders.where((o) => !['completed', 'cancelled'].contains(o.status)).length;
    pendingBookings.value = MockVendorData.serviceBookings
        .where((b) => b.status == 'upcoming')
        .length;
    averageRating.value = MockVendorData.store.rating;
    lowStockItems.value =
        MockVendorData.inventory.where((i) => i.isLowStock || i.isOutOfStock).length;
    recentOrders.value = orders.take(5).toList();
    topProducts.value = MockVendorData.inventory
        .where((i) => i.isActive)
        .take(5)
        .toList();
    revenueChart.value = MockVendorData.revenueChartData;
  }

  void toggleStoreStatus() {
    storeStatus.value = storeStatus.value == 'open' ? 'closed' : 'open';
  }

  void refresh() {
    fetchDashboard();
  }
}
