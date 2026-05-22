import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/domain/store/models/product_details_model.dart';
// import 'package:customer_core/src/domain/search/model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/search/i_search_repo.dart';

@LazySingleton()
class SearchProvider extends ChangeNotifier with BaseController {
  final ISearchRepo searchRepo;
  SearchProvider({required this.searchRepo});

  final _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  bool _isSearchLoading = false;

  bool get isSearchLoading => _isSearchLoading;

  List<ProductDataModel>? _searchResponse;

  List<ProductDataModel>? get searchResponse => _searchResponse;

  // List<ProductDataModel> get searchProductsList => _searchResponse ?? [];

  String previousSearchKey = '';

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
        _searchResponse = result;
      });
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  /// Update a product's favourite state locally in the search results list
  void updateProductFavouriteLocally(String productID, bool isFavourite, String favouriteId,
      {bool isByFavID = false}) {
    if (_searchResponse == null) return;

    bool updateCondition(ProductDataModel p) =>
        isByFavID ? p.favouriteID == productID : p.pID == productID;

    final index = _searchResponse!.indexWhere(updateCondition);
    if (index != -1) {
      _searchResponse![index] = _searchResponse![index].copyWith(
        isFavourite: isFavourite,
        favouriteID: favouriteId,
      );
      notifyListeners();
    }
  }

  void clearSearchData() {
    _searchResponse = null;
    previousSearchKey = '';
    notifyListeners();
  }
}