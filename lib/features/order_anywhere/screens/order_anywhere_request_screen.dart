import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/order_anywhere/controllers/order_anywhere_controller.dart';
import 'package:sixam_mart/features/order_anywhere/domain/models/order_anywhere_request_model.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';

class OrderAnywhereRequestScreen extends StatefulWidget {
  const OrderAnywhereRequestScreen({super.key});

  @override
  State<OrderAnywhereRequestScreen> createState() => _OrderAnywhereRequestScreenState();
}

class _OrderAnywhereRequestScreenState extends State<OrderAnywhereRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late OrderAnywhereController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<OrderAnywhereController>();
    controller.fetchMyRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text('Order Anywhere Request'),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: UrbanGoodzStatusBadge(status: 'Preview', isCompact: true),
            ),
          ),
        ],
      ),
      body: GetBuilder<OrderAnywhereController>(builder: (ctrl) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.seasoningOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.3)),
                  ),
                  child: const Row(children: [
                    Icon(Icons.info_outline, color: AppConstants.seasoningOrange, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Request from any store or vendor, whether they are on the app or not. Your request will be reviewed and quoted before payment. Urban Goodz will confirm price, availability, and delivery before purchase. Payment and dispatch status will update as your request progresses.',
                        style: TextStyle(fontSize: 12, color: AppConstants.ugBlack),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                _sectionLabel('Store / Vendor'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.businessNameController,
                  label: 'Store/vendor name *',
                  hint: 'Enter store, vendor, or merchant name',
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: controller.businessAddressController,
                  label: 'Store/vendor address or website *',
                  hint: 'Street address, website, social link, or marketplace URL',
                  maxLines: 2,
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),

                const SizedBox(height: 20),
                _sectionLabel('Request Details'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.itemNameController,
                  label: 'What do you need? *',
                  hint: 'Example: size 10 black sneakers, phone charger, custom cake',
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: controller.itemDescriptionController,
                  label: 'Item details *',
                  hint: 'Size, color, brand, substitutions, exact variant, or link details',
                  maxLines: 3,
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.quantityController,
                      label: 'Quantity *',
                      hint: '1',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v?.trim().isEmpty ?? true) return 'Required';
                        if (int.tryParse(v!.trim()) == null) return 'Must be a number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.estimatedCostController,
                      label: 'Budget estimate (\$) *',
                      hint: '0.00',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v?.trim().isEmpty ?? true) return 'Required';
                        if (double.tryParse(v!.trim()) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ]),

                const SizedBox(height: 20),
                _sectionLabel('Pickup / Delivery Preference'),
                const SizedBox(height: 8),
                ...OrderAnywherePickupPreference.values.map((pref) {
                  return RadioListTile<OrderAnywherePickupPreference>(
                    title: Text(pref.label, style: const TextStyle(fontSize: 14)),
                    value: pref,
                    groupValue: controller.selectedPickupPreference,
                    activeColor: AppConstants.seasoningOrange,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    onChanged: (v) => controller.setPickupPreference(v!),
                  );
                }),

                const SizedBox(height: 20),
                _sectionLabel('Delivery Information'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.deliveryAddressController,
                  label: 'Delivery address or pickup notes *',
                  hint: 'Enter delivery address, pickup area, or manual handoff notes',
                  maxLines: 2,
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: controller.contactPhoneController,
                  label: 'Phone / Contact',
                  hint: 'Optional contact number',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Get.snackbar('Photo Upload', 'Photo upload will be available when backend is connected.',
                      backgroundColor: AppConstants.seasoningOrange, colorText: AppConstants.ugWhite);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      Icon(Icons.camera_alt, color: Colors.grey.shade600),
                      const SizedBox(width: 12),
                      Text('Take or upload photo (optional)', style: TextStyle(color: Colors.grey.shade600)),
                    ]),
                  ),
                ),

                const SizedBox(height: 12),
                _buildTextField(
                  controller: controller.customerNotesController,
                  label: 'Notes',
                  hint: 'Manual fallback details, substitutions, gate code, or tester notes',
                  maxLines: 3,
                ),

                const SizedBox(height: 20),
                _sectionLabel('Urgency'),
                const SizedBox(height: 8),
                Row(children: OrderAnywhereUrgency.values.map((u) {
                  final selected = controller.selectedUrgency == u;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: u == OrderAnywhereUrgency.standard ? 4 : 0, left: u == OrderAnywhereUrgency.scheduled ? 4 : 0),
                      child: ChoiceChip(
                        label: Text(u.label, style: TextStyle(fontSize: 12, color: selected ? AppConstants.ugWhite : AppConstants.ugBlack)),
                        selected: selected,
                        selectedColor: AppConstants.seasoningOrange,
                        onSelected: (_) => controller.setUrgency(u),
                      ),
                    ),
                  );
                }).toList()),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.canvas,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.3)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                      width: 24, height: 24,
                      child: Checkbox(
                        value: controller.consentGiven,
                        activeColor: AppConstants.seasoningOrange,
                        onChanged: (v) => controller.setConsent(v ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'I understand this is an Order Anywhere request. Final cost may change after receipt review.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ]),
                ),

                const SizedBox(height: 24),

                if (controller.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(controller.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                  ),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.seasoningOrange,
                      foregroundColor: AppConstants.ugWhite,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: controller.isSubmitting ? null : () {
                      final formValid = _formKey.currentState?.validate() ?? false;
                      if (!formValid || !controller.validateRequestForm()) {
                        Get.snackbar('Validation', controller.errorMessage ?? 'Please fill required fields',
                          backgroundColor: Colors.red, colorText: AppConstants.ugWhite);
                        return;
                      }
                      controller.submitRequest();
                    },
                    child: controller.isSubmitting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppConstants.ugWhite))
                        : const Text('Submit Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),

                TextButton.icon(
                  onPressed: () {
                    final formValid = _formKey.currentState?.validate() ?? false;
                    if (!formValid || !controller.validateRequestForm()) {
                      Get.snackbar('Validation', controller.errorMessage ?? 'Please fill required fields',
                        backgroundColor: Colors.red, colorText: AppConstants.ugWhite);
                      return;
                    }
                    controller.navigateToReview();
                  },
                  icon: const Icon(Icons.preview_outlined),
                  label: const Text('Preview request details'),
                ),

                const SizedBox(height: 20),
                _sectionLabel('My Order Anywhere Requests'),
                const SizedBox(height: 8),
                if (controller.myRequests.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstants.canvas,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.25)),
                    ),
                    child: const Text(
                      'Submitted requests will appear here with admin, vendor, and driver status updates when available.',
                      style: TextStyle(fontSize: 12, color: AppConstants.ugBlack),
                    ),
                  )
                else
                  ...controller.myRequests.take(3).map((request) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.ugWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppConstants.ugBlack.withValues(alpha: 0.08)),
                      ),
                      child: InkWell(
                        onTap: () => Get.toNamed('/order-anywhere-status?requestId=${request.id ?? ''}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(request.itemName.isEmpty ? 'Order Anywhere Request' : request.itemName,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppConstants.ugBlack)),
                            const SizedBox(height: 4),
                            Text(
                              '${request.requestStatus.value.replaceAll('_', ' ').toUpperCase()}${request.backendLimited ? ' - backend-limited fallback' : ''}',
                              style: const TextStyle(fontSize: 11, color: AppConstants.seasoningOrange, fontWeight: FontWeight.w700),
                            ),
                            if ((request.adminNotes ?? '').isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text('Admin notes: ${request.adminNotes}', style: const TextStyle(fontSize: 11, color: AppConstants.ugBlack)),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: AppConstants.ugBlack));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
