import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/models.dart';
import '../../../../data/repositories/voucher_repository.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/voucher_card.dart';

class RewardsMarketplacePage extends StatefulWidget {
  const RewardsMarketplacePage({super.key});

  @override
  State<RewardsMarketplacePage> createState() => _RewardsMarketplacePageState();
}

class _RewardsMarketplacePageState extends State<RewardsMarketplacePage> {
  final _repository = const VoucherRepository();
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final categories = _repository.getCategories();
    final trending = _repository.getTrendingBrands();
    final popular = _repository.getPopularBrands();
    final filteredBrands = _selectedCategoryId == null
        ? _repository.getBrands()
        : _repository.getBrandsByCategory(_selectedCategoryId!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'Order History',
            onPressed: () => context.push('/orders'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover gift vouchers\nfrom top brands',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  AppSearchBar(
                    hintText: 'Search brands or categories',
                    readOnly: true,
                    onTap: () => context.push('/search'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text('Categories', style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return FilterChip(
                      label: const Text('All'),
                      selected: _selectedCategoryId == null,
                      onSelected: (_) => setState(() => _selectedCategoryId = null),
                    );
                  }
                  final category = categories[index - 1];
                  return FilterChip(
                    label: Text(category.name),
                    selected: _selectedCategoryId == category.id,
                    onSelected: (_) =>
                        setState(() => _selectedCategoryId = category.id),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: SectionHeader(title: 'Trending Brands'),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: trending.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final brand = trending[index];
                  return TrendingBrandChip(
                    brand: brand,
                    onTap: () => _openVoucherDetails(context, brand),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: SectionHeader(title: 'Popular Brands'),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final brand = popular[index];
                  return VoucherCard(
                    brand: brand,
                    onTap: () => _openVoucherDetails(context, brand),
                  );
                },
                childCount: popular.length,
              ),
            ),
          ),
          if (_selectedCategoryId != null) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SectionHeader(
                  title: categories
                      .firstWhere((c) => c.id == _selectedCategoryId)
                      .name,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.separated(
                itemCount: filteredBrands.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final brand = filteredBrands[index];
                  return VoucherCard(
                    brand: brand,
                    compact: true,
                    onTap: () => _openVoucherDetails(context, brand),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openVoucherDetails(BuildContext context, Brand brand) {
    context.push('/voucher/${brand.id}');
  }
}
