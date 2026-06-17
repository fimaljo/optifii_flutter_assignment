import 'package:flutter/foundation.dart' hide Category;

import '../data/models/models.dart';
import '../data/repositories/voucher_repository.dart';

/// Catalog state for home, search, and browse flows.
/// UI reads from here instead of constructing [VoucherRepository] in widgets.
class MarketplaceProvider extends ChangeNotifier {
  MarketplaceProvider({required VoucherRepository repository})
      : _repository = repository;

  final VoucherRepository _repository;

  static const filterCategoryIds = [
    'quick_commerce',
    'entertainment',
    'fashion',
    'electronics',
  ];

  List<Category> get categories => _repository.getCategories();

  List<Brand> get trendingBrands => _repository.getTrendingBrands();

  List<Brand> get popularBrands => _repository.getPopularBrands();

  List<PromoBanner> get promoBanners => _repository.getPromoBanners();

  List<Category> get filterCategories => filterCategoryIds
      .map((id) => categories.where((c) => c.id == id).firstOrNull)
      .whereType<Category>()
      .toList();

  Brand? getBrandById(String id) => _repository.getBrandById(id);

  List<Brand> getBrandsByCategory(String categoryId) =>
      _repository.getBrandsByCategory(categoryId);

  List<Brand> searchBrands(String query) => _repository.searchBrands(query);

  List<Category> searchCategories(String query) =>
      _repository.searchCategories(query);
}
