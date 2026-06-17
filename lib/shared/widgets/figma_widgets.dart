import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/models.dart';

IconData categoryIcon(String iconName) {
  return switch (iconName) {
    'bolt' => Icons.flash_on_outlined,
    'movie' => Icons.movie_outlined,
    'checkroom' => Icons.checkroom_outlined,
    'restaurant' => Icons.restaurant_outlined,
    'flight' => Icons.flight_outlined,
    'local_grocery_store' => Icons.local_grocery_store_outlined,
    'shopping_bag' => Icons.shopping_bag_outlined,
    'devices' => Icons.devices_outlined,
    _ => Icons.category_outlined,
  };
}

/// Full-screen Figma gradient wrapper used on every screen.
class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: child,
    );
  }
}

class DarkScaffold extends StatelessWidget {
  const DarkScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.safeArea = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: safeArea ? SafeArea(child: body) : body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

class FigmaSearchField extends StatelessWidget {
  const FigmaSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.onBack,
  });

  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool autofocus;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 22),
              onPressed: onBack,
              splashRadius: 22,
            )
          else
            const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              autofocus: autofocus,
              onTap: onTap,
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 15),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: AppColors.textHint, size: 22),
          ),
        ],
      ),
    );
  }
}

class FigmaFilterChip extends StatelessWidget {
  const FigmaFilterChip({
    super.key,
    required this.label,
    this.onTap,
    this.selected = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? AppColors.surfaceElevated : AppColors.chipFill,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
        style: const TextStyle(color: AppColors.discountGreen, fontWeight: FontWeight.w600),
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
        style: const TextStyle(color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.w600),
      ),
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
        Text('Quantity', style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        _StepButton(icon: Icons.remove, onTap: quantity > min ? () => onChanged(quantity - 1) : null),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('$quantity', style: Theme.of(context).textTheme.titleMedium),
        ),
        _StepButton(icon: Icons.add, onTap: quantity < max ? () => onChanged(quantity + 1) : null),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 18, color: onTap != null ? AppColors.textPrimary : AppColors.textTertiary),
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: amounts.length,
      itemBuilder: (context, index) {
        final amount = amounts[index].toDouble();
        final selected = selectedAmount == amount;
        return Material(
          color: selected ? AppColors.surfaceElevated : AppColors.chipFill,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => onSelected(amount),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.textPrimary : AppColors.glassBorder,
                  width: selected ? 1.5 : 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text('${amount.toInt()}', style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
        );
      },
    );
  }
}

class CategoryChipRow extends StatelessWidget {
  const CategoryChipRow({
    super.key,
    required this.categories,
    this.selectedId,
    required this.onSelected,
  });

  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        final selected = selectedId == category.id;
        return FigmaFilterChip(
          label: category.name,
          selected: selected,
          onTap: () => onSelected(selected ? null : category.id),
        );
      }).toList(),
    );
  }
}
