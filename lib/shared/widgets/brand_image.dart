import 'package:flutter/material.dart';

import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/models.dart';

/// Loads a brand logo from assets, with automatic letter fallback if the file is missing.
///
/// Add your image here: `assets/brands/{brand.id}.png`
/// Example: `assets/brands/flipkart.png`
class BrandImage extends StatelessWidget {
  const BrandImage({
    super.key,
    required this.brand,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  final Brand brand;
  final double? width;
  final double? height;

  /// Shorthand — sets width & height together.
  final double? size;
  final BoxFit fit;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final w = size ?? width;
    final h = size ?? height;
    final hasAsset = brand.logoAsset != null;
    final bg = hasAsset
        ? Colors.transparent
        : (backgroundColor ?? AppColors.brandColors[brand.id] ?? AppColors.primary);
    final radius = borderRadius ?? BorderRadius.circular((w ?? h ?? 48) * 0.2);
    final assetPath = brand.logoAsset ?? AppAssets.brandLogo(brand.id);
    final imageFit = hasAsset && (w != null || h != null) ? BoxFit.cover : fit;

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: w,
        height: h,
        color: bg,
        padding: hasAsset ? EdgeInsets.zero : padding,
        alignment: Alignment.center,
        child: _AssetImageWithFallback(
          assetPath: assetPath,
          width: w,
          height: h,
          fit: imageFit,
          fallback: BrandAvatarFallback(
            brand: brand,
            size: w ?? h ?? 48,
            onColoredBackground: hasAsset,
          ),
        ),
      ),
    );
  }
}

/// Generic asset image — shows [fallback] when file is not found.
class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
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
      errorBuilder: (_, __, ___) {
        // Try .jpg if .png missing
        if (assetPath.endsWith('.png')) {
          return Image.asset(
            assetPath.replaceAll('.png', '.jpg'),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => fallback,
          );
        }
        return fallback;
      },
    );
  }
}

/// Letter-based fallback when no image file exists.
class BrandAvatarFallback extends StatelessWidget {
  const BrandAvatarFallback({
    super.key,
    required this.brand,
    this.size = 48,
    this.fontSize,
    this.onColoredBackground = false,
  });

  final Brand brand;
  final double size;
  final double? fontSize;
  final bool onColoredBackground;

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

    if (onColoredBackground) {
      return Text(
        mark,
        style: TextStyle(
          color: logoColor,
          fontSize: fontSize ?? (brand.id == 'lifestyle' ? 22 : 36),
          fontWeight: FontWeight.w800,
          fontStyle: brand.id == 'lifestyle' ? FontStyle.italic : FontStyle.normal,
        ),
      );
    }

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

/// Backwards-compatible alias — now loads image if available.
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
      padding: const EdgeInsets.all(6),
      backgroundColor: AppColors.brandColors[brand.id]?.withValues(alpha: 0.15),
    );
  }
}
