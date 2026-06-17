import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/order_provider.dart';
import '../../../../shared/widgets/brand_avatar.dart';
import '../../../../shared/widgets/common_widgets.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<OrderProvider>().checkoutDraft;
    if (draft == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Summary')),
        body: const Center(child: Text('No active checkout')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _OrderItemCard(draft: draft),
          const SizedBox(height: 16),
          if (draft.mode == PurchaseMode.gift && draft.giftDetails != null)
            _GiftInfoCard(details: draft.giftDetails!),
          const SizedBox(height: 16),
          PriceSummaryCard(
            voucherValue: draft.voucherValue,
            discountPercent: draft.discountPercent,
            highlightSavings: true,
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => context.push('/payment'),
            child: Text('Proceed to Pay · ${CurrencyFormatter.format(draft.finalPayable)}'),
          ),
        ),
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.draft});

  final CheckoutDraft draft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          BrandAvatar(brand: draft.brand),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(draft.brand.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Voucher value: ${CurrencyFormatter.format(draft.voucherValue)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  draft.mode == PurchaseMode.gift ? 'Send as gift' : 'Buy for self',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GiftInfoCard extends StatelessWidget {
  const _GiftInfoCard({required this.details});

  final GiftDetails details;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gift recipient', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _InfoRow(label: 'Name', value: details.receiverName),
          _InfoRow(label: 'Phone', value: details.phone),
          _InfoRow(label: 'Email', value: details.email),
          if (details.message.isNotEmpty)
            _InfoRow(label: 'Message', value: details.message),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
