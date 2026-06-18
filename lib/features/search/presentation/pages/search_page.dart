import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../providers/providers.dart';
import '../../../../shared/widgets/figma_widgets.dart';
import '../../../../shared/widgets/voucher_card.dart';

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
                      context.push('/voucher/${brand.id}');
                    }
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: !hasQuery
                ? const Center(
                    child: Text(
                      'No Search History',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
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
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (categories.isNotEmpty) ...[
                            ...categories.map((category) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Categories > ${category.name}',
                                  style: const TextStyle(color: AppColors.textPrimary),
                                ),
                                onTap: () {
                                  final brand = marketplace
                                      .getBrandsByCategory(category.id)
                                      .firstOrNull;
                                  if (brand != null) {
                                    context.push('/voucher/${brand.id}');
                                  }
                                },
                              );
                            }),
                            const SizedBox(height: 8),
                          ],
                          if (brands.isNotEmpty) ...[
                            ...brands.map((brand) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Brands > ${brand.name}',
                                  style: const TextStyle(color: AppColors.textPrimary),
                                ),
                                onTap: () => context.push('/voucher/${brand.id}'),
                              );
                            }),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.9,
                              ),
                              itemCount: brands.length,
                              itemBuilder: (context, index) {
                                final brand = brands[index];
                                return VoucherCard(
                                  brand: brand,
                                  onTap: () => context.push('/voucher/${brand.id}'),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
