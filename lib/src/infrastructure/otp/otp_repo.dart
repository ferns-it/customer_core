import 'dart:convert';

import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/domain/otp/i_otp_repo.dart';
import 'package:customer_core/src/domain/otp/models/send_otp_email_response_model.dart';
import 'package:customer_core/src/domain/otp/models/send_otp_response_model.dart';
import 'package:customer_core/src/domain/otp/otp_purpose.dart';
import 'package:customer_core/src/infrastructure/core/api_manager/api_manager.dart';
import 'package:customer_core/src/infrastructure/core/end_points/end_points.dart';
import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IOtpRepo)
class OtpRepo implements IOtpRepo {
  @override
  Future<Either<AppExceptions, SendOtpResponse>> sendPhoneOtp({
    required String shopID,
    required String phone,
    required String countryCode,
    required String purpose,
    required String userType,
    required String userID,
  }) async {
    try {
      final data = {
        "secretkey": KeyConfig.instance.fpSecretKey,
        "shopID": shopID,
        "userID": userID,
        "userType": userType,
        "countryCode": countryCode,
        "phone": phone,
        "purpose": purpose,
      };

      final response = await APIManager.post(
        api: Endpoints.kSendPhoneOTP,
        data: data,
        dataKeyChecking: false,
      );

      if (response == null) {
        return Left(InternalServerErrorException());
      }

      // The API returns { "error": false, "data": { ... } }
      // Since dataKeyChecking is false, response contains the full wrapper.
      // Extract the inner "data" object before parsing.
      final Map<String, dynamic> fullResponse = jsonDecode(response);
      final innerData = fullResponse['data'];
      final result = SendOtpResponse.fromJson(jsonEncode(innerData));

      return Right(result);
    } on DioException catch (e) {
      return Left(
        e.error is AppExceptions
            ? e.error as AppExceptions
            : InternalServerErrorException(),
      );
    } catch (_) {
      return Left(
        InternalServerErrorException(),
      );
    }
  }

  @override
  Future<Option<AppExceptions>> verifyPhoneOtp({
    required String shopID,
    required String phone,
    required String countryCode,
    required String purpose,
    required String otp,
    required String tokenId,
    required String userID,
    required String userType,
  }) async {
    try {
      final data = {
        "secretkey": KeyConfig.instance.fpSecretKey,
        "shopID": shopID,
        "countryCode": countryCode,
        "phone": phone,
        "otp": otp,
        "purpose": purpose,
        "otpToken": tokenId,
        "userID": userID,
        "userType": userType
      };

      final response = await APIManager.post(
        api: Endpoints.kVerifyPhoneOTP,
        data: data,
        dataKeyChecking: false,
      );

      if (response == null) {
        return Option.of(
          InternalServerErrorException(),
        );
      }

      return const Option.none();
    } on DioException catch (e) {
      return Option.of(
        e.error is AppExceptions
            ? e.error as AppExceptions
            : InternalServerErrorException(),
      );
    } catch (_) {
      return Option.of(
        InternalServerErrorException(),
      );
    }
  }

  @override
  Future<Either<AppExceptions, SendOtpEmailResponseModel>> sendEmailOtp({
    required String shopID,
    required String email,
    required String purpose,
    required String userType,
    required String userID,
  }) async {
    try {
      final data = {
        "secretkey": KeyConfig.instance.fpSecretKey,
        "shopID": shopID,
        "userID": userID,
        "userType": userType,
        "email": email,
        "purpose": purpose,
      };

      final response = await APIManager.post(
        api: Endpoints.kSendEmailOTP,
        data: data,
        dataKeyChecking: false,
      );

      if (response == null) {
        return Left(InternalServerErrorException());
      }
      final Map<String, dynamic> fullResponse = jsonDecode(response);
      final innerData = fullResponse['data'];
      final result = SendOtpEmailResponseModel.fromJson(jsonEncode(innerData));

      return Right(result);
    } on DioException catch (e) {
      return Left(
        e.error is AppExceptions
            ? e.error as AppExceptions
            : InternalServerErrorException(),
      );
    } catch (_) {
      return Left(
        InternalServerErrorException(),
      );
    }
  }

  @override
  Future<Option<AppExceptions>> verifyEmailOtp({
    required String shopID,
    required String email,
    required String purpose,
    required String otp,
    required String tokenId,
    required String userID,
    required String userType,
  }) async {
    try {
      final data = {
        "secretkey": KeyConfig.instance.fpSecretKey,
        "shopID": shopID,
        "email": email,
        "otp": otp,
        "purpose": purpose,
        "otpToken": tokenId,
        "userID": userID,
        "userType": userType
      };

      final response = await APIManager.post(
        api: Endpoints.kVerifyEmailOTP,
        data: data,
        dataKeyChecking: false,
      );

      if (response == null) {
        return Option.of(
          InternalServerErrorException(),
        );
      }

      return const Option.none();
    } on DioException catch (e) {
      return Option.of(
        e.error is AppExceptions
            ? e.error as AppExceptions
            : InternalServerErrorException(),
      );
    } catch (_) {
      return Option.of(
        InternalServerErrorException(),
      );
    }
  }
}
