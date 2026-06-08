import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/domain/store/models/product_details_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/search/i_search_repo.dart';

@LazySingleton()
class SearchProvider extends ChangeNotifier with BaseController {
  final ISearchRepo searchRepo;
  final ProductsProvider productsProvider;

  SearchProvider({
    required this.searchRepo,
    required this.productsProvider,
  });

  final _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  bool _isSearchLoading = false;

  bool get isSearchLoading => _isSearchLoading;

  List<ProductDataModel> _searchResponse = [];

  List<ProductDataModel>? get searchResponse => _searchResponse;
  String previousSearchKey = '';

  @override
  Future<void> init() {
    getAllSearchProducts('');
    return super.init();
  }

  Future<void> getAllSearchProducts(String searchKey) async {
    if (searchKey == previousSearchKey) return;
    try {
      _isSearchLoading = true;
      notifyListeners();
      final response =
          await searchRepo.getAllSearchProducts(searchKey: searchKey);

      response.fold((error) {
        return error;
      }, (result) async {
        previousSearchKey = searchKey;
        final favouriteList = productsProvider
                .favouriteProductResponse.data?.favouriteList?.productList ??
            [];
        Map<String?, String?> favIdMap = {
          for (final item in favouriteList) item.pID: item.favouriteID,
        };
        final updatedSearchList = result.map((product) {
          final favId = favIdMap[product.pID];

          return product.copyWith(
            isFavourite: favId != null,
            favouriteID: favId ?? "",
          );
        }).toList();
        _searchResponse = updatedSearchList;
        notifyListeners();
      });
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  /// Update a product's favourite state locally in the search results list
  void updateProductFavouriteLocally(
      String productID, bool isFavourite, String favouriteId,
      {bool isByFavID = false}) {
    bool updateCondition(ProductDataModel p) =>
        isByFavID ? p.favouriteID == productID : p.pID == productID;
    final index = _searchResponse.indexWhere(updateCondition);
    if (index != -1) {
      _searchResponse[index] = _searchResponse[index].copyWith(
        isFavourite: isFavourite,
        favouriteID: favouriteId,
      );
      notifyListeners();
    }
  }

  void clearSearchData() {
    _searchResponse = [];
    previousSearchKey = '';
    notifyListeners();
  }
}
