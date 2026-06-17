import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/models.dart';
import '../../../../data/repositories/voucher_repository.dart';
import '../../../../shared/widgets/figma_widgets.dart';
import '../widgets/rewards_home_widgets.dart';

class RewardsMarketplacePage extends StatelessWidget {
  const RewardsMarketplacePage({super.key});

  static const _homeCategoryIds = [
    'quick_commerce',
    'entertainment',
    'fashion',
    'electronics',
  ];

  @override
  Widget build(BuildContext context) {
    const repository = VoucherRepository();
    final allCategories = repository.getCategories();
    final homeCategories = _homeCategoryIds
        .map((id) => allCategories.where((c) => c.id == id).firstOrNull)
        .whereType<Category>()
        .toList();
    final trending = repository.getTrendingBrands();
    final popular = repository.getPopularBrands();

    return DarkScaffold(
      safeArea: true,
      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: RewardsHomeHeader(
                onMenuTap: () => context.push('/orders'),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: FigmaSearchField(
                  hintText: 'Search Brands/ Categories',
                  readOnly: true,
                  onTap: () => context.push('/search'),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HomeCategoryChips(categories: homeCategories),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: const PromoCarousel(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
                child: const RewardsSectionHeader(title: 'Trending Brands'),
              ),
            ),
            SliverToBoxAdapter(
              child: HorizontalBrandList(
                brands: trending,
                onBrandTap: (brand) => _openVoucher(context, brand),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: OptifiiGiftBanner(
                  onTap: () {
                    if (trending.isNotEmpty) {
                      _openVoucher(context, trending.first);
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: const RewardsSectionHeader(title: 'Popular Brands'),
              ),
            ),
            SliverToBoxAdapter(
              child: HorizontalBrandList(
                brands: popular,
                onBrandTap: (brand) => _openVoucher(context, brand),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
    );
  }

  void _openVoucher(BuildContext context, Brand brand) {
    context.push('/voucher/${brand.id}');
  }
}
