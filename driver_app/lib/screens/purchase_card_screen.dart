import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';
import 'package:urban_goodz_driver/controllers/driver_auth_controller.dart';
import 'package:urban_goodz_driver/theme/app_theme.dart';
import 'package:urban_goodz_driver/services/api_client.dart';

class PurchaseCardScreen extends StatefulWidget {
  final int requestId;
  const PurchaseCardScreen({super.key, required this.requestId});

  @override
  State<PurchaseCardScreen> createState() => _PurchaseCardScreenState();
}

class _PurchaseCardScreenState extends State<PurchaseCardScreen> {
  final _api = Get.find<DriverApiService>();
  final _auth = Get.find<DriverAuthController>();

  bool _loading = true;
  bool _submitting = false;
  String? _error;
  Map<String, dynamic>? _cardData;

  final _authAmountController = TextEditingController();
  final _authMerchantController = TextEditingController();
  final _completeAmountController = TextEditingController();

  final _authFormKey = GlobalKey<FormState>();
  final _completeFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchCardDetails();
  }

  Future<void> _fetchCardDetails() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _api.getPurchaseCard(widget.requestId);
      setState(() {
        _cardData = data.isNotEmpty ? data : null;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e is ApiException ? e.message : e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _authorize() async {
    if (!_authFormKey.currentState!.validate()) return;
    if (_cardData == null) return;

    final amt = double.tryParse(_authAmountController.text.trim()) ?? 0.0;
    final merchant = _authMerchantController.text.trim();

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _api.authorizePurchaseCard(widget.requestId, amt, merchant);
      _authAmountController.clear();
      _authMerchantController.clear();
      await _fetchCardDetails();
      Get.snackbar(
        'Authorized',
        'Card purchase authorized.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() {
        _error = e is ApiException ? e.message : e.toString();
      });
    } finally {
      setState(() => _submitting = false);
    }
  }

  Future<void> _complete() async {
    if (!_completeFormKey.currentState!.validate()) return;

    final amt = double.tryParse(_completeAmountController.text.trim()) ?? 0.0;

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _api.completePurchaseCard(widget.requestId, amt);
      _completeAmountController.clear();
      await _fetchCardDetails();
      Get.snackbar(
        'Completed',
        'Transaction capture complete.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() {
        _error = e is ApiException ? e.message : e.toString();
      });
    } finally {
      setState(() => _submitting = false);
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'issued':
      case 'active':
        return Colors.green;
      case 'authorized':
        return Colors.blue;
      case 'used':
      case 'reconciled':
        return AppTheme.primary;
      case 'frozen':
      case 'expired':
      case 'failed':
      case 'cancelled':
        return Colors.redAccent;
      default:
        return AppTheme.dark;
    }
  }

  @override
  void dispose() {
    _authAmountController.dispose();
    _authMerchantController.dispose();
    _completeAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.beige,
      appBar: AppBar(
        title: const Text('Purchase Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading || _submitting ? null : _fetchCardDetails,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withAlpha(80)),
                        ),
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    if (_cardData == null) ...[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Column(
                            children: [
                              Icon(
                                Icons.credit_card_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No purchase card has been issued for this order anywhere request.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      _cardWidget(),
                      const SizedBox(height: 24),
                      _detailsWidget(),
                      const SizedBox(height: 24),
                      _instructionsWidget(),
                      const SizedBox(height: 24),
                      _actionsWidget(),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _cardWidget() {
    final last4 = _cardData?['last4']?.toString() ?? '****';
    final limit = _cardData?['spending_limit']?.toString() ?? '0.00';
    final exp = _cardData?['expires_at'] != null
        ? _cardData!['expires_at'].toString().substring(0, 10)
        : 'NEVER';

    return Container(
      height: 210,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.dark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.dark.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'URBAN GOODZ PURCHASE CARD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              Icon(
                Icons.contactless,
                color: Colors.white.withAlpha(150),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '••••  ••••  ••••  $last4',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARDHOLDER',
                    style: TextStyle(color: Colors.white70, fontSize: 9),
                  ),
                  Text(
                    _auth.name.value.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LIMIT',
                    style: TextStyle(color: Colors.white70, fontSize: 9),
                  ),
                  Text(
                    '\$$limit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(color: Colors.white70, fontSize: 9),
                  ),
                  Text(
                    exp,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailsWidget() {
    final status = _cardData?['card_status']?.toString();
    final statusLabel = _cardData?['card_status_label']?.toString() ?? status;
    final balance = _cardData?['remaining_balance']?.toString() ?? '0.00';
    final limit = _cardData?['spending_limit']?.toString() ?? '0.00';
    final merchant = _cardData?['allowed_merchant']?.toString() ?? 'ANY';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailRow(
              'Card Status',
              statusLabel?.toUpperCase(),
              _statusColor(status),
            ),
            const Divider(),
            _detailRow('Remaining Balance', '\$$balance', AppTheme.primary),
            const Divider(),
            _detailRow('Total Limit', '\$$limit', AppTheme.dark),
            const Divider(),
            _detailRow('Allowed Merchant', merchant, AppTheme.dark),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String? value, Color valColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Text(
            value ?? '—',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: valColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _instructionsWidget() {
    final inst =
        _cardData?['instructions']?.toString() ?? 'No instructions available.';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(60)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              inst,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsWidget() {
    final status = _cardData?['card_status']?.toString();
    final remainingStr = _cardData?['remaining_balance']?.toString() ?? '0';
    final remaining = double.tryParse(remainingStr) ?? 0.0;

    if (status == 'issued' || status == 'active') {
      return Form(
        key: _authFormKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Step 1: Authorize Pre-Auth Purchase',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _authAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Purchase Amount',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    final v = double.tryParse(val) ?? 0.0;
                    if (v <= 0) return 'Must be greater than 0';
                    if (v > remaining) return 'Cannot exceed remaining balance';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _authMerchantController,
                  decoration: const InputDecoration(
                    labelText: 'Merchant Name',
                    prefixIcon: Icon(Icons.storefront_outlined),
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitting ? null : _authorize,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('AUTHORIZE PRE-AUTH'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (status == 'authorized') {
      return Form(
        key: _completeFormKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Step 2: Capture Final Amount Spent',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _completeAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Final Captured Amount',
                    prefixIcon: Icon(Icons.receipt_long_outlined),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    final v = double.tryParse(val) ?? 0.0;
                    if (v <= 0) return 'Must be greater than 0';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitting ? null : _complete,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('COMPLETE TRANSACTION'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
