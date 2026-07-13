import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/vendor_auth_controller.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

class VendorOnboardingScreen extends StatefulWidget {
  const VendorOnboardingScreen({super.key});

  @override
  State<VendorOnboardingScreen> createState() => _VendorOnboardingScreenState();
}

class _VendorOnboardingScreenState extends State<VendorOnboardingScreen> {
  final auth = Get.find<VendorAuthController>();
  final formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: auth.email.value);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.beige,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.storefront,
                          size: 72,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Urban Goodz Vendor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sign in with an approved Vendor owner account.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            labelText: 'Vendor email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || !value.contains('@')
                              ? 'Enter a valid Vendor email.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => obscurePassword = !obscurePassword,
                              ),
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == null || value.length < 6
                              ? 'Password must be at least 6 characters.'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => auth.errorMessage.value == null
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.all(12),
                                  color: Colors.red.withOpacity(.08),
                                  child: Text(
                                    auth.errorMessage.value!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => ElevatedButton(
                            onPressed: auth.isLoading.value ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.dark,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: auth.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('SIGN IN'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Pending or suspended accounts are reported by the backend and cannot enter tester mode.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!formKey.currentState!.validate()) return;
    await auth.login(emailController.text, passwordController.text);
  }
}
