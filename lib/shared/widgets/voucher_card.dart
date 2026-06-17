import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/models.dart';
import 'brand_image.dart';

class BrandLogoTile extends StatelessWidget {
  const BrandLogoTile({
    super.key,
    required this.brand,
    this.onTap,
  });

  final Brand brand;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.chipFill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BrandAvatar(brand: brand, size: 36, fontSize: 16),
              const SizedBox(height: 6),
              Text(
                brand.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherCard extends StatelessWidget {
  const VoucherCard({
    super.key,
    required this.brand,
    this.onTap,
    this.compact = false,
  });

  final Brand brand;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 12 : 16),
            child: compact ? _buildCompact(context) : _buildFull(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Row(
      children: [
        BrandAvatar(brand: brand, size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(brand.name, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'From ${CurrencyFormatter.format(brand.startingPrice)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        _DiscountBadge(discount: brand.discountPercent),
      ],
    );
  }

  Widget _buildFull(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: BrandAvatar(brand: brand, size: 52)),
        const SizedBox(height: 12),
        Text(
          brand.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          '${brand.discountPercent.toStringAsFixed(0)}% off',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.discount});

  final double discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${discount.toStringAsFixed(0)}% OFF',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
