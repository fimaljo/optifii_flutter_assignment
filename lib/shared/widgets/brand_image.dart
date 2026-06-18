import 'package:flutter/material.dart';

import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/models.dart';

class BrandImage extends StatelessWidget {
  const BrandImage({
    super.key,
    required this.brand,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.contain,
    this.borderRadius,
  });

  final Brand brand;
  final double? width;
  final double? height;
  final double? size;
  final BoxFit fit;
  
  final BorderRadius? borderRadius;
@override
Widget build(BuildContext context) {
  final w = size ?? width ?? 48;
  final h = size ?? height ?? 48;

 

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: w,
      height: h,
      
      decoration: BoxDecoration(
        color:brand.brandColor,
        borderRadius:
          BorderRadius.circular( 10),
      ),
      padding: EdgeInsets.all(w * 0.18),
      alignment: Alignment.center,
      child: _AssetImageWithFallback(
        assetPath: brand.logoAsset ?? AppAssets.brandLogo(brand.id),
        fit: BoxFit.contain,
        fallback: BrandAvatarFallback(
          brand: brand,
          size: w,
        ),
      ),
    ),
  );
}}
/// Generic asset image with fallback.
class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    required this.fallback,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    return _AssetImageWithFallback(
      assetPath: assetPath,
      width: width,
      height: height,
      fit: fit,
      fallback: fallback,
    );
  }
}

class _AssetImageWithFallback extends StatelessWidget {
  const _AssetImageWithFallback({
    required this.assetPath,
    required this.fallback,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String assetPath;
  final Widget fallback;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) {
        if (assetPath.endsWith('.png')) {
          return Image.asset(
            assetPath.replaceAll('.png', '.jpg'),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, _, _) => fallback,
          );
        }

        return fallback;
      },
    );
  }
}

/// Letter fallback when no logo image exists.
class BrandAvatarFallback extends StatelessWidget {
  const BrandAvatarFallback({
    super.key,
    required this.brand,
    this.size = 48,
    this.fontSize,
  });

  final Brand brand;
  final double size;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.brandColors[brand.id] ?? AppColors.primary;
    final logoColor = AppColors.brandLogoColors[brand.id] ?? color;

    final mark = switch (brand.id) {
      'flipkart' => 'f',
      'swiggy' => 'S',
      'amazon' => 'a',
      'bigbasket' => 'bb',
      'lifestyle' => 'lifestyle',
      _ => brand.name.characters.first.toUpperCase(),
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      alignment: Alignment.center,
      child: Text(
        mark,
        style: TextStyle(
          color: logoColor,
          fontWeight: FontWeight.w700,
          fontSize: fontSize ?? size * 0.38,
        ),
      ),
    );
  }
}

/// Backwards-compatible alias.
class BrandAvatar extends StatelessWidget {
  const BrandAvatar({
    super.key,
    required this.brand,
    this.size = 48,
    this.fontSize,
  });

  final Brand brand;
  final double size;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return BrandImage(
      brand: brand,
      size: size,
    );
  }
}