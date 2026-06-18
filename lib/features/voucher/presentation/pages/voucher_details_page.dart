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
    final brand = context.watch<MarketplaceProvider>().getBrandById(
      widget.brandId,
    );
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Rewards',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 90, 16, 16),
        children: [
          _BrandHeader(brand: brand),
          const SizedBox(height: 12),
          const Text(
            'Enter Denomination',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
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
          TextField(
            controller: _customController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your amount',
              hintStyle: TextStyle(color: AppColors.textHint, fontSize: 12),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),

              suffixIcon: InkWell(
                onTap: _addCustomAmount,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(left: 12.0,top: 4.0),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Min ₹100. Max ₹10000.',
                style: TextStyle(color: AppColors.textHint, fontSize: 10),
              ),
            ),
          ),

          const SizedBox(height: 4),
          QuantityStepper(
            quantity: _quantity,
            onChanged: (value) => setState(() => _quantity = value),
          ),

          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: amount == null
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF6D3CC0).withOpacity(.85),
                      const Color(0xFF12071F),
                    ],
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B42FF).withOpacity(.25),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'You Saved Rs. ${savings?.toStringAsFixed(0) ?? '0'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(amount * _quantity),
                          style: TextStyle(
                            color: Colors.white.withOpacity(.45),
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          CurrencyFormatter.format(totalPayable!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _proceed(brand, PurchaseMode.self),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: OutlinedButton(
                              onPressed: () =>
                                  _proceed(brand, PurchaseMode.gift),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withOpacity(.12),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                backgroundColor: Colors.black.withOpacity(.15),
                              ),
                              child: const Text(
                                'Send a Gift',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
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

  void _addCustomAmount() {
    final amount = double.tryParse(_customController.text.trim());

    if (amount == null) {
      setState(() {
        _amountError = 'Please enter an amount';
      });
      return;
    }

    if (amount < AppConstants.minVoucherAmount ||
        amount > AppConstants.maxVoucherAmount) {
      setState(() {
        _amountError =
            'Amount must be between ₹${AppConstants.minVoucherAmount.toInt()} and ₹${AppConstants.maxVoucherAmount.toInt()}';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _selectedAmount = amount;
      _amountError = null;
    });
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${brand.name} Voucher',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Validity ${brand.validityMonths} months',
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Discount',
                  style: TextStyle(color: AppColors.textHint, fontSize: 11),
                ),
                Text(
                  '${brand.discountPercent.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.discountGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: brand.brandColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: BrandImage(brand: brand, size: 64),
        ),
      ],
    );
  }
}
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Quantity:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const Spacer(),

        _StepButton(
          icon: Icons.remove,
          onTap: quantity > min
              ? () => onChanged(quantity - 1)
              : null,
        ),

        const SizedBox(width: 16),

        Text(
          '$quantity',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 16),

        _StepButton(
          icon: Icons.add,
          onTap: quantity < max
              ? () => onChanged(quantity + 1)
              : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF141836),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: onTap != null
              ? Colors.white
              : Colors.white24,
        ),
      ),
    );
  }
}
class DenominationGrid extends StatelessWidget {
  const DenominationGrid({
    super.key,
    required this.amounts,
    required this.selectedAmount,
    required this.onSelected,
  });

  final List<int> amounts;
  final double? selectedAmount;
  final ValueChanged<double> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          mainAxisExtent: 44,
        ),
        itemCount: amounts.length,
        itemBuilder: (context, index) {
          final amount = amounts[index].toDouble();
          final selected = selectedAmount == amount;

          return InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => onSelected(amount),
            child: Container(
              decoration: BoxDecoration(
                color: selected ? Colors.white : const Color(0xFF4B3175),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected
                      ? Colors.white
                      : Colors.white.withOpacity(.08),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                amount.toInt().toString(),
                style: TextStyle(
                  color: selected ? Colors.black : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SavingsChip extends StatelessWidget {
  const SavingsChip({super.key, required this.amount});
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'You Saved Rs. ${amount.toStringAsFixed(0)}',
        style: const TextStyle(
          color: AppColors.discountGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CashbackBadge extends StatelessWidget {
  const CashbackBadge({super.key, required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.orangeLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Cashback ${percent.toStringAsFixed(0)}%',
        style: const TextStyle(
          color: AppColors.orange,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
