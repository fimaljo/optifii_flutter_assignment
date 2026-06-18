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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.brandCardBackground,
        border: Border.all(color: AppColors.glassBorder.withValues(alpha: 0.2)),
      ),
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BrandImage(
                brand: brand,
                height: 100,
                width: width,
                fit: BoxFit.cover,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                  decoration: const BoxDecoration(
                    color: AppColors.brandCardBackground,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                          //  / const SizedBox(height: 4),
                          Text(
                            '${brand.discountPercent.toStringAsFixed(0)}% off',
                            style: const TextStyle(
                              color: AppColors.discountGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/// MakeMyTrip-style promo banner slide.
class _PromoBannerSlide extends StatelessWidget {
  const _PromoBannerSlide({
    required this.banner,
  });

  final PromoBanner banner;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox.expand(
        child: Image.asset(
          banner.imageAsset,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return _MakeMyTripFallback(
              title: banner.title,
              subtitle: banner.subtitle,
            );
          },
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
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  static const _pageCount = 4;

  late final PageController _controller = PageController();
  int _page = 0;

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
          width: double.infinity,
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: _pageCount,
            onPageChanged: (index) {
              setState(() {
                _page = index;
              });
            },
            itemBuilder: (context, index) {
              if (banners.isEmpty) {
                return const _MakeMyTripFallback();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _PromoBannerSlide(
                  banner: banners[index % banners.length],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _pageCount,
            (index) {
              final active = _page == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: active ? 8 : 6,
                height: active ? 8 : 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                ),
              );
            },
          ),
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
      height: 240,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          /// Background image
          Positioned.fill(
            child: Image.asset(
              AppAssets.promo('optifii_banner_bg'),
              fit: BoxFit.cover,
            ),
          ),

          /// Optional dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: .12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Logo
                        Image.asset(
                          AppAssets.promo('optifii_logo_white'),
                          height: 26,
                        ),

                        const Spacer(),

                        const Text(
                          'Make Every Gift',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1,
                            fontWeight: FontWeight.w300,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'Feel Special',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            height: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 24),

                        InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'Explore now',
                              style: TextStyle(
                                color: Color(0xff1F1F1F),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),
              ],
            ),
          ),

          /// Phone Mockup
          Positioned(
            right: -10,
            top: 10,
            bottom: 0,
            child: Image.asset(
              AppAssets.promo('optifii_phone_mockup'),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class RewardsSectionHeader extends StatelessWidget {
  const RewardsSectionHeader({super.key, required this.title, this.onExplore});

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
              fontSize: 22,
              fontWeight: FontWeight.w400,
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
        separatorBuilder: (_, _) => const SizedBox(width: 10),
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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder.withValues(alpha: 0.1)),
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
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: brands.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
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
