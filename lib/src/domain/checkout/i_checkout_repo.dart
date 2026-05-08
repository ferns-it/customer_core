import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:fpdart/fpdart.dart';

import 'models/calculate_take_away_details.dart';
import 'models/calculated_delivery_charge_details_model.dart';
import 'models/checkout_data_model.dart';
import 'models/payment_intent_details.dart';

abstract class ICheckoutRepo {
  Future<Either<AppExceptions, CalculatedDeliveryChargeDetailsModel>>
      calculateDeliveryFee({
    required String shopID,
    required String destinationPostCode,
  });

  Future<Either<AppExceptions, CalculateTakeAwayDetails>> calculateTakeAwayFee(
    DateTime pickupTime,
  );

  Future<Either<AppExceptions, Map<String, dynamic>>> completeOrder({
    required CheckOutDataModel data,
  });

  Future<Either<AppExceptions, PaymentIntentDetails>> createPaymentIntent({
    required String discountAmount,
    required String deliveryCharges,
    required String deliveryType,
    required String postCode,
    required String pickupTime,

  });

  Future<Option> cancelPaymentIntent(String paymentID);
}
