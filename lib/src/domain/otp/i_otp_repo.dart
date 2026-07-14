import 'package:customer_core/src/domain/otp/models/send_otp_response_model.dart';
import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:fpdart/fpdart.dart';

abstract class IOtpRepo {
  Future<Either<AppExceptions, SendOtpResponse>> sendPhoneOtp({
    required String shopID,
    required String phone,
    required String countryCode,
    required String purpose,
    required String userType,
    required String userID,
  });

 Future<Option<AppExceptions>> verifyPhoneOtp({
    required String shopID,
    required String phone,
    required String countryCode,
    required String otp,
        required String purpose,
    required String tokenId,
  });
}
