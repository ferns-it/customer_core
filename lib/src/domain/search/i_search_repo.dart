import 'package:customer_core/src/domain/store/models/product_details_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../infrastructure/core/failures/app_exceptions.dart';

abstract class ISearchRepo {
  Future<Either<AppExceptions, List<ProductDataModel>>> getAllSearchProducts(
      {required String searchKey});
      
  Future<Either<AppExceptions, Map<String, dynamic>>> addFavourite(
      {required String productID});

  Future<Either<AppExceptions, String>> removeFavourite(
      {required String productID});

}
