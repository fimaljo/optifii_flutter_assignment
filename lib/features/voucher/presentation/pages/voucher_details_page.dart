import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/price_calculator.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../shared/widgets/brand_image.dart';
import '../../../../shared/widgets/figma_widgets.dart';

class VoucherDetailsPage extends StatefulWidget {
  const VoucherDetailsPage({super.key, required this.brandId});

  final String brandId;

  @override
  State<VoucherDetailsPage> createState() => _VoucherDetailsPageState();
}

class _VoucherDetailsPageState extends State<VoucherDetailsPage> {
  double? _selectedAmount;
  final _customController = TextEditingController();
  int _quantity = 1;
  String? _amountError;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  double? get _effectiveAmount {
    if (_selectedAmount != null) return _selectedAmount;
    return double.tryParse(_customController.text.trim());
  }

  double? _savingsFor(Brand brand) {
    final amount = _effectiveAmount;
    if (amount == null) return null;
    return PriceCalculator.calculate(
      voucherValue: amount * _quantity,
      discountPercent: brand.discountPercent,
    ).savings;
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.watch<MarketplaceProvider>().getBrandById(widget.brandId);
    if (brand == null) {
      return DarkScaffold(
        appBar: AppBar(title: const Text('Rewards')),
        body: const Center(child: Text('Brand not found')),
      );
    }

    final amount = _effectiveAmount;
    final totalPayable = amount != null
        ? PriceCalculator.calculate(
            voucherValue: amount * _quantity,
            discountPercent: brand.discountPercent,
          ).finalPayable
        : null;
    final savings = _savingsFor(brand);

    return DarkScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Rewards'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BrandHeader(brand: brand),
          const SizedBox(height: 24),
          Text('Select Denomination', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          DenominationGrid(
            amounts: AppConstants.predefinedDenominations,
            selectedAmount: _selectedAmount,
            onSelected: (value) {
              setState(() {
                _selectedAmount = value;
                _customController.clear();
                _amountError = null;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _customController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Enter any amount',
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
          QuantityStepper(
            quantity: _quantity,
            onChanged: (value) => setState(() => _quantity = value),
          ),
          if (savings != null && savings > 0) ...[
            const SizedBox(height: 16),
            Center(child: SavingsChip(amount: savings)),
          ],
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: amount != null
                          ? () => _proceed(brand, PurchaseMode.self)
                          : null,
                      child: Text(
                        totalPayable != null
                            ? 'Buy Now · ${CurrencyFormatter.format(totalPayable)}'
                            : 'Buy Now',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: amount != null
                          ? () => _proceed(brand, PurchaseMode.gift)
                          : null,
                      child: const Text('Send a Gift'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _proceed(Brand brand, PurchaseMode mode) {
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

    context.read<OrderProvider>().startCheckout(
          brand: brand,
          unitAmount: amount,
          mode: mode,
          quantity: _quantity,
        );

    if (mode == PurchaseMode.gift) {
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          BrandAvatar(brand: brand, size: 56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${brand.name} Voucher',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Validity: ${brand.validityMonths} months',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          CashbackBadge(percent: brand.discountPercent),
        ],
      ),
    );
  }
}
