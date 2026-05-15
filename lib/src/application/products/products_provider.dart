import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/core/api_response.dart';
import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/domain/store/i_store_repo.dart';
import 'package:customer_core/src/domain/store/models/favourite_product_data_model.dart';
import 'package:customer_core/src/domain/store/models/featured_popular_products_data_model.dart';
import 'package:customer_core/src/domain/store/models/product_category_model.dart';
import 'package:injectable/injectable.dart';
import 'package:customer_core/src/domain/user/i_user_shared_prefs.dart';

import '../../domain/store/models/product_details_model.dart';
// enum FoodType { nonVeg, veg }

@LazySingleton()
class ProductsProvider extends ChangeNotifier with BaseController {
  final IStoreRepo storeRepo;
  final IUserSharedPrefsRepo sharedPrefsRepository;

  ProductsProvider(
      {required this.storeRepo, required this.sharedPrefsRepository});
  Random random = Random();

  var _productsListAPIResponse = APIResponse<List<ProductDataModel>>.initial();

  APIResponse<List<ProductDataModel>> get productsListAPIResponse =>
      _productsListAPIResponse;

  var _featuredPopularProductsAPIResponse =
      APIResponse<FeaturedPopularProductsDataModel>.initial();

  APIResponse<FeaturedPopularProductsDataModel>
      get featuredPopularProductsAPIResponse =>
          _featuredPopularProductsAPIResponse;

  List<ProductDataModel> get productsList =>
      _productsListAPIResponse.data ?? [];

  List<ProductDataModel> _productsCollection = [];

  List<ProductDataModel> productsListRandom = [];

  var _categoriesListAPIResponse = APIResponse<List<CategoryData>>.initial();

  APIResponse<List<CategoryData>> get categoriesListAPIResponse =>
      _categoriesListAPIResponse;

  bool get categoryLoadingAndProductEmpty =>
      categoriesListAPIResponse == APIResponse<List<CategoryData>>.loading() &&
      _productsListAPIResponse.data == null;

  APIResponse<FavouriteProductRawDataModel> _favouriteProductResponse =
      APIResponse<FavouriteProductRawDataModel>.initial();

  APIResponse<FavouriteProductRawDataModel> get favouriteProductResponse =>
      _favouriteProductResponse;

  List<CategoryData> get categories => _categoriesListAPIResponse.data ?? [];

  CategoryData? _selectedCategory;
  CategoryData? get selectedCategory => _selectedCategory;

  CategoryData? _selectedSubCategory;
  CategoryData? get selectedSubCategory => _selectedSubCategory;

  int? _selectedCategoryIndex;

  int? get selectedCategoryIndex => _selectedCategoryIndex;
  final Map<String, List<ProductDataModel>> _cachedProducts = {};

  int currentPageForPagination = 1;
  bool hasMoreProducts = true;
  bool isFetchingProductsFromPagination = false;

  // FoodType _selectedFoodType = FoodType.nonVeg;

  // FoodType get selectedFoodType => _selectedFoodType;

  // void onChangeFoodType(FoodType type) {
  //   _selectedFoodType = type;
  //   notifyListeners();
  // }

  @override
  Future<void> init() {
    // getAllProductsByPagination();
    getFeaturedPopularProducts();
    getFavouriteProductList();
    return super.init();
  }

  Future<void> getAllProductsByPagination({
    String categoryID = '0',
    String numberOfProducts = '30',
    bool isRandom = true,
    bool isRefresh = false,
  }) async {
    try {
      if (isFetchingProductsFromPagination || !hasMoreProducts) return;
      if (isRefresh) {
        currentPageForPagination = 1;
        hasMoreProducts = true;
        productsList.clear();
        _productsListAPIResponse = APIResponse.loading();
        notifyListeners();
      }

      isFetchingProductsFromPagination = true;
      notifyListeners();

      final response = await storeRepo.getProductsByPagination(
        categoryID: categoryID,
        numberOfProducts: numberOfProducts,
        pageNumber: currentPageForPagination.toString(),
      );
      response.fold((error) {
        _productsListAPIResponse = APIResponse.error(
          error.message,
          exception: error,
        );
        notifyListeners();
      }, (result) async {
        // List<ProductDataModel> products = await Future.wait(
        //   result.dataList.map(
        //     (product) async => product.copyWith(
        //       scheme: await getSchemeFromImage(product.photo),
        //     ),
        //   ),
        // );
        // final existingIds = productsList.map((p) => p.pID).toSet();

        // final list = result.dataList
        //     .where(
        //       (element) => !existingIds.contains(element.pID),
        //     )
        //     .toList();

        final newProducts = result.dataList;
        if (newProducts.length < int.parse(numberOfProducts)) {
          hasMoreProducts = false;
          isFetchingProductsFromPagination = false;
          _selectedSubCategory = null;

          notifyListeners();
        } else {
          currentPageForPagination++;
          // productsList = List.from(newProducts);
        }

        final list = [...productsList, ...newProducts];

        final favouriteList =
            favouriteProductResponse.data?.favouriteList?.productList ?? [];

// Build lookup: pID → favouriteID
        final favIdMap = {
          for (var item in favouriteList) item.pID: item.favouriteID,
        };

        final updatedList = list.map((product) {
          final favId = favIdMap[product.pID];
          return product.copyWith(
            isFavourite: favId != null,
            favouriteID: favId ?? "",
          );
        }).toList();

        _productsListAPIResponse = APIResponse.completed([...updatedList]);

        if (isRandom) {
          final newProductsModified = newProducts.map((product) {
            final favId = favIdMap[product.pID];
            return product.copyWith(
              isFavourite: favId != null,
              favouriteID: favId ?? "",
            );
          }).toList();
          productsListRandom = newProductsModified;
          productsListRandom.shuffle();
        }

        // var shuffledList = List<ProductDataModel>.from(_productsListAPIResponse.data!);
        // shuffledList.shuffle(random);
        // productsListRandom = shuffledList;
        isFetchingProductsFromPagination = false;

        notifyListeners();
      });
    } finally {
      isFetchingProductsFromPagination = false;
      _selectedSubCategory = null;

      notifyListeners();
    }
  }

  // Future<void> getAllProducts(String categoryID) async {
  //   _productsListAPIResponse = APIResponse.loading();
  //   notifyListeners();
  //   final response = await storeRepo.getProducts(categoryID: categoryID);
  //   response.fold((error) {
  //     _productsListAPIResponse = APIResponse.error(
  //       error.message,
  //       exception: error,
  //     );
  //     notifyListeners();
  //   }, (result){
  //     dev.log(result.items.length.toString(), name: "productsListLength");
  //     // print('Response data: ${result.items}');
  //     // List<ProductDataModel> products = await Future.wait(
  //     //   result.items.map(
  //     //     (product) async => product.copyWith(
  //     //       scheme: await getSchemeFromImage(product.photo),
  //     //     ),
  //     //   ),
  //     // );
  //     _productsListAPIResponse = APIResponse.completed(result.items);
  //     _productsCollection = result.items;
  //     notifyListeners();
  //   });
  // }

  void onChangeHasMoreProducts(bool value) {
    hasMoreProducts = value;
    notifyListeners();
  }

  Future<void> getFeaturedPopularProducts() async {
    _featuredPopularProductsAPIResponse = APIResponse.loading();
    notifyListeners();
    final response = await storeRepo.getFeaturedPopularProducts(
        shopID: AppIdentifiers.kShopId);
    response.fold((error) {
      _featuredPopularProductsAPIResponse = APIResponse.error(
        error.message,
        exception: error,
      );
      notifyListeners();
    }, (result) async {
      await getFavouriteProductList();
      final list = result.featuredProducts ?? [];
      final popularList = result.popularProducts ?? [];
      final favouriteList =
          favouriteProductResponse.data?.favouriteList?.productList ?? [];
      final favIdMap = {
        for (var item in favouriteList) item.pID: item.favouriteID,
      };
      final updatedList = list.map((product) {
        final favId = favIdMap[product.pID];
        return product.copyWith(
          isFavourite: favId != null,
          favouriteID: favId ?? "",
        );
      }).toList();
      final updatedPopularList = popularList.map((product) {
        final favId = favIdMap[product.pID];
        return product.copyWith(
          isFavourite: favId != null,
          favouriteID: favId ?? "",
        );
      }).toList();
      final newResult = result.copyWith(
          featuredProducts: updatedList, popularProducts: updatedPopularList);

      _featuredPopularProductsAPIResponse = APIResponse.completed(newResult);
      notifyListeners();
    });
  }

  Future<void> getAllProducts(String categoryID) async {
    // if (_cachedProducts.containsKey(categoryID)) {
    //   _productsCollection = _cachedProducts[categoryID]!;
    //   _productsListAPIResponse = APIResponse.completed(_productsCollection);
    //   notifyListeners();
    //   return;
    // }

    _productsListAPIResponse = APIResponse.loading();
    notifyListeners();

    final response = await storeRepo.getProducts(categoryID: categoryID);
    response.fold((error) {
      _productsListAPIResponse =
          APIResponse.error(error.message, exception: error);
      notifyListeners();
    }, (result) {
      final list = result.items;
      final favouriteList =
          favouriteProductResponse.data?.favouriteList?.productList ?? [];

// Build fav lookup: pID → favouriteID
      final favIdMap = {
        for (var item in favouriteList) item.pID: item.favouriteID,
      };

// Update products
      final updatedList = list.map((product) {
        final favId = favIdMap[product.pID];
        return product.copyWith(
          isFavourite: favId != null,
          favouriteID: favId ?? "",
        );
      }).toList();

      _cachedProducts[categoryID] = updatedList;
      _productsCollection = updatedList;
      _productsListAPIResponse = APIResponse.completed(updatedList);
      notifyListeners();
    });
  }

  Future<ColorScheme?> getSchemeFromImage(String? image) async {
    try {
      if (image == null) return null;
      return await ColorScheme.fromImageProvider(
        provider: CachedNetworkImageProvider(image),
      );
    } catch (e) {
      return null;
    }
  }

  // Future<void> getAllCategories() async {
  //   _categoriesListAPIResponse = APIResponse.loading();
  //   notifyListeners();
  //   final response = await storeRepo.getCategories();
  //   response.fold((error) {
  //     _categoriesListAPIResponse = APIResponse.error(
  //       error.message,
  //       exception: error,
  //     );
  //     notifyListeners();
  //   }, (result) async {
  //     _categoriesListAPIResponse = APIResponse.completed(result.items);
  //     notifyListeners();

  //     if (result.items == null) return;
  //     if (result.items?.first.cID != null) {
  //       await getAllProducts(result.items!.first.cID!);
  //       notifyListeners();
  //     }
  //   });
  // }

  Future<void> getAllCategories() async {
    _categoriesListAPIResponse = APIResponse.loading();
    notifyListeners();

    final response = await storeRepo.getCategories();
    response.fold((error) {
      _categoriesListAPIResponse = APIResponse.error(
        error.message,
        exception: error,
      );
      notifyListeners();
    }, (result) async {
      final filteredCategories = result.items?.toList();

      // final filteredCategoriesChildren = result.items
      //     ?.expand((category) => category.childrens ?? [])
      //     .where((child) => child.productsCount?.online != 0)
      //     .toList();

      // if (filteredCategories == null && filteredCategoriesChildren == null) {
      //   return;
      // }

      final mergedCategories = <CategoryData>[...filteredCategories ?? []];

      _categoriesListAPIResponse = APIResponse.completed(mergedCategories);
      notifyListeners();

      if (mergedCategories.isNotEmpty && mergedCategories.first.cID != null) {
        await getAllProductsByPagination(
          categoryID: mergedCategories.first.cID!,
          isRandom: false,
        );
        notifyListeners();
      }
    });
  }

  Future<bool> addFavourite(String productID) async {
    // Optimistic Update
    _updateFavouriteLocally(productID, true, "temp");
    notifyListeners();

    try {
      final response = await storeRepo.addFavourite(productID: productID);

      return response.fold((error) {
        // Revert on error
        _updateFavouriteLocally(productID, false, "");
        AlertDialogs.showError(error.message);
        notifyListeners();
        return false;
      }, (data) {
        final favouriteId = data['favouriteID'] ?? "";
        // Update with actual favouriteID
        _updateFavouriteLocally(productID, true, favouriteId.toString());
        notifyListeners();
        return true;
      });
    } catch (e) {
      inspect(e);
      // Revert on error
      _updateFavouriteLocally(productID, false, "");
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavourite(String productID) async {
    // Optimistic Update
    _updateFavouriteLocally(productID, false, "", isByFavID: true);
    notifyListeners();

    try {
      final response = await storeRepo.removeFavourite(productID: productID);

      return response.fold((error) {
        AlertDialogs.showError(error.message);
        getFavouriteProductList(); // Revert by fetching correct state
        return false;
      }, (message) {
        return true;
      });
    } catch (e) {
      getFavouriteProductList(); // Revert by fetching correct state
      return false;
    }
  }

  void _updateFavouriteLocally(String productID, bool isFav, String favouriteId,
      {bool isByFavID = false}) {
    bool updateCondition(ProductDataModel p) =>
        isByFavID ? p.favouriteID == productID : p.pID == productID;

    final index = productsListRandom.indexWhere(updateCondition);
    if (index != -1) {
      productsListRandom[index] = productsListRandom[index].copyWith(
        isFavourite: isFav,
        favouriteID: favouriteId,
      );
    }

    final productList = _productsListAPIResponse.data ?? [];
    final index2 = productList.indexWhere(updateCondition);
    if (index2 != -1) {
      productList[index2] = productList[index2].copyWith(
        favouriteID: favouriteId,
        isFavourite: isFav,
      );
    }

    final featuredList =
        _featuredPopularProductsAPIResponse.data?.featuredProducts ?? [];
    final index3 = featuredList.indexWhere(updateCondition);
    if (index3 != -1) {
      featuredList[index3] = featuredList[index3].copyWith(
        favouriteID: favouriteId,
        isFavourite: isFav,
      );
    }

    final popularList =
        _featuredPopularProductsAPIResponse.data?.popularProducts ?? [];
    final index4 = popularList.indexWhere(updateCondition);
    if (index4 != -1) {
      popularList[index4] = popularList[index4].copyWith(
        favouriteID: favouriteId,
        isFavourite: isFav,
      );
    }

    if (!isFav) {
      final favouriteProductsList =
          _favouriteProductResponse.data?.favouriteList?.productList ?? [];
      final index5 =
          favouriteProductsList.indexWhere((p) => p.favouriteID == productID);
      if (index5 != -1) {
        favouriteProductsList.removeAt(index5);
      }
    }
  }

  Future<void> getFavouriteProductList() async {
    try {
      final isLogged = await sharedPrefsRepository.getUserData() != null;
      if (!isLogged) return;
      _favouriteProductResponse = APIResponse.loading();
      notifyListeners();
      final response = await storeRepo.getFavouriteProductList();
      return response.fold((error) {
        AlertDialogs.showError(error.message);
        _favouriteProductResponse =
            APIResponse.error(error.message, exception: error);
        notifyListeners();
      }, (favouriteList) {
        final list = favouriteList.favouriteList?.productList ?? [];
        final modifiedList = list
            .map(
              (product) => product.copyWith(
                isFavourite: true,
              ),
            )
            .toList();
        final modifiedFavouriteList = FavouriteProductRawDataModel(
          favouriteList: FavouriteProductDataModel(
            productList: modifiedList,
          ),
        );
        _favouriteProductResponse =
            APIResponse.completed(modifiedFavouriteList);

        notifyListeners();
      });
    } finally {}
  }

  void onChangeSelectedCategory(CategoryData? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void onChangeSelectedSubCategory(CategoryData? category) {
    _selectedSubCategory = category;
    notifyListeners();
  }

  void onChangeSelectedCategoryIndex(int? index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  void resetValues() {
    _productsListAPIResponse = APIResponse.initial();
    _categoriesListAPIResponse = APIResponse.initial();
    _productsCollection.clear();
    // _selectedFoodType = FoodType.nonVeg;
  }
}
