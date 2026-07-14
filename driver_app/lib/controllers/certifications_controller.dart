import 'package:get/get.dart';
import 'package:urban_goodz_driver/models/certification_model.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';

class CertificationsController extends GetxController {
  DriverApiService get _api => Get.find<DriverApiService>();

  var certifications = <CertificationModel>[].obs;
  var validCount = 0.obs;
  var expiredCount = 0.obs;
  var pendingCount = 0.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchCertifications();
    super.onInit();
  }

  void fetchCertifications() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final rawCerts = await _api.getCertifications();
      final items = rawCerts
          .map((e) => CertificationModel.fromJson(e))
          .toList();
      certifications.value = items;
      validCount.value = items.where((c) => c.status == 'valid').length;
      expiredCount.value = items.where((c) => c.status == 'expired').length;
      pendingCount.value = items.where((c) => c.status == 'pending').length;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void uploadDocument(String certId) async {
    try {
      final certIdInt = int.tryParse(certId);
      if (certIdInt == null) return;
      await _api.uploadCertDocument(certIdInt, '');
      Get.snackbar(
        'Uploaded',
        'Document uploaded successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchCertifications();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload document: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void renewCertification(String id) async {
    try {
      final certId = int.tryParse(id);
      if (certId == null) return;
      await _api.renewCertification(certId);
      Get.snackbar(
        'Renewal Requested',
        'Your renewal application has been submitted for review.',
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchCertifications();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to request renewal: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
