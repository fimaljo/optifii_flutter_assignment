import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../shared/widgets/figma_widgets.dart';
import '../widgets/rewards_home_widgets.dart';

class RewardsMarketplacePage extends StatelessWidget {
  const RewardsMarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final marketplace = context.watch<MarketplaceProvider>();

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
              child: SearchFieldWidget(
                hintText: 'Search Brands/ Categories',
                readOnly: true,
                onTap: () => context.push('/search'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HomeCategoryChips(categories: marketplace.filterCategories),
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
              brands: marketplace.trendingBrands,
              onBrandTap: (brand) => _openVoucher(context, brand),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: OptifiiGiftBanner(
                onTap: () {
                  final trending = marketplace.trendingBrands;
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
              brands: marketplace.popularBrands,
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
