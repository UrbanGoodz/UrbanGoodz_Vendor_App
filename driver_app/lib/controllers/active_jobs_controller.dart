import 'package:get/get.dart';
import 'package:urban_goodz_driver/models/driver_job_model.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';

class ActiveJobsController extends GetxController {
  DriverApiService get _api => Get.find<DriverApiService>();

  var activeJobs = <DriverJobModel>[].obs;
  var filteredJobs = <DriverJobModel>[].obs;
  var selectedFilter = 'all'.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchActiveJobs();
    super.onInit();
  }

  void fetchActiveJobs() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final jobsData = await _api.getActiveJobs();
      final jobs = jobsData.map((e) => DriverJobModel.fromJson(e)).toList();
      activeJobs.value = jobs;
      filterByType(selectedFilter.value);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filterByType(String type) {
    selectedFilter.value = type;
    if (type == 'all') {
      filteredJobs.value = List.from(activeJobs);
    } else {
      filteredJobs.value = activeJobs.where((job) => job.type == type).toList();
    }
  }

  void acceptJob(String id) async {
    try {
      final jobId = int.tryParse(id);
      if (jobId == null) return;
      final updated = await _api.acceptLoad(jobId);
      if (updated.isNotEmpty) {
        fetchActiveJobs();
        Get.snackbar('Job Accepted', 'You are now working on this job.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept job: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void startJob(String id) async {
    try {
      final jobId = int.tryParse(id);
      if (jobId == null) return;
      await _api.startActiveJob(jobId);
      fetchActiveJobs();
      Get.snackbar('Job Started', 'Head to the pickup location.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start job: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void completeJob(String id) async {
    try {
      final jobId = int.tryParse(id);
      if (jobId == null) return;
      await _api.completeActiveJob(jobId);
      fetchActiveJobs();
      Get.snackbar('Job Completed', 'Great work! Earnings have been added.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete job: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void cancelJob(String id) async {
    try {
      final jobId = int.tryParse(id);
      if (jobId == null) return;
      await _api.cancelActiveJob(jobId);
      fetchActiveJobs();
      Get.snackbar('Job Cancelled', 'The job has been removed from your list.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel job: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
