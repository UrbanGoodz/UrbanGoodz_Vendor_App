import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/order_anywhere/domain/models/order_anywhere_request_model.dart';
import 'package:sixam_mart/features/order_anywhere/domain/services/order_anywhere_service_interface.dart';
import 'package:sixam_mart/helper/route_helper.dart';

class OrderAnywhereController extends GetxController implements GetxService {
  final OrderAnywhereServiceInterface orderAnywhereServiceInterface;
  OrderAnywhereController({required this.orderAnywhereServiceInterface});

  OrderAnywhereRequestModel _currentRequest = OrderAnywhereRequestModel();
  OrderAnywhereRequestModel get currentRequest => _currentRequest;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<OrderAnywhereRequestModel> _myRequests = [];
  List<OrderAnywhereRequestModel> get myRequests => _myRequests;

  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final estimatedCostController = TextEditingController();
  final customerNotesController = TextEditingController();
  final deliveryAddressController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final tipController = TextEditingController();

  OrderAnywherePickupPreference selectedPickupPreference = OrderAnywherePickupPreference.driverPurchases;
  OrderAnywhereUrgency selectedUrgency = OrderAnywhereUrgency.standard;
  bool consentGiven = false;

  void setPickupPreference(OrderAnywherePickupPreference pref) {
    selectedPickupPreference = pref;
    update();
  }

  void setUrgency(OrderAnywhereUrgency urgency) {
    selectedUrgency = urgency;
    update();
  }

  void setConsent(bool value) {
    consentGiven = value;
    update();
  }

  bool validateRequestForm() {
    if (businessNameController.text.trim().isEmpty) {
      _errorMessage = 'Store/vendor name is required';
      update();
      return false;
    }
    if (businessAddressController.text.trim().isEmpty) {
      _errorMessage = 'Store/vendor address or website is required';
      update();
      return false;
    }
    if (itemNameController.text.trim().isEmpty) {
      _errorMessage = 'What do you need? is required';
      update();
      return false;
    }
    if (itemDescriptionController.text.trim().isEmpty) {
      _errorMessage = 'Item details are required';
      update();
      return false;
    }
    if (quantityController.text.trim().isEmpty || int.tryParse(quantityController.text.trim()) == null) {
      _errorMessage = 'Quantity is required and must be a number';
      update();
      return false;
    }
    if (estimatedCostController.text.trim().isEmpty || double.tryParse(estimatedCostController.text.trim()) == null) {
      _errorMessage = 'Estimated item cost is required';
      update();
      return false;
    }
    if (deliveryAddressController.text.trim().isEmpty) {
      _errorMessage = 'Delivery address is required';
      update();
      return false;
    }
    if (!consentGiven) {
      _errorMessage = 'You must consent to proceed';
      update();
      return false;
    }
    _errorMessage = null;
    return true;
  }

  void buildRequestFromForm() {
    final quantity = int.tryParse(quantityController.text.trim()) ?? 1;
    final itemCost = double.tryParse(estimatedCostController.text.trim()) ?? 0.0;
    final tip = double.tryParse(tipController.text.trim()) ?? 0.0;

    _currentRequest = OrderAnywhereRequestModel(
      businessName: businessNameController.text.trim(),
      businessAddress: businessAddressController.text.trim().isEmpty ? null : businessAddressController.text.trim(),
      itemName: itemNameController.text.trim(),
      itemDescription: itemDescriptionController.text.trim().isEmpty ? null : itemDescriptionController.text.trim(),
      quantity: quantity,
      estimatedItemCost: itemCost,
      customerNotes: customerNotesController.text.trim().isEmpty ? null : customerNotesController.text.trim(),
      pickupPreference: selectedPickupPreference,
      deliveryAddress: deliveryAddressController.text.trim(),
      contactPhone: contactPhoneController.text.trim().isEmpty ? null : contactPhoneController.text.trim(),
      urgency: selectedUrgency,
      consentGiven: consentGiven,
      tip: tip,
      deliveryFee: _currentRequest.deliveryFee,
      serviceFee: _currentRequest.serviceFeeCalculated,
    );
    _currentRequest.recalculateTotal();
  }

  void navigateToReview() {
    if (!validateRequestForm()) return;
    buildRequestFromForm();
    Get.toNamed(RouteHelper.getOrderAnywhereReviewRoute());
  }

  Future<void> submitRequest() async {
    _isSubmitting = true;
    _errorMessage = null;
    update();

    try {
      buildRequestFromForm();
      final result = await orderAnywhereServiceInterface.submitRequest(_currentRequest);
      if (result != null) {
        _currentRequest = result;
        Get.offNamed(RouteHelper.getOrderAnywhereStatusRoute(_currentRequest.id ?? ''));
      } else {
        _errorMessage = 'Backend endpoint pending. This tester build cannot submit live Order Anywhere requests yet.';
        update();
      }
    } catch (e) {
      _errorMessage = e.toString();
      update();
    }

    _isSubmitting = false;
    update();
  }

  Future<void> markTestPayment() async {
    try {
      final success = await orderAnywhereServiceInterface.markPaymentTest(_currentRequest.id ?? '');
      if (success) {
        _currentRequest = _currentRequest.copyWith(
          requestStatus: OrderAnywhereRequestStatus.submitted,
          paymentStatus: OrderAnywherePaymentStatus.paidTest,
        );
        update();
        Get.snackbar('TEST PAYMENT', 'TEST PAYMENT ONLY — NOT PRODUCTION',
          backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Backend endpoint pending. Cannot process test payment.',
          backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Backend endpoint pending. Cannot process test payment.',
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> cancelRequest() async {
    try {
      final success = await orderAnywhereServiceInterface.cancelRequest(_currentRequest.id ?? '');
      if (success) {
        _currentRequest = _currentRequest.copyWith(
          requestStatus: OrderAnywhereRequestStatus.cancelled,
        );
        update();
      }
    } catch (e) {
      Get.snackbar('Error', 'Backend endpoint pending. Cannot cancel request.',
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchMyRequests() async {
    try {
      _myRequests = await orderAnywhereServiceInterface.getMyRequests();
      update();
    } catch (e) {
      _errorMessage = e.toString();
      update();
    }
  }

  Future<void> loadRequestById(String id) async {
    try {
      final result = await orderAnywhereServiceInterface.getRequestById(id);
      if (result != null) {
        _currentRequest = result;
        update();
      }
    } catch (e) {
      _errorMessage = e.toString();
      update();
    }
  }

  @override
  void onClose() {
    businessNameController.dispose();
    businessAddressController.dispose();
    itemNameController.dispose();
    itemDescriptionController.dispose();
    quantityController.dispose();
    estimatedCostController.dispose();
    customerNotesController.dispose();
    deliveryAddressController.dispose();
    contactPhoneController.dispose();
    tipController.dispose();
    super.onClose();
  }
}
