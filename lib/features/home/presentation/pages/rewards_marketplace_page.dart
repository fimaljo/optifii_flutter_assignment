import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/models.dart';
import '../../../../data/repositories/voucher_repository.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/figma_widgets.dart';
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

    return DarkScaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => context.push('/orders'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: AppSearchBar(
                hintText: 'Search brands, categories...',
                readOnly: true,
                onTap: () => context.push('/search'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CategoryChipRow(
                categories: categories,
                selectedId: _selectedCategoryId,
                onSelected: (id) => setState(() => _selectedCategoryId = id),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const HeroPromoBanner(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SectionHeader(
                title: 'Trending Brands',
                actionLabel: 'Explore >',
                onActionTap: () {},
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final brand = trending[index];
                  return BrandLogoTile(
                    brand: brand,
                    onTap: () => _openVoucher(context, brand),
                  );
                },
                childCount: trending.length.clamp(0, 4),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GiftPromoCard(
                onTap: () {
                  if (trending.isEmpty && popular.isEmpty) return;
                  final brand = trending.isNotEmpty ? trending.first : popular.first;
                  _openVoucher(context, brand);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text('Popular Brands', style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final brand = popular[index];
                  return VoucherCard(
                    brand: brand,
                    onTap: () => _openVoucher(context, brand),
                  );
                },
                childCount: popular.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openVoucher(BuildContext context, Brand brand) {
    context.push('/voucher/${brand.id}');
  }
}
