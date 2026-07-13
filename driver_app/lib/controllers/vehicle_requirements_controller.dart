import 'package:get/get.dart';
import 'package:urban_goodz_driver/models/vehicle_model.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';

class VehicleRequirementsController extends GetxController {
  DriverApiService get _api => Get.find<DriverApiService>();

  var vehicles = <VehicleModel>[].obs;
  var selectedVehicle = Rx<VehicleModel?>(null);
  var requirementChecklist = <String, bool>{}.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchVehicles();
    super.onInit();
  }

  void fetchVehicles() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final rawVehicles = await _api.getVehicles();
      final items = rawVehicles.map((e) => VehicleModel.fromJson(e)).toList();
      vehicles.value = items;
      if (items.isNotEmpty) {
        selectedVehicle.value = items.first;
        buildChecklist(items.first);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void selectVehicle(String id) {
    final v = vehicles.firstWhere((veh) => veh.id == id);
    selectedVehicle.value = v;
    buildChecklist(v);
  }

  void buildChecklist(VehicleModel vehicle) {
    requirementChecklist.value = {
      'Insurance': vehicle.isInsured,
      'Registration': vehicle.isRegistered,
      'Vehicle Inspection': vehicle.certifications
          .any((c) => c.contains('Inspection')),
      'Emissions Test':
          vehicle.certifications.any((c) => c.contains('Emissions')),
      'Cargo Restraint': vehicle.certifications
          .any((c) => c.contains('Cargo Restraint')),
    };
  }

  void checkRequirement(String key) {
    if (requirementChecklist.containsKey(key)) {
      requirementChecklist[key] = !requirementChecklist[key]!;
      requirementChecklist.refresh();
    }
  }
}
