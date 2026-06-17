import '../models/models.dart';
import '../static/static_data.dart';

class VoucherRepository {
  const VoucherRepository();

  List<Category> getCategories() => StaticData.categories;

  List<Brand> getBrands() => StaticData.brands;

  Brand? getBrandById(String id) {
    try {
      return StaticData.brands.firstWhere((brand) => brand.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Brand> getTrendingBrands() =>
      StaticData.brands.where((brand) => brand.isTrending).toList();

  List<Brand> getPopularBrands() =>
      StaticData.brands.where((brand) => brand.isPopular).toList();

  List<Brand> getBrandsByCategory(String categoryId) =>
      StaticData.brands.where((brand) => brand.categoryId == categoryId).toList();

  List<Brand> searchBrands(String query) {
    if (query.trim().isEmpty) return [];
    final normalized = query.toLowerCase().trim();
    return StaticData.brands
        .where((brand) => brand.name.toLowerCase().contains(normalized))
        .toList();
  }

  List<Category> searchCategories(String query) {
    if (query.trim().isEmpty) return [];
    final normalized = query.toLowerCase().trim();
    return StaticData.categories
        .where((category) => category.name.toLowerCase().contains(normalized))
        .toList();
  }

  List<PromoBanner> getPromoBanners() => StaticData.promoBanners;
}
