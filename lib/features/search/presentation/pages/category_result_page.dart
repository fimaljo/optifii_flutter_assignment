import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../providers/marketplace_provider.dart';
import '../../../../shared/widgets/figma_widgets.dart';
import '../../../../shared/widgets/voucher_card.dart';

class CategoryResultsPage extends StatelessWidget {
  const CategoryResultsPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final marketplace = context.watch<MarketplaceProvider>();

    final category = marketplace.categories.firstWhere(
      (e) => e.id == categoryId,
    );

    final brands = marketplace.getBrandsByCategory(categoryId);

    return DarkScaffold(
      safeArea: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SearchFieldWidget(
              controller: TextEditingController(text: category.name),
              readOnly: true,
              onBack: () => context.pop(),
              hintText: '',
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              'Showing related results for "${category.name}"',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: brands.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                         
                          const Text(
                            'No brands found',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No brands available in ${category.name}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      24,
                    ),
                    itemCount: brands.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      final brand = brands[index];

                      return VoucherCard(
                        brand: brand,
                        onTap: () {
                          context.push('/voucher/${brand.id}');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}