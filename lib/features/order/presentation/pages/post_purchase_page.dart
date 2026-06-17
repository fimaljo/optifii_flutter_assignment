import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../shared/widgets/figma_widgets.dart';
import '../../../../shared/widgets/brand_image.dart';

class PostPurchasePage extends StatelessWidget {
  const PostPurchasePage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().getOrderById(orderId);

    if (order == null) {
      return DarkScaffold(
        appBar: AppBar(title: const Text('Voucher Details')),
        body: const Center(child: Text('Order not found')),
      );
    }

    return DarkScaffold(
      appBar: AppBar(
        title: const Text('Voucher Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/orders'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _VoucherCardSection(order: order),
          const SizedBox(height: 16),
          _ExpandableSection(
            title: 'Terms & Conditions',
            items: order.brand.termsAndConditions,
          ),
          const SizedBox(height: 12),
          _ExpandableSection(
            title: 'How to Redeem',
            items: order.brand.howToRedeem,
          ),
        ],
      ),
    );
  }
}

class _VoucherCardSection extends StatelessWidget {
  const _VoucherCardSection({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BrandAvatar(brand: order.brand, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.brand.name, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      'Expires ${DateFormat('dd MMM yyyy').format(order.credentials.expiryDate)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _CredentialField(
            label: 'Card Number',
            value: order.credentials.cardNumber,
            isRevealed: order.isRevealed,
            maskedValue: _maskCardNumber(order.credentials.cardNumber),
          ),
          const SizedBox(height: 12),
          _CredentialField(
            label: 'PIN',
            value: order.credentials.pin,
            isRevealed: order.isRevealed,
            maskedValue: '****',
          ),
          const SizedBox(height: 20),
          if (!order.isRevealed)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<OrderProvider>().revealVoucher(order.id);
                },
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Reveal Voucher'),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyToClipboard(
                      context,
                      order.credentials.cardNumber,
                      'Card number copied',
                    ),
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy Card'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyToClipboard(
                      context,
                      order.credentials.pin,
                      'PIN copied',
                    ),
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy PIN'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _maskCardNumber(String cardNumber) {
    final parts = cardNumber.split('-');
    if (parts.length < 4) return '****-****-****-****';
    return '****-****-****-${parts.last}';
  }

  void _copyToClipboard(BuildContext context, String value, String message) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CredentialField extends StatelessWidget {
  const _CredentialField({
    required this.label,
    required this.value,
    required this.isRevealed,
    required this.maskedValue,
  });

  final String label;
  final String value;
  final bool isRevealed;
  final String maskedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            isRevealed ? value : maskedValue,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  letterSpacing: 1.2,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ),
      ],
    );
  }
}

class _ExpandableSection extends StatelessWidget {
  const _ExpandableSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          children: items
              .map(
                (item) => ListTile(
                  leading: const Icon(Icons.circle, size: 6, color: AppColors.textTertiary),
                  title: Text(item, style: Theme.of(context).textTheme.bodyMedium),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
