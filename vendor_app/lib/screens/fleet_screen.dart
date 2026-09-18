import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/fleet_controller.dart';
import 'package:urban_goodz_vendor/models/fleet_model.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

/// The vendor's own delivery fleet: today's pulse, every driver and what
/// they are doing, and assigning or releasing them on the vendor's orders.
class FleetScreen extends StatelessWidget {
  const FleetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FleetController c = Get.put(FleetController());

    return Scaffold(
      appBar: AppBar(title: const Text('My Fleet')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDriver(context, c),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add driver'),
      ),
      body: Obx(() {
        if (c.isLoading.value && c.drivers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: c.refreshFleet,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              if (c.errorMessage.value != null)
                _ErrorBanner(message: c.errorMessage.value!, onRetry: c.refreshFleet),
              _buildPulse(c.summary.value),
              const SizedBox(height: 24),
              const Text(
                'Drivers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.dark,
                ),
              ),
              const SizedBox(height: 12),
              if (c.drivers.isEmpty && c.errorMessage.value == null)
                const _EmptyFleet()
              else
                ...c.drivers.map(
                  (driver) => _DriverCard(
                    driver: driver,
                    busy: c.isBusy.value,
                    onAssign: () => _showOrderPicker(context, c, driver),
                    onRelease: () => _confirmRelease(context, c, driver),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPulse(FleetSummary s) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.9,
      children: [
        _PulseTile(label: 'Available', value: s.driversAvailable, icon: Icons.check_circle_outline, color: Colors.green.shade700),
        _PulseTile(label: 'On a job', value: s.driversOnJob, icon: Icons.local_shipping_outlined, color: AppTheme.primary),
        _PulseTile(label: 'Delivered today', value: s.deliveriesCompleted, icon: Icons.task_alt, color: AppTheme.dark),
        _PulseTile(label: 'Awaiting approval', value: s.driversPending, icon: Icons.hourglass_top, color: Colors.orange.shade800),
      ],
    );
  }

  Future<void> _showOrderPicker(
    BuildContext context,
    FleetController c,
    FleetDriver driver,
  ) async {
    final picked = await showModalBottomSheet<AssignableOrder>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _OrderPicker(
        driverName: driver.name,
        load: c.loadAssignableOrders,
      ),
    );
    if (picked != null) {
      await c.assign(driver, picked);
    }
  }

  Future<void> _confirmRelease(
    BuildContext context,
    FleetController c,
    FleetDriver driver,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Release ${driver.name}?'),
        content: Text(
          'They will be taken off order #${driver.activeOrderId} and become '
          'available again. The order goes back to needing a driver.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Release'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await c.release(driver);
    }
  }

  Future<void> _showAddDriver(BuildContext context, FleetController c) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _AddDriverForm(controller: c),
    );
  }
}

class _PulseTile extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _PulseTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.beige.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: AppTheme.dark.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  final FleetDriver driver;
  final bool busy;
  final VoidCallback onAssign;
  final VoidCallback onRelease;

  const _DriverCard({
    required this.driver,
    required this.busy,
    required this.onAssign,
    required this.onRelease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.beige),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.dark),
                ),
                if (driver.phone.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(driver.phone, style: TextStyle(fontSize: 12, color: AppTheme.dark.withOpacity(0.6))),
                ],
                const SizedBox(height: 8),
                _DispatchChip(driver: driver),
              ],
            ),
          ),
          if (driver.canRelease)
            OutlinedButton(onPressed: busy ? null : onRelease, child: const Text('Release'))
          else if (driver.canAssign)
            FilledButton(
              onPressed: busy ? null : onAssign,
              style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
              child: const Text('Assign'),
            ),
        ],
      ),
    );
  }
}

class _DispatchChip extends StatelessWidget {
  final FleetDriver driver;

  const _DispatchChip({required this.driver});

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (driver.dispatchStatus) {
      'available' || 'available_for_ug' => ('Available', Colors.green.shade700),
      'on_business_job' => (
        driver.activeOrderId != null
            ? 'On order #${driver.activeOrderId}${driver.activeOrderStatus == 'picked_up' ? ' · picked up' : ''}'
            : 'On a job',
        AppTheme.primary,
      ),
      'pending_approval' => ('Awaiting Urban Goodz approval', Colors.orange.shade800),
      'suspended' => ('Suspended', Colors.red.shade700),
      'offline' => ('Offline', Colors.grey.shade600),
      _ => (driver.dispatchStatus.isEmpty ? 'Unknown' : driver.dispatchStatus, Colors.grey.shade600),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _OrderPicker extends StatefulWidget {
  final String driverName;
  final Future<List<AssignableOrder>> Function() load;

  const _OrderPicker({required this.driverName, required this.load});

  @override
  State<_OrderPicker> createState() => _OrderPickerState();
}

class _OrderPickerState extends State<_OrderPicker> {
  late Future<List<AssignableOrder>> _orders = widget.load();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                'Assign ${widget.driverName} to an order',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.dark),
              ),
            ),
            Flexible(
              child: FutureBuilder<List<AssignableOrder>>(
                future: _orders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    return _ErrorBanner(
                      message: error is VendorApiException ? error.message : 'Could not load orders.',
                      onRetry: () async => setState(() => _orders = widget.load()),
                    );
                  }
                  final orders = snapshot.data ?? const [];
                  if (orders.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No orders need a driver right now. Delivery orders show up '
                        'here until someone is assigned.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: orders.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final subtitle = [
                        if (order.customerName != null && order.customerName!.isNotEmpty) order.customerName!,
                        if (order.deliveryAddress != null && order.deliveryAddress!.isNotEmpty) order.deliveryAddress!,
                      ].join(' · ');
                      return ListTile(
                        title: Text('Order #${order.id} · \$${order.amount.toStringAsFixed(2)}'),
                        subtitle: subtitle.isEmpty
                            ? Text(order.status)
                            : Text('${order.status} · $subtitle', maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).pop(order),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddDriverForm extends StatefulWidget {
  final FleetController controller;

  const _AddDriverForm({required this.controller});

  @override
  State<_AddDriverForm> createState() => _AddDriverFormState();
}

class _AddDriverFormState extends State<_AddDriverForm> {
  final _formKey = GlobalKey<FormState>();
  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    for (final c in [_fName, _lName, _phone, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final added = await widget.controller.addDriver(
      fName: _fName.text.trim(),
      lName: _lName.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );
    if (added && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add a driver',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.dark),
              ),
              const SizedBox(height: 4),
              Text(
                'Urban Goodz reviews every driver before they can take orders. '
                'Share the password with your driver so they can sign in to the Driver app.',
                style: TextStyle(fontSize: 12, color: AppTheme.dark.withOpacity(0.6)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fName,
                decoration: const InputDecoration(labelText: 'First name'),
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _lName,
                decoration: const InputDecoration(labelText: 'Last name (optional)'),
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().length < 7) ? 'Enter a valid phone number' : null,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email (optional)'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Driver app password'),
                obscureText: true,
                validator: (v) => (v == null || v.length < 8) ? 'At least 8 characters' : null,
              ),
              const SizedBox(height: 20),
              Obx(
                () => FilledButton(
                  onPressed: widget.controller.isBusy.value ? null : _submit,
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
                  child: const Text('Add driver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyFleet extends StatelessWidget {
  const _EmptyFleet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.groups_outlined, size: 48, color: AppTheme.dark.withOpacity(0.3)),
          const SizedBox(height: 12),
          const Text(
            'No drivers yet',
            style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.dark),
          ),
          const SizedBox(height: 4),
          Text(
            'Add your own drivers to deliver your orders yourself.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppTheme.dark.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
