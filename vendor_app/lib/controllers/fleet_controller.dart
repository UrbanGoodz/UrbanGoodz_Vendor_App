import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/fleet_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

/// The vendor's own delivery fleet: who their drivers are, what each is
/// doing, and assigning/releasing them on the vendor's orders.
class FleetController extends GetxController {
  final repository = Get.find<VendorRepository>();

  final drivers = <FleetDriver>[].obs;
  final summary = const FleetSummary().obs;
  final isLoading = false.obs;
  final isBusy = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    refreshFleet();
  }

  Future<void> refreshFleet() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final results = await Future.wait([
        repository.fleetDrivers(),
        repository.fleetSummary(),
      ]);
      drivers.assignAll(
        (results[0] as List<Map<String, dynamic>>).map(FleetDriver.fromJson),
      );
      summary.value = FleetSummary.fromJson(
        results[1] as Map<String, dynamic>,
      );
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<AssignableOrder>> loadAssignableOrders() async {
    final rows = await repository.assignableOrders();
    return rows.map(AssignableOrder.fromJson).toList();
  }

  Future<bool> assign(FleetDriver driver, AssignableOrder order) =>
      _run(
        () => repository.assignFleetDriver(driver.id, order.id),
        success: '${driver.name} is on order #${order.id}.',
        failure: 'Could not assign driver',
      );

  Future<bool> release(FleetDriver driver) {
    final orderId = driver.activeOrderId;
    if (orderId == null) return Future.value(false);
    return _run(
      () => repository.releaseFleetDriver(driver.id, orderId),
      success: '${driver.name} was released from order #$orderId.',
      failure: 'Could not release driver',
    );
  }

  Future<bool> addDriver({
    required String fName,
    String? lName,
    required String phone,
    String? email,
    required String password,
  }) => _run(
    () => repository.addFleetDriver(
      fName: fName,
      lName: lName,
      phone: phone,
      email: email,
      password: password,
    ),
    success: 'Driver added. Urban Goodz will review them before they can drive.',
    failure: 'Could not add driver',
  );

  Future<bool> _run(
    Future<void> Function() action, {
    required String success,
    required String failure,
  }) async {
    if (isBusy.value) return false;
    isBusy.value = true;
    try {
      await action();
      Get.snackbar('Fleet updated', success);
      await refreshFleet();
      return true;
    } on VendorApiException catch (error) {
      Get.snackbar(failure, error.message);
      return false;
    } finally {
      isBusy.value = false;
    }
  }
}
