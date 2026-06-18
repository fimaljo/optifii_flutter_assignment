import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optifii_flutter_assignment/shared/widgets/brand_image.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../providers/providers.dart';
import '../../../../shared/widgets/figma_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = context.watch<MarketplaceProvider>();
    final brands = marketplace.searchBrands(_query);
    final categories = marketplace.searchCategories(_query);
    final hasQuery = _query.trim().isNotEmpty;
    final hasResults = brands.isNotEmpty || categories.isNotEmpty;

    return DarkScaffold(
      safeArea: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SearchFieldWidget(
              controller: _controller,
              hintText: 'Search Brands',
              autofocus: true,
              onBack: () => context.pop(),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: marketplace.filterCategories.map((category) {
                return FilterChipWidget(
                  label: category.name,
                  onTap: () {
                    final brand = marketplace
                        .getBrandsByCategory(category.id)
                        .firstOrNull;
                    if (brand != null) {
                     context.push('/category/${category.id}');
                    }
                  },
                );
              }).toList(),
            ),
          ),
         Expanded(
  child: !hasQuery
      ? const SizedBox()
      : !hasResults
          ? Center(
              child: Text(
                'No results found',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              children: [
                /// BRANDS
                if (brands.isNotEmpty) ...[
                  const Text(
                    'Brands',
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...brands.map((brand) {
                    return InkWell(
                      onTap: () =>
                          context.push('/voucher/${brand.id}'),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            BrandImage(
                              brand: brand,
                              size: 56,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                brand.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),
                ],

                /// CATEGORIES
                const Text(
                  'Categories',
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                ...categories.map((category) {
                  return InkWell(
                    onTap: () {
                     

                     context.push('/category/${category.id}');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // if (categories.isEmpty)
                //   const Padding(
                //     padding: EdgeInsets.symmetric(vertical: 8),
                //     child: Text(
                //       'No categories found',
                //       style: TextStyle(
                //         color: AppColors.textHint,
                //         fontSize: 16,
                //       ),
                //     ),
                //   ),
              ],
            ),
)
        ],
      ),
    );
  }
}
