import 'package:flutter_test/flutter_test.dart';
import 'package:optifii_flutter_assignment/data/models/models.dart';
import 'package:optifii_flutter_assignment/data/repositories/voucher_repository.dart';
import 'package:optifii_flutter_assignment/providers/marketplace_provider.dart';

class _FakeVoucherRepository implements VoucherRepository {
  @override
  List<Category> getCategories() => const [
        Category(id: 'food', name: 'Food', iconName: 'restaurant'),
      ];

  @override
  List<Brand> getBrands() => const [
        Brand(
          id: 'swiggy',
          name: 'Swiggy',
          categoryId: 'food',
          discountPercent: 6,
          startingPrice: 100,
          validityMonths: 6,
          description: 'Food delivery',
          termsAndConditions: [],
          howToRedeem: [],
          isTrending: true,
        ),
      ];

  @override
  Brand? getBrandById(String id) =>
      getBrands().where((brand) => brand.id == id).firstOrNull;

  @override
  List<Brand> getTrendingBrands() =>
      getBrands().where((brand) => brand.isTrending).toList();

  @override
  List<Brand> getPopularBrands() =>
      getBrands().where((brand) => brand.isPopular).toList();

  @override
  List<Brand> getBrandsByCategory(String categoryId) => getBrands()
      .where((brand) => brand.categoryId == categoryId)
      .toList();

  @override
  List<Brand> searchBrands(String query) {
    if (query.trim().isEmpty) return [];
    return getBrands()
        .where((brand) => brand.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  List<Category> searchCategories(String query) {
    if (query.trim().isEmpty) return [];
    return getCategories()
        .where((category) => category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  List<PromoBanner> getPromoBanners() => const [];
}

void main() {
  late MarketplaceProvider provider;

  setUp(() {
    provider = MarketplaceProvider(repository: _FakeVoucherRepository());
  });

  test('exposes trending brands from repository', () {
    expect(provider.trendingBrands, hasLength(1));
    expect(provider.trendingBrands.first.name, 'Swiggy');
  });

  test('searches brands through repository', () {
    expect(provider.searchBrands('swig'), hasLength(1));
    expect(provider.searchBrands(''), isEmpty);
  });

  test('resolves brand by id', () {
    expect(provider.getBrandById('swiggy')?.name, 'Swiggy');
    expect(provider.getBrandById('missing'), isNull);
  });
}
