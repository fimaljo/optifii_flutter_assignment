/// Central place for all image paths.
///
/// Drop your files into the matching folder using the names below.
/// Supported formats: `.png`, `.jpg`, `.webp` (prefer PNG with transparent bg for logos).
abstract final class AppAssets {
  static const brands = 'assets/brands';
  static const banners = 'assets/banners';
  static const promos = 'assets/promos';
  static const giftThemes = 'assets/gift_themes';

  /// Brand logo — save as `assets/brands/{brandId}.png`
  /// Example: assets/brands/flipkart.png
  static String brandLogo(String brandId, {String ext = 'png'}) =>
      '$brands/$brandId.$ext';

  /// Home carousel banner — save as `assets/banners/{name}.png`
  /// Example: assets/banners/makemytrip.png
  static String banner(String name, {String ext = 'png'}) =>
      '$banners/$name.$ext';

  /// Promo card image — save as `assets/promos/{name}.png`
  /// Example: assets/promos/optifii_gift.png
  static String promo(String name, {String ext = 'png'}) =>
      '$promos/$name.$ext';

  /// Gift theme preview — save as `assets/gift_themes/{theme}.png`
  /// Example: assets/gift_themes/birthday.png
  static String giftTheme(String theme, {String ext = 'png'}) =>
      '$giftThemes/$theme.$ext';

  /// All brand IDs used in the app (filename must match id).
  static const brandIds = [
    'flipkart',
    'amazon',
    'swiggy',
    'zomato',
    'myntra',
    'nykaa',
    'bigbasket',
    'dominos',
    'lifestyle',
  ];
}
