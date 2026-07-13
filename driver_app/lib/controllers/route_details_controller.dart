import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_driver/models/driver_job_model.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';

class RouteDetailsController extends GetxController {
  DriverApiService get _api => Get.find<DriverApiService>();

  var currentJob = Rx<DriverJobModel?>(null);
  var routeWaypoints = <MapPoint>[].obs;
  var currentStatus = ''.obs;
  var progress = 0.0.obs;
  var estimatedArrival = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  void fetchRoute(String jobId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final jobIdInt = int.tryParse(jobId);
      if (jobIdInt == null) {
        isLoading.value = false;
        return;
      }
      final jobData = await _api.getActiveJobDetail(jobIdInt);
      final job = DriverJobModel.fromJson(jobData);
      currentJob.value = job;
      currentStatus.value = job.status;
      estimatedArrival.value = job.estimatedDuration;

      routeWaypoints.value = [
        MapPoint(
          lat: job.pickupLatitude ?? 29.7604,
          lng: job.pickupLongitude ?? -95.3698,
          address: job.pickupAddress,
        ),
        MapPoint(
          lat: job.dropoffLatitude ?? 29.7050,
          lng: job.dropoffLongitude ?? -95.4020,
          address: job.dropoffAddress,
        ),
      ];

      switch (job.status) {
        case 'assigned':
        case 'accepted':
          progress.value = 0.1;
          break;
        case 'in_progress':
        case 'shopping':
          progress.value = 0.4;
          break;
        case 'picked_up':
          progress.value = 0.6;
          break;
        case 'out_for_delivery':
          progress.value = 0.8;
          break;
        case 'completed':
        case 'delivered':
          progress.value = 1.0;
          break;
        default:
          progress.value = 0.0;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendStatusUpdateToBackend(String driverTaskStatus) async {
    final job = currentJob.value;
    if (job == null) return;
    try {
      final jobId = int.tryParse(job.id);
      if (jobId == null) return;
      await _api.updateActiveJobStatus(jobId, driverTaskStatus);
      Get.snackbar('Synced', 'Status updated: $driverTaskStatus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF));
    } catch (e) {
      Get.snackbar('Sync Failed', 'Backend update failed: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void updateProgress() {
    if (progress.value < 1.0) {
      progress.value += 0.2;

      String statusStr = 'shopping';
      if (progress.value >= 0.7) {
        statusStr = 'en_route';
      } else if (progress.value >= 0.5) {
        statusStr = 'picked_up';
      }

      if (progress.value >= 1.0) {
        progress.value = 1.0;
        currentStatus.value = 'delivered';
        statusStr = 'delivered';
        Get.snackbar('Delivery Complete', 'You have reached your destination.',
            snackPosition: SnackPosition.BOTTOM);
      }
      sendStatusUpdateToBackend(statusStr);
    }
  }

  void markWaypointReached(int index) {
    if (index < routeWaypoints.length) {
      progress.value = (index + 1) / routeWaypoints.length;
      Get.snackbar(
          'Waypoint Reached', 'Arrived at ${routeWaypoints[index].address}',
          snackPosition: SnackPosition.BOTTOM);

      String statusStr = index == 0 ? 'picked_up' : 'delivered';
      sendStatusUpdateToBackend(statusStr);
    }
  }
}
