import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../providers/order_provider.dart';
import '../../../../shared/widgets/figma_widgets.dart';
import '../../../../shared/widgets/common_widgets.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<OrderProvider>().checkoutDraft;
    if (draft == null) {
      return DarkScaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: const Center(child: Text('No active checkout')),
      );
    }

    return DarkScaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SecurePaymentBanner(),
          const SizedBox(height: 24),
          Text('Payment method', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _PaymentMethodTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'UPI',
            subtitle: 'Google Pay, PhonePe, Paytm',
            selected: true,
          ),
          const SizedBox(height: 8),
          _PaymentMethodTile(
            icon: Icons.credit_card_outlined,
            title: 'Credit / Debit Card',
            subtitle: 'Visa, Mastercard, RuPay',
          ),
          const SizedBox(height: 8),
          _PaymentMethodTile(
            icon: Icons.account_balance_outlined,
            title: 'Net Banking',
            subtitle: 'All major banks supported',
          ),
          const SizedBox(height: 24),
          PriceSummaryCard(
            voucherValue: draft.voucherValue,
            discountPercent: draft.discountPercent,
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isProcessing ? null : () => _processPayment(context),
            child: _isProcessing
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text('Proceed to Pay · ${CurrencyFormatter.format(draft.finalPayable)}'),
          ),
        ),
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    setState(() => _isProcessing = true);
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    final order = context.read<OrderProvider>().completePurchase();
    if (order != null) {
      context.go('/payment-success/${order.id}');
    }
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (selected)
            const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }
}
