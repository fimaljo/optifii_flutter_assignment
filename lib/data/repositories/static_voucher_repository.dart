import '../models/models.dart';
import '../static/static_data.dart';
import 'voucher_repository.dart';

/// Static catalog backed by local data. Swap for an API repository in production.
class StaticVoucherRepository implements VoucherRepository {
  const StaticVoucherRepository();

  @override
  List<Category> getCategories() => StaticData.categories;

  @override
  List<Brand> getBrands() => StaticData.brands;

  @override
  Brand? getBrandById(String id) {
    try {
      return StaticData.brands.firstWhere((brand) => brand.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Brand> getTrendingBrands() =>
      StaticData.brands.where((brand) => brand.isTrending).toList();

  @override
  List<Brand> getPopularBrands() =>
      StaticData.brands.where((brand) => brand.isPopular).toList();

  @override
  List<Brand> getBrandsByCategory(String categoryId) => StaticData.brands
      .where((brand) => brand.categoryId == categoryId)
      .toList();

  @override
  List<Brand> searchBrands(String query) {
    if (query.trim().isEmpty) return [];
    final normalized = query.toLowerCase().trim();
    return StaticData.brands
        .where((brand) => brand.name.toLowerCase().contains(normalized))
        .toList();
  }

  @override
  List<Category> searchCategories(String query) {
    if (query.trim().isEmpty) return [];
    final normalized = query.toLowerCase().trim();
    return StaticData.categories
        .where((category) => category.name.toLowerCase().contains(normalized))
        .toList();
  }

  @override
  List<PromoBanner> getPromoBanners() => StaticData.promoBanners;
}
