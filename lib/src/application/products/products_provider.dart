import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_core/src/application/search/search_provider.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:dartx/dartx.dart';
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
  final ShopProvider shopProvider;

  ProductsProvider({
    required this.storeRepo,
    required this.sharedPrefsRepository,
    required this.shopProvider,
  });
  Random random = Random();

  Timer? _stockResyncTimer;
  void syncStockAfterCartChange() {
    _stockResyncTimer?.cancel();
    _stockResyncTimer = Timer(const Duration(milliseconds: 500), () {
      getFeaturedPopularProducts(silent: true);
    });
  }

  @override
  void dispose() {
    _stockResyncTimer?.cancel();
    super.dispose();
  }

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

  ProductDataModel overlayStockFromProductsList(ProductDataModel product) {
    if (product.pID == null) return product;
    final cachedStock = stockForID(product.pID);
    if (cachedStock != null) return product.copyWith(stock: cachedStock);
    final source = productsList.firstOrNullWhere((p) => p.pID == product.pID);
    if (source == null || source.stock == null) return product;
    return product.copyWith(stock: source.stock);
  }

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

  final Map<String, ProductStockDetails> _productStockCache = {};
  void indexStockFrom(
    Iterable<ProductDataModel> products, {
    bool overwriteExisting = true,
  }) {
    for (final product in products) {
      final stock = product.stock;
      if (product.pID == null || stock == null) continue;
      // A stock entry without a countable amount carries no usable
      // information - never let it erase or create a misleading cache entry.
      if (stock.availableStock == null) continue;
      if (!overwriteExisting) {
        if (_productStockCache.containsKey(product.pID)) continue;
        // Secondary sources must never introduce a sold-out state into the
        // cache; only a positive countable amount is safe to fill with.
        if (stock.availableStock! <= 0) continue;
      }
      _productStockCache[product.pID!] = stock;
    }
  }

  /// Latest stock known for a dish, or `null` if it has never been fetched.
  ProductStockDetails? stockForID(String? pID) =>
      pID == null ? null : _productStockCache[pID];

  ProductDataModel overlayStockFromSecondarySource(ProductDataModel product) {
    if (product.pID == null) return product;
    final cachedStock = stockForID(product.pID);
    if (cachedStock != null) return product.copyWith(stock: cachedStock);
    final stock = product.stock;
    final isDegenerate = stock?.activated == true &&
        (stock!.availableStock == null || stock.availableStock! <= 0);
    if (isDegenerate) {
      // "No stock information" instead of a false sold-out flag.
      return product.copyWith(
        stock: ProductStockDetails(activated: false),
      );
    }
    return product;
  }

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
  Future<void> init() async {
    // getAllProductsByPagination();
    await getFeaturedPopularProducts();
    await getFavouriteProductList();
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
        indexStockFrom(newProducts);
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
        // Hide unavailable / out-of-stock products when the settings API
        // configures `listUnavailableProducts` as "Disabled".
        _productsListAPIResponse =
            APIResponse.completed(filterListableProducts(updatedList));

        if (isRandom) {
          final newProductsModified = newProducts.map((product) {
            final favId = favIdMap[product.pID];
            return product.copyWith(
              isFavourite: favId != null,
              favouriteID: favId ?? "",
            );
          }).toList();
          productsListRandom = filterListableProducts(newProductsModified);
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

  bool isProductListable(ProductDataModel product) {
    if (product.isAvailable == false) return false;
    final stock = product.stock;
    final availableStock = stock?.availableStock;
    if (stock?.activated == true &&
        availableStock != null &&
        availableStock <= 0) {
      return false;
    }
    return true;
  }
  List<ProductDataModel> filterListableProducts(
      Iterable<ProductDataModel> products) {
    if (shopProvider.canListUnavailableProducts) return products.toList();
    return products.where(isProductListable).toList();
  }
  Future<void> getFeaturedPopularProducts({bool silent = false}) async {
    if (shopProvider.storeSettings.data == null) {
      await shopProvider.fetchStoreSettings();
    }
    if (!silent) {
      _featuredPopularProductsAPIResponse = APIResponse.loading();
      notifyListeners();
    }
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
      indexStockFrom(list);
      indexStockFrom(popularList);
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
          featuredProducts: filterListableProducts(updatedList),
          popularProducts: filterListableProducts(updatedPopularList));
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
      indexStockFrom(list);
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
      final filteredList = filterListableProducts(updatedList);

      _cachedProducts[categoryID] = filteredList;
      _productsCollection = filteredList;
      _productsListAPIResponse = APIResponse.completed(filteredList);
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
      final list = result.items?.toList();
      final filteredCategories = list
          ?.where((category) => category.productsCount?.online != 0)
          .toList();

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

  Future<bool> addFavourite(
      String productID, SearchProvider searchProvider) async {
    // Optimistic Update
    _updateFavouriteLocally(productID, true, "temp");
    searchProvider.updateProductFavouriteLocally(productID, true, "temp");
    notifyListeners();

    try {
      final response = await storeRepo.addFavourite(productID: productID);

      return response.fold((error) {
        // Revert on error
        _updateFavouriteLocally(productID, false, "");
        searchProvider.updateProductFavouriteLocally(productID, false, "temp");

        AlertDialogs.showError(error.message);
        notifyListeners();
        return false;
      }, (data) {
        final favouriteId = data['favouriteID'] ?? "";
        // Update with actual favouriteID
        _updateFavouriteLocally(productID, true, favouriteId.toString());
        searchProvider.updateProductFavouriteLocally(
            productID, true, favouriteId.toString());

        notifyListeners();
        return true;
      });
    } catch (e) {
      // Revert on error
      _updateFavouriteLocally(productID, false, "");
      searchProvider.updateProductFavouriteLocally(productID, false, "");

      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavourite(
      String productID, SearchProvider searchProvider) async {
    // Optimistic Update
    _updateFavouriteLocally(productID, false, "", isByFavID: true);
    searchProvider.updateProductFavouriteLocally(
      productID,
      false,
      "",
      isByFavID: true,
    );

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

    // Update main products list and persist into APIResponse
    final productList =
        List<ProductDataModel>.from(_productsListAPIResponse.data ?? []);
    final index2 = productList.indexWhere(updateCondition);
    ProductDataModel? updatedProduct;
    if (index2 != -1) {
      updatedProduct = productList[index2] = productList[index2].copyWith(
        favouriteID: favouriteId,
        isFavourite: isFav,
      );
      _productsListAPIResponse = APIResponse.completed(productList);
    }

    // Update _productsCollection
    final indexCollection = _productsCollection.indexWhere(updateCondition);
    if (indexCollection != -1) {
      _productsCollection[indexCollection] =
          _productsCollection[indexCollection].copyWith(
        favouriteID: favouriteId,
        isFavourite: isFav,
      );
    }

    // Update all entries in _cachedProducts
    for (final entry in _cachedProducts.entries) {
      final cachedIndex = entry.value.indexWhere(updateCondition);
      if (cachedIndex != -1) {
        entry.value[cachedIndex] = entry.value[cachedIndex].copyWith(
          favouriteID: favouriteId,
          isFavourite: isFav,
        );
      }
    }
    // Update featured / popular and reassign response when changed
    final featuredList = List<ProductDataModel>.from(
        _featuredPopularProductsAPIResponse.data?.featuredProducts ?? [])
      ..removeWhere((p) => p == null);
    final index3 = featuredList.indexWhere(updateCondition);
    if (index3 != -1) {
      featuredList[index3] = featuredList[index3].copyWith(
        favouriteID: favouriteId,
        isFavourite: isFav,
      );
      final current = _featuredPopularProductsAPIResponse.data;
      if (current != null) {
        _featuredPopularProductsAPIResponse = APIResponse.completed(
          current.copyWith(featuredProducts: featuredList),
        );
      }
    }

    final popularList = List<ProductDataModel>.from(
        _featuredPopularProductsAPIResponse.data?.popularProducts ?? [])
      ..removeWhere((p) => p == null);
    final index4 = popularList.indexWhere(updateCondition);
    if (index4 != -1) {
      popularList[index4] = popularList[index4].copyWith(
        favouriteID: favouriteId,
        isFavourite: isFav,
      );
      final current = _featuredPopularProductsAPIResponse.data;
      if (current != null) {
        _featuredPopularProductsAPIResponse = APIResponse.completed(
          current.copyWith(popularProducts: popularList),
        );
      }
    }

    // Maintain favourites list
    final favRaw = _favouriteProductResponse.data;
    final favList = favRaw?.favouriteList?.productList != null
        ? List<ProductDataModel>.from(favRaw!.favouriteList!.productList)
        : <ProductDataModel>[];

    if (isFav) {
      // Add to favourites if not already present
      ProductDataModel? prod = updatedProduct;
      try {
        prod ??= productsListRandom.firstWhere(updateCondition);
      } catch (_) {}
      try {
        prod ??= _productsCollection.firstWhere(updateCondition);
      } catch (_) {}
      for (final entry in _cachedProducts.entries) {
        try {
          prod ??= entry.value.firstWhere(updateCondition);
        } catch (_) {}
        if (prod != null) break;
      }
      try {
        prod ??= featuredList.firstWhere(updateCondition);
      } catch (_) {}
      try {
        prod ??= popularList.firstWhere(updateCondition);
      } catch (_) {}

      if (prod != null) {
        final newFav = prod.copyWith(
          favouriteID: favouriteId,
          isFavourite: true,
        );
        final exists = favList.any(
            (p) => p.pID == newFav.pID || p.favouriteID == newFav.favouriteID);
        if (!exists) {
          favList.add(newFav);
          _favouriteProductResponse = APIResponse.completed(
            FavouriteProductRawDataModel(
              favouriteList: FavouriteProductDataModel(productList: favList),
            ),
          );
        }
      }
    } else {
      final index5 = favList.indexWhere((p) => p.favouriteID == productID);
      if (index5 != -1) {
        favList.removeAt(index5);
        _favouriteProductResponse = APIResponse.completed(
          FavouriteProductRawDataModel(
            favouriteList: FavouriteProductDataModel(productList: favList),
          ),
        );
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
        indexStockFrom(list, overwriteExisting: false);
        final modifiedList = list
            .map(
              (product) => product.copyWith(
                isFavourite: true,
              ),
            )
            .toList();
        final overlaidList = modifiedList
            .map(overlayStockFromSecondarySource)
            .toList();

        final filteredFavourites = filterListableProducts(overlaidList);
        final modifiedFavouriteList = FavouriteProductRawDataModel(
          favouriteList: FavouriteProductDataModel(
            productList: filteredFavourites,
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
    _productStockCache.clear();
    // _selectedFoodType = FoodType.nonVeg;
  }

  void resetSessionData() {
    List<ProductDataModel> stripFavourites(List<ProductDataModel> products) =>
        products
            .map((p) => (p.isFavourite || (p.favouriteID?.isNotEmpty ?? false))
                ? p.copyWith(isFavourite: false, favouriteID: '')
                : p)
            .toList();

    _favouriteProductResponse = APIResponse.initial();

    final featured = _featuredPopularProductsAPIResponse.data;
    if (featured != null) {
      _featuredPopularProductsAPIResponse = APIResponse.completed(
        featured.copyWith(
          featuredProducts: stripFavourites(featured.featuredProducts ?? []),
          popularProducts: stripFavourites(featured.popularProducts ?? []),
        ),
      );
    }

    final productData = _productsListAPIResponse.data;
    if (productData != null) {
      _productsListAPIResponse = APIResponse.completed(
        stripFavourites(productData),
      );
    }

    _productsCollection = stripFavourites(_productsCollection);
    productsListRandom = stripFavourites(productsListRandom);

    for (final entry in _cachedProducts.entries) {
      _cachedProducts[entry.key] = stripFavourites(entry.value);
    }

    notifyListeners();
  }
}
