import 'dart:convert';

import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/domain/store/models/product_details_model.dart';
import 'package:customer_core/src/infrastructure/core/api_manager/api_manager.dart';
import 'package:customer_core/src/infrastructure/core/end_points/end_points.dart';

import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:dio/dio.dart';

import 'package:fpdart/src/either.dart';
import 'package:injectable/injectable.dart';

import '../../domain/search/i_search_repo.dart';

@LazySingleton(as: ISearchRepo)
class SearchRepo implements ISearchRepo {
  @override
  Future<Either<AppExceptions, List<ProductDataModel>>> getAllSearchProducts(
      {required String searchKey}) async {
    try {
      final data = {"shopId": AppIdentifiers.kShopId, "searchkey": searchKey};
      final response =
          await APIManager.post(api: Endpoints.kSearchProducts, data: data);

      if (response == null) return Left(InternalServerErrorException());
      final jsonData = jsonDecode(response);
      final result = jsonData['dataList'] as List;
      final products = result.map((e) => ProductDataModel.fromMap(e)).toList();
      return Right(products);
    } on DioException catch (e) {
      return Left(e.error is AppExceptions
          ? e.error as AppExceptions
          : InternalServerErrorException());
    } catch (_) {
      return Left(InternalServerErrorException());
    }
  }

  @override
  Future<Either<AppExceptions, Map<String, dynamic>>> addFavourite(
      {required String productID}) {
    try {
      final data = {
        "type": "Product",
        "itemID": productID,
      };
      return APIManager.post(
        api: Endpoints.kMakeFavourite,
        needAuth: true,
        data: data,
      ).then((response) {
        if (response == null) return Left(InternalServerErrorException());
        final decodedData = jsonDecode(response);
        return Right(decodedData);
      });
    } on DioException catch (e) {
      return Future.value(Left(e.error is AppExceptions
          ? e.error as AppExceptions
          : InternalServerErrorException()));
    } catch (_) {
      return Future.value(Left(InternalServerErrorException()));
    }
  }

  @override
  Future<Either<AppExceptions, String>> removeFavourite(
      {required String productID}) {
    try {
      return APIManager.delete(
        api: "${Endpoints.kDeleteFavourite}/$productID",
        needAuthentication: true,
      ).then((response) {
        if (response == null) return Left(InternalServerErrorException());
        final decodedData = jsonDecode(response);
        return Right(decodedData["message"]);
      });
    } on DioException catch (e) {
      return Future.value(Left(e.error is AppExceptions
          ? e.error as AppExceptions
          : InternalServerErrorException()));
    } catch (_) {
      return Future.value(Left(InternalServerErrorException()));
    }
  }
}
