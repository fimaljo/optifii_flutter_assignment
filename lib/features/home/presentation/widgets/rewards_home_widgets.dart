import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../shared/widgets/brand_image.dart';

/// Horizontal brand card matching Figma Trending / Popular Brands sections.
class BrandHorizontalCard extends StatelessWidget {
  const BrandHorizontalCard({
    super.key,
    required this.brand,
    this.onTap,
    this.width = 148,
  });

  final Brand brand;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.brandColors[brand.id] ?? AppColors.primary;

    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BrandImage(
                  brand: brand,
                  height: 100,
                  width: width,
                  fit: BoxFit.cover,
                  backgroundColor: brand.logoAsset != null ? null : bgColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                  decoration: const BoxDecoration(
                    color: AppColors.cardFooter,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        brand.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${brand.discountPercent.toStringAsFixed(0)}% off',
                            style: const TextStyle(
                              color: AppColors.discountGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PromoBannerSlide extends StatelessWidget {
  const _PromoBannerSlide({required this.banner});

  final PromoBanner banner;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AppAssetImage(
        assetPath: banner.imageAsset,
        height: 156,
        width: double.infinity,
        fit: BoxFit.cover,
        fallback: _MakeMyTripFallback(
          title: banner.title,
          subtitle: banner.subtitle,
        ),
      ),
    );
  }
}

class _MakeMyTripFallback extends StatelessWidget {
  const _MakeMyTripFallback({this.title, this.subtitle});

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFBDE4FF), Color(0xFFF5FAFF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: 0,
            top: 20,
            child: Icon(
              Icons.flight,
              size: 110,
              color: Colors.grey.shade400.withValues(alpha: 0.6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  title ?? 'Up To 1500 OFF',
                  style: const TextStyle(
                    color: AppColors.makeMyTripBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle ?? 'On First Flight Booking',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// MakeMyTrip-style promo carousel with page dots.
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  static const _pageCount = 4;

  late final PageController _controller = PageController(initialPage: 1);
  int _page = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = context.watch<MarketplaceProvider>().promoBanners;

    return Column(
      children: [
        SizedBox(
          height: 156,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: _pageCount,
            itemBuilder: (context, index) {
              if (banners.isEmpty) {
                return const _MakeMyTripFallback();
              }
              return _PromoBannerSlide(banner: banners[index % banners.length]);
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_pageCount, (i) {
            final active = i == _page;
            return Container(
              width: active ? 8 : 6,
              height: active ? 8 : 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? AppColors.textPrimary
                    : AppColors.textPrimary.withValues(alpha: 0.35),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// OptiFii "Make Every Gift Feel Special" promo banner.
class OptifiiGiftBanner extends StatelessWidget {
  const OptifiiGiftBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.optifiiPurpleDark, AppColors.optifiiPurple],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OptiFii',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.3,
                          ),
                          children: [
                            TextSpan(text: 'Make Every Gift\n'),
                            TextSpan(
                              text: 'Feel Special',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            child: Text(
                              'Explore now',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AppAssetImage(
                  assetPath: AppAssets.promo('optifii_gift'),
                  width: 90,
                  height: 130,
                  fit: BoxFit.contain,
                  fallback: _PhoneMockup(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.optifiiPurple.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Hey Tanish,\nVinay Sent\nyou a gift.',
              style: TextStyle(color: Colors.white, fontSize: 7, height: 1.3),
            ),
          ),
          const Spacer(),
          Container(
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.pink, AppColors.optifiiPurple],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}

class RewardsSectionHeader extends StatelessWidget {
  const RewardsSectionHeader({
    super.key,
    required this.title,
    this.onExplore,
  });

  final String title;
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onExplore,
          child: const Text(
            'Explore >',
            style: TextStyle(
              color: AppColors.link,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class RewardsHomeHeader extends StatelessWidget {
  const RewardsHomeHeader({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          const Text(
            'Rewards',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Material(
            color: AppColors.glassFill,
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.glassBorder),
            ),
            child: InkWell(
              onTap: onMenuTap,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.menu, color: AppColors.textPrimary, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  final List<Category> categories;
  final ValueChanged<Category>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _HomeChip(
            label: category.name,
            onTap: () => onCategoryTap?.call(category),
          );
        },
      ),
    );
  }
}

class _HomeChip extends StatelessWidget {
  const _HomeChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.chipFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontalBrandList extends StatelessWidget {
  const HorizontalBrandList({
    super.key,
    required this.brands,
    required this.onBrandTap,
  });

  final List<Brand> brands;
  final ValueChanged<Brand> onBrandTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return BrandHorizontalCard(
            brand: brand,
            onTap: () => onBrandTap(brand),
          );
        },
      ),
    );
  }
}
