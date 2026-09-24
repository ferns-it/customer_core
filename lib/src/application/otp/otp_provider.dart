import 'dart:async';

import 'package:customer_core/src/domain/otp/models/send_otp_response_model.dart';
import 'package:customer_core/src/domain/otp/otp_purpose.dart';
import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/app_identifiers.dart';
import '../../core/utils/alert_dialogs.dart';
import '../../domain/otp/i_otp_repo.dart';

@LazySingleton()
class OtpProvider extends ChangeNotifier {
  final IOtpRepo otpRepo;

  OtpProvider({
    required this.otpRepo,
  });

  bool _loading = false;

  bool get loading => _loading;
  Timer? _timer;

  int _seconds = 30;

  int get seconds => _seconds;

  bool get canResend => _seconds == 0;

  final otpController = TextEditingController();
  String? _otpTokenId;

  String? get otpTokenId => _otpTokenId;

  @override
  void dispose() {
    stopTimer();
    otpController.dispose();
    super.dispose();
  }

  void startTimer() {
    _seconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_seconds == 0) {
          timer.cancel();
        } else {
          _seconds--;
        }
        notifyListeners();
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
  }

  Future<bool> sendPhoneOtp({
    required String phone,
    required String countryCode,
    required OtpPurpose purpose,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      final response = await otpRepo.sendPhoneOtp(
        shopID: AppIdentifiers.kShopId,
        phone: phone,
        countryCode: countryCode,
        purpose: purpose.value,
        userID: "",
        userType: "Guest",
      );

      return response.match(
        (error) {
          AlertDialogs.showError(error.message);
          return false;
        },
        (result) {
          _otpTokenId = result.otpToken; // <-- use tokenId
          debugPrint("OTP Token: $_otpTokenId");
          if (_otpTokenId == null || _otpTokenId!.isEmpty) {
            AlertDialogs.showError(
                "Failed to get OTP token. Please try again.");
            return false;
          }
          startTimer();
          return true;
        },
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> sendEmailOtp({
    required String email,
    required EmailOtpPurpose purpose,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      final response = await otpRepo.sendEmailOtp(
        shopID: AppIdentifiers.kShopId,
        email: email,
        purpose: purpose.value,
        userID: "",
        userType: "Guest",
      );

      return response.match(
        (error) {
          AlertDialogs.showError(error.message);
          return false;
        },
        (result) {
          _otpTokenId = result.otpToken; // <-- use tokenId
          debugPrint("OTP Token: $_otpTokenId");
          if (_otpTokenId == null || _otpTokenId!.isEmpty) {
            AlertDialogs.showError(
                "Failed to get OTP token. Please try again.");
            return false;
          }
          startTimer();
          return true;
        },
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyPhoneOtp(
      {required String phone,
      required String countryCode,
      required OtpPurpose purpose,
      required String otp,
      required String userID,
      required String userType}) async {
    try {
      _loading = true;
      notifyListeners();
      final response = await otpRepo.verifyPhoneOtp(
        shopID: AppIdentifiers.kShopId,
        phone: phone,
        countryCode: countryCode,
        otp: otp,
        purpose: purpose.value,
        tokenId: otpTokenId ?? "",
        userID: userID,
        userType: userType,
      );
      print("verify response phone: $response");
      return response.fold(
        () => true,
        (error) {
          AlertDialogs.showError(error.message);
          return false;
        },
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyEmailOtp(
      {required String email,
      required EmailOtpPurpose purpose,
      required String otp,
      required String userID,
      required String userType}) async {
    try {
      _loading = true;
      notifyListeners();
      final response = await otpRepo.verifyEmailOtp(
        shopID: AppIdentifiers.kShopId,
        email: email,
        otp: otp,
        purpose: purpose.value,
        tokenId: otpTokenId ?? "",
        userID: userID,
        userType: userType,
      );
      print("verify response email: $response");
      return response.fold(
        () => true,
        (error) {
          AlertDialogs.showError(error.message);
          return false;
        },
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clear() {
    otpController.clear();
    stopTimer();
  }
}