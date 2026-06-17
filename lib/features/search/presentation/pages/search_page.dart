import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/repositories/voucher_repository.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/figma_widgets.dart';
import '../../../../shared/widgets/voucher_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _repository = const VoucherRepository();
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brands = _repository.searchBrands(_query);
    final categories = _repository.searchCategories(_query);
    final hasQuery = _query.trim().isNotEmpty;
    final hasResults = brands.isNotEmpty || categories.isNotEmpty;

    return DarkScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: AppSearchBar(
          hintText: 'Search brands, categories...',
          controller: _controller,
          autofocus: true,
          onChanged: (value) => setState(() => _query = value),
        ),
        titleSpacing: 0,
      ),
      body: !hasQuery
          ? const EmptyStateWidget(
              icon: Icons.history,
              title: 'No Search History',
              subtitle: 'Your recent searches will appear here.',
            )
          : !hasResults
              ? EmptyStateWidget(
                  icon: Icons.search_off,
                  title: 'No results found',
                  subtitle: 'Try a different keyword like "Lifestyle" or "Food".',
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (categories.isNotEmpty) ...[
                      ...categories.map((category) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.category_outlined, size: 20),
                          title: Text('Categories > ${category.name}'),
                          onTap: () {
                            final brand = _repository
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
                          leading: const Icon(Icons.storefront_outlined, size: 20),
                          title: Text('Brands > ${brand.name}'),
                          onTap: () => context.push('/voucher/${brand.id}'),
                        );
                      }),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
