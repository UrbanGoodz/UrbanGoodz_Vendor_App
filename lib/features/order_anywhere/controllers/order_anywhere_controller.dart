import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../domain/models/order_anywhere_request_model.dart';

class OrderAnywhereController extends GetxController {
  // Form controllers
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessAddressController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController estimatedCostController = TextEditingController();
  final TextEditingController deliveryAddressController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController customerNotesController = TextEditingController();

  // UI state
  bool consentGiven = false;
  bool isSubmitting = false;
  String? errorMessage;

  // Selections
  OrderAnywherePickupPreference selectedPickupPreference = OrderAnywherePickupPreference.delivery;
  OrderAnywhereUrgency selectedUrgency = OrderAnywhereUrgency.standard;

  // Requests
  List<OrderAnywhereRequest> myRequests = [];

  @override
  void onClose() {
    businessNameController.dispose();
    businessAddressController.dispose();
    itemNameController.dispose();
    itemDescriptionController.dispose();
    quantityController.dispose();
    estimatedCostController.dispose();
    deliveryAddressController.dispose();
    contactPhoneController.dispose();
    customerNotesController.dispose();
    super.onClose();
  }

  void fetchMyRequests() {
    // Minimal stub: keep empty list by default. Real implementation should fetch from API.
    myRequests = [];
    update();
  }

  bool validateRequestForm() {
    if (!consentGiven) {
      errorMessage = 'You must confirm this is an Order Anywhere request.';
      return false;
    }
    errorMessage = null;
    return true;
  }

  void submitRequest() async {
    if (isSubmitting) return;
    isSubmitting = true;
    update();
    // Minimal stub: pretend to submit and add a fake request in backend-limited mode
    await Future.delayed(const Duration(milliseconds: 300));
    final r = OrderAnywhereRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itemName: itemNameController.text.trim(),
      requestStatus: RequestStatus.quote_pending,
      backendLimited: true,
      adminNotes: null,
    );
    myRequests.insert(0, r);
    isSubmitting = false;
    update();
  }

  void navigateToReview() {
    // In real app: navigate to review screen. Stub does nothing.
  }

  void setPickupPreference(OrderAnywherePickupPreference p) {
    selectedPickupPreference = p;
    update();
  }

  void setUrgency(OrderAnywhereUrgency u) {
    selectedUrgency = u;
    update();
  }

  void setConsent(bool v) {
    consentGiven = v;
    update();
  }
}
