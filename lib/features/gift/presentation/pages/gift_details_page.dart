import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/order_provider.dart';
import '../../../../shared/widgets/figma_widgets.dart';
import '../../../../shared/widgets/brand_image.dart';

class GiftDetailsPage extends StatefulWidget {
  const GiftDetailsPage({super.key});

  @override
  State<GiftDetailsPage> createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  GiftTheme _selectedTheme = GiftTheme.classic;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<OrderProvider>().checkoutDraft;
    if (draft == null) {
      return DarkScaffold(
        appBar: AppBar(title: const Text('Gift Details')),
        body: const Center(child: Text('No active checkout')),
      );
    }

    return DarkScaffold(
      appBar: AppBar(title: const Text('Send as Gift')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Receiver details', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Receiver name'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
              validator: (value) {
                if (value == null || value.trim().length < 10) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email address'),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _messageController,
              maxLength: AppConstants.giftMessageMaxLength,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Custom message',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            Text('Gift card theme', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: GiftTheme.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final theme = GiftTheme.values[index];
                  final selected = _selectedTheme == theme;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTheme = theme),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 140,
                      decoration: BoxDecoration(
                        gradient: _themeGradient(theme),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _themeLabel(theme),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (selected)
                            const Icon(Icons.check_circle, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _showPreview(context, draft),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Preview gift card'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => _continue(context, draft),
            child: const Text('Continue to Summary'),
          ),
        ),
      ),
    );
  }

  void _continue(BuildContext context, CheckoutDraft draft) {
    if (!_formKey.currentState!.validate()) return;

    context.read<OrderProvider>().updateGiftDetails(
          GiftDetails(
            receiverName: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            message: _messageController.text.trim(),
            theme: _selectedTheme,
          ),
          _selectedTheme,
        );
    context.push('/order-summary');
  }

  void _showPreview(BuildContext context, CheckoutDraft draft) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _GiftPreviewSheet(
        draft: draft,
        theme: _selectedTheme,
        receiverName: _nameController.text.trim().isEmpty
            ? 'Receiver Name'
            : _nameController.text.trim(),
        message: _messageController.text.trim().isEmpty
            ? 'Enjoy your gift voucher!'
            : _messageController.text.trim(),
      ),
    );
  }

  LinearGradient _themeGradient(GiftTheme theme) {
    return switch (theme) {
      GiftTheme.classic => const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
      GiftTheme.celebration => const LinearGradient(
          colors: [Color(0xFF9333EA), Color(0xFFDB2777)],
        ),
      GiftTheme.minimal => const LinearGradient(
          colors: [Color(0xFF334155), Color(0xFF64748B)],
        ),
      GiftTheme.festive => const LinearGradient(
          colors: [Color(0xFFEA580C), Color(0xFFDC2626)],
        ),
    };
  }

  String _themeLabel(GiftTheme theme) {
    return switch (theme) {
      GiftTheme.classic => 'Classic',
      GiftTheme.celebration => 'Celebration',
      GiftTheme.minimal => 'Minimal',
      GiftTheme.festive => 'Festive',
    };
  }
}

class _GiftPreviewSheet extends StatelessWidget {
  const _GiftPreviewSheet({
    required this.draft,
    required this.theme,
    required this.receiverName,
    required this.message,
  });

  final CheckoutDraft draft;
  final GiftTheme theme;
  final String receiverName;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gift Preview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: switch (theme) {
                GiftTheme.classic => const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  ),
                GiftTheme.celebration => const LinearGradient(
                    colors: [Color(0xFF9333EA), Color(0xFFDB2777)],
                  ),
                GiftTheme.minimal => const LinearGradient(
                    colors: [Color(0xFF334155), Color(0xFF64748B)],
                  ),
                GiftTheme.festive => const LinearGradient(
                    colors: [Color(0xFFEA580C), Color(0xFFDC2626)],
                  ),
              },
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BrandAvatar(brand: draft.brand, size: 40),
                    const Spacer(),
                    const Icon(Icons.card_giftcard, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'For $receiverName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close Preview'),
            ),
          ),
        ],
      ),
    );
  }
}
