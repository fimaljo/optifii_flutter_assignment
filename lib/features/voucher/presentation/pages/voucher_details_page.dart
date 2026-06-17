import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/order_provider.dart';
import '../../../../shared/widgets/brand_avatar.dart';
import '../../../../shared/widgets/common_widgets.dart';

class VoucherDetailsPage extends StatefulWidget {
  const VoucherDetailsPage({super.key, required this.brandId});

  final String brandId;

  @override
  State<VoucherDetailsPage> createState() => _VoucherDetailsPageState();
}

class _VoucherDetailsPageState extends State<VoucherDetailsPage> {
  double? _selectedAmount;
  final _customController = TextEditingController();
  PurchaseMode _mode = PurchaseMode.self;
  String? _amountError;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  Brand? get _brand => context.read<OrderProvider>().getBrand(widget.brandId);

  double? get _effectiveAmount {
    if (_selectedAmount != null) return _selectedAmount;
    final custom = double.tryParse(_customController.text.trim());
    return custom;
  }

  @override
  Widget build(BuildContext context) {
    final brand = _brand;
    if (brand == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Voucher Details')),
        body: const Center(child: Text('Brand not found')),
      );
    }

    final amount = _effectiveAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('Voucher Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BrandHeader(brand: brand),
          const SizedBox(height: 24),
          Text('Select amount', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AppConstants.predefinedDenominations.map((value) {
              final selected = _selectedAmount == value.toDouble();
              return ChoiceChip(
                label: Text(CurrencyFormatter.format(value)),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _selectedAmount = value.toDouble();
                    _customController.clear();
                    _amountError = null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _customController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Custom amount',
              hintText: 'Min ${CurrencyFormatter.format(AppConstants.minVoucherAmount)} · Max ${CurrencyFormatter.format(AppConstants.maxVoucherAmount)}',
              errorText: _amountError,
              prefixText: '₹ ',
            ),
            onChanged: (_) {
              setState(() {
                _selectedAmount = null;
                _amountError = null;
              });
            },
          ),
          const SizedBox(height: 24),
          Text('Purchase for', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<PurchaseMode>(
            segments: const [
              ButtonSegment(
                value: PurchaseMode.self,
                label: Text('Buy for self'),
                icon: Icon(Icons.person_outline),
              ),
              ButtonSegment(
                value: PurchaseMode.gift,
                label: Text('Send as gift'),
                icon: Icon(Icons.card_giftcard_outlined),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (selection) {
              setState(() => _mode = selection.first);
            },
          ),
          if (amount != null && amount >= AppConstants.minVoucherAmount) ...[
            const SizedBox(height: 24),
            PriceSummaryCard(
              voucherValue: amount,
              discountPercent: brand.discountPercent,
            ),
          ],
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => _proceed(brand),
            child: Text(_mode == PurchaseMode.gift ? 'Continue to Gift' : 'Proceed to Summary'),
          ),
        ),
      ),
    );
  }

  void _proceed(Brand brand) {
    final amount = _effectiveAmount;
    if (amount == null) {
      setState(() => _amountError = 'Please select or enter an amount');
      return;
    }
    if (amount < AppConstants.minVoucherAmount ||
        amount > AppConstants.maxVoucherAmount) {
      setState(
        () => _amountError =
            'Amount must be between ${CurrencyFormatter.format(AppConstants.minVoucherAmount)} and ${CurrencyFormatter.format(AppConstants.maxVoucherAmount)}',
      );
      return;
    }

    final provider = context.read<OrderProvider>();
    provider.startCheckout(brand: brand, voucherValue: amount, mode: _mode);

    if (_mode == PurchaseMode.gift) {
      context.push('/gift-details');
    } else {
      context.push('/order-summary');
    }
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.brand});

  final Brand brand;

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
              BrandAvatar(brand: brand, size: 56),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(brand.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      '${brand.discountPercent.toStringAsFixed(0)}% discount · ${brand.validityMonths} months validity',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(brand.description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
