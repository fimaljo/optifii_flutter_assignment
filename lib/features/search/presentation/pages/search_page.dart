import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/repositories/voucher_repository.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/common_widgets.dart';
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: AppSearchBar(
          hintText: 'Search brands or categories',
          controller: _controller,
          autofocus: true,
          onChanged: (value) => setState(() => _query = value),
        ),
        titleSpacing: 0,
      ),
      body: !hasQuery
          ? const EmptyStateWidget(
              icon: Icons.search,
              title: 'Search for brands',
              subtitle:
                  'Find gift vouchers from your favourite brands and categories.',
            )
          : !hasResults
              ? EmptyStateWidget(
                  icon: Icons.search_off,
                  title: 'No results found',
                  subtitle: 'Try searching with a different keyword like "food" or "Amazon".',
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (categories.isNotEmpty) ...[
                      Text('Categories', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.map((category) {
                          return ActionChip(
                            label: Text(category.name),
                            onPressed: () {
                              final brand = _repository
                                  .getBrandsByCategory(category.id)
                                  .firstOrNull;
                              if (brand != null) {
                                context.push('/voucher/${brand.id}');
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (brands.isNotEmpty) ...[
                      Text('Brands', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      ...brands.map(
                        (brand) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: VoucherCard(
                            brand: brand,
                            compact: true,
                            onTap: () => context.push('/voucher/${brand.id}'),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
    );
  }
}
