import '../models/models.dart';

/// Contract for voucher catalog access. UI and providers depend on this,
/// not on [StaticData], so a remote API can replace the static implementation.
abstract interface class VoucherRepository {
  List<Category> getCategories();

  List<Brand> getBrands();

  Brand? getBrandById(String id);

  List<Brand> getTrendingBrands();

  List<Brand> getPopularBrands();

  List<Brand> getBrandsByCategory(String categoryId);

  List<Brand> searchBrands(String query);

  List<Category> searchCategories(String query);

  List<PromoBanner> getPromoBanners();
}
