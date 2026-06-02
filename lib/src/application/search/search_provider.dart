import 'dart:developer';

import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/domain/notification/i_notification_repo.dart';
import 'package:customer_core/src/domain/store/models/product_details_model.dart';
// import 'package:customer_core/src/domain/search/model/search_model.dart';
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

//  Future<void> getFavouriteProductList() async {
//     try {
//       final isLogged = await sharedPrefsRepository.getUserData() != null;
//       if (!isLogged) return;
//       _favouriteProductResponse = APIResponse.loading();
//       notifyListeners();
//       final response = await storeRepo.getFavouriteProductList();
//       return response.fold((error) {
//         AlertDialogs.showError(error.message);
//         _favouriteProductResponse =
//             APIResponse.error(error.message, exception: error);
//         notifyListeners();
//       }, (favouriteList) {
//         final list = favouriteList.favouriteList?.productList ?? [];
//         final modifiedList = list
//             .map(
//               (product) => product.copyWith(
//                 isFavourite: true,
//               ),
//             )
//             .toList();
//         final modifiedFavouriteList = FavouriteProductRawDataModel(
//           favouriteList: FavouriteProductDataModel(
//             productList: modifiedList,
//           ),
//         );
//         _favouriteProductResponse =
//             APIResponse.completed(modifiedFavouriteList);

//         notifyListeners();
//       });
//     } finally {}
//   }

  Future<bool> addFavourite(String productID) async {
    // Optimistic Update
    updateProductFavouriteLocally(productID, true, "temp");
    notifyListeners();

    try {
      final response = await searchRepo.addFavourite(productID: productID);

      return response.fold((error) {
        // Revert on error
        updateProductFavouriteLocally(productID, false, "");
        AlertDialogs.showError(error.message);
        notifyListeners();
        return false;
      }, (data) {
        final favouriteId = data['favouriteID'] ?? "";
        // Update with actual favouriteID
        updateProductFavouriteLocally(productID, true, favouriteId.toString());
        notifyListeners();
        return true;
      });
    } catch (e) {
      inspect(e);
      // Revert on error
      updateProductFavouriteLocally(productID, false, "");
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavourite(String productID) async {
    // Optimistic Update
    updateProductFavouriteLocally(productID, false, "", isByFavID: true);
    notifyListeners();

    try {
      final response = await searchRepo.removeFavourite(productID: productID);

      return response.fold((error) {
        AlertDialogs.showError(error.message);

        productsProvider
            .getFavouriteProductList(); // Revert by fetching correct state
        return false;
      }, (message) {
        return true;
      });
    } catch (e) {
      productsProvider
          .getFavouriteProductList(); // Revert by fetching correct state
      return false;
    }
  }

  /// Update a product's favourite state locally in the search results list
  void updateProductFavouriteLocally(
      String productID, bool isFavourite, String favouriteId,
      {bool isByFavID = false}) {
    if (_searchResponse == null) return;

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
