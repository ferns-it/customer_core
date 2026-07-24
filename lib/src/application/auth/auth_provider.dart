import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/domain/otp/models/verify_already_registered_model.dart';
import 'package:customer_core/src/domain/store/models/store_settings_data_model.dart';
import 'package:customer_core/src/domain/user/models/user_login_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/core/constants/enums.dart';
import 'package:customer_core/src/domain/user/i_user_repo.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/alert_dialogs.dart';
import '../../core/utils/utils.dart';
import '../../domain/otp/otp_purpose.dart';
import '../../domain/user/i_user_shared_prefs.dart';
import '../../domain/user/models/user_login_request.dart';
import '../../domain/user/models/user_register_request.dart';
import '../core/base_controller.dart';
import '../otp/otp_provider.dart';

enum AuthView { login, register, forgotPassword }

/// Stages for the new registration flow:
/// The flow progresses sequentially:
/// contact (enter all details) →
///   if email+phone enabled: otpEmail → otpPhone → register
///   if only email: otpEmail → register
///   if only phone: otpPhone → register
///   if none: register
enum RegStage {
  contact, // phone, email
  otpEmail, // email OTP verification
  otpPhone, // phone OTP verification
  register,
  success,
  mobileChoice,
  otpCombined // Combined email + phone OTP on one page
}

@LazySingleton()
class AuthProvider extends ChangeNotifier with BaseController {
  final IUserRepo userRepository;
  final IUserSharedPrefsRepo sharedPrefsRepository;
  final OtpProvider otpProvider;

  AuthProvider({
    required this.userRepository,
    required this.sharedPrefsRepository,
    required this.otpProvider,
  });

  final loginFormKey = GlobalKey<FormState>();

  final _firebaseMessaging = FirebaseMessaging.instance;

  // Login Controllers
  final loginUserNameController = TextEditingController();
  final loginUserPasswordController = TextEditingController();

  bool _loginPasswordHide = true;

  bool get loginPasswordHide => _loginPasswordHide;

  bool _isRegisterMode = false;

  bool get isRegisterMode => _isRegisterMode;

  bool _loginLoading = false;

  bool get loginLoading => _loginLoading;

  final registerFormKey1 = GlobalKey<FormState>();
  final registerFormKey2 = GlobalKey<FormState>();
  final phoneFormKey = GlobalKey<FormState>();
  final emailFormKey = GlobalKey<FormState>();

  // Registration flow stage
  RegStage _currentRegStage = RegStage.contact;
  RegStage get currentRegStage => _currentRegStage;

  int _currentForgotForm = 0;

  int get currentForgotForm => _currentForgotForm;

  bool _registerLoading = false;

  bool get registerLoading => _registerLoading;

  bool _sendOtpLoading = false;
  bool get sendOtpLoading => _sendOtpLoading;

  bool _verifyOtpLoading = false;
  bool get verifyOtpLoading => _verifyOtpLoading;
  VerifyAlreadyRegisteredModel? verifyResponse;

  // OTP state tracking for inline verification
  bool _emailOtpSent = false;
  bool get emailOtpSent => _emailOtpSent;

  bool _phoneOtpSent = false;
  bool get phoneOtpSent => _phoneOtpSent;

  bool _phoneOtpSending = false;
  bool get phoneOtpSending => _phoneOtpSending;

  bool _emailOtpVerified = false;
  bool get emailOtpVerified => _emailOtpVerified;

  bool _phoneOtpVerified = false;
  bool get phoneOtpVerified => _phoneOtpVerified;

  bool emailVerified = false;
  bool phoneVerified = false;

  bool emailVerifying = false;
  bool phoneVerifying = false;

  // Verify Later / Skip OTP flow
  bool _otpSkipped = false;
  bool get otpSkipped => _otpSkipped;

  bool _mobileVerifiedLater = false;
  bool get mobileVerifiedLater => _mobileVerifiedLater;

  // Error messages for OTP
  String _emailOtpError = '';
  String get emailOtpError => _emailOtpError;

  String _phoneOtpError = '';
  String get phoneOtpError => _phoneOtpError;
  bool contactLoading = false;

  bool isEditingEmail = false;
  bool isEditingMobile = false;

  void disableEmailEdit() {
    isEditingEmail = false;
    notifyListeners();
  }

  void enableEmailEdit() {
    isEditingEmail = true;
    emailOtpController.clear();
    _emailOtpVerified = false;
    _emailOtpError = "";
    // Navigate back to contact stage to allow editing the email field
    _currentRegStage = RegStage.contact;
    notifyListeners();
  }

  void enableMobileEdit() {
    isEditingMobile = true;
    phoneOtpController.clear();
    _phoneOtpVerified = false;
    _phoneOtpError = "";
    notifyListeners();
  }

  void disableMobileEdit() {
    isEditingMobile = false;
    notifyListeners();
  }

  void setContactLoading(bool value) {
    contactLoading = value;
    notifyListeners();
  }

  bool get registrationButtonLoading {
    switch (_currentRegStage) {
      case RegStage.contact:
        return contactLoading;

      case RegStage.otpEmail:
        return sendOtpLoading || verifyOtpLoading;

      case RegStage.otpPhone:
        return sendOtpLoading || verifyOtpLoading;

      case RegStage.register:
        return registerLoading;

      case RegStage.success:
        return false;
      case RegStage.mobileChoice:
        return false;
      case RegStage.otpCombined:
        return false;
    }
  }

  // Register Controllers
  final registerUserEmailController = TextEditingController();
  final registerUserFirstNameController = TextEditingController();
  final registerUserLastNameController = TextEditingController();
  final registerUserPhoneController = TextEditingController();
  final registerUserPasswordController = TextEditingController();
  final registerUserConfirmPasswordController = TextEditingController();
  final phoneOtpController = TextEditingController();

  final emailOtpController = TextEditingController();
  bool _smsRequired = false;
  bool _emailRequired = false;

  bool get smsRequired => _smsRequired;

  bool get emailRequired => _emailRequired;

  String get registerUserFullName =>
      "${registerUserFirstNameController.text} ${registerUserLastNameController.text}";

  String? _registrationOTP;

  // Stores the verification channel determined from settings
  VerificationType _currentVerificationType = VerificationType.email;
  VerificationType get currentVerificationType => _currentVerificationType;

  bool _registerPasswordHide = true;

  bool get registerPasswordHide => _registerPasswordHide;
  bool _confirmPasswordHide = true;
  bool get confirmPasswordHide => _confirmPasswordHide;

  final resetFormKey = GlobalKey<FormBuilderState>();

  final newPasswordFieldKey = GlobalKey<FormFieldState>();

  bool _resetPasswordHide = true;

  bool get resetPasswordHide => _resetPasswordHide;

  bool _resetLoading = false;

  bool get resetLoading => _resetLoading;

  bool _resetLoadingSecondary = false;

  bool get resetLoadingSecondary => _resetLoadingSecondary;

  String get resetEmail =>
      resetFormKey.currentState?.value["email-address"] ?? '';

  final changePasswordFormKey = GlobalKey<FormBuilderState>();

  String get savedForgotPasswordValidateOTP =>
      changePasswordFormKey.currentState?.value['OTP'] ?? '';

  String get newPassword => newPasswordFieldKey.currentState?.value ?? '';

  String get savedNewPassword =>
      changePasswordFormKey.currentState?.value["new-password"] ?? '';

  String get savedConfirmPassword =>
      changePasswordFormKey.currentState?.value["confirm-password"] ?? '';

  AuthView _selectedAuthView = AuthView.login;
  AuthView get selectedAuthView => _selectedAuthView;
  UserLoginResponse? _userData;

  UserLoginResponse? get userData => _userData;

  String? _savedResetEmail;

  String get savedResetEmail => _savedResetEmail ?? '';

  void resetOtpVerification() {
    emailVerified = false;
    phoneVerified = false;
    emailVerifying = false;
    phoneVerifying = false;

    emailOtpController.clear();
    phoneOtpController.clear();

    notifyListeners();
  }

  // void resetVerificationAfterBack() {
  //   _emailRequired = false;
  //   _smsRequired = false;
  //   phoneOtpController.clear();
  //   notifyListeners();
  // }

  void initializeOtpRequirement(StoreSettingsDataModel settings) {
    _smsRequired = settings.smsVerification == "Enabled";
    _emailRequired = settings.emailVerification == "Enabled";
    notifyListeners();
  }

  void toggleLoginPassword() {
    _loginPasswordHide = !_loginPasswordHide;
    notifyListeners();
  }

  void toggleRegisterPassword() {
    _registerPasswordHide = !_registerPasswordHide;
    notifyListeners();
  }

  void confirmRegisterPassword() {
    _confirmPasswordHide = !_confirmPasswordHide;
    notifyListeners();
  }

  void toggleResetPassword() {
    _resetPasswordHide = !_resetPasswordHide;
    notifyListeners();
  }

  bool validateLoginForm() {
    return loginFormKey.currentState?.validate() ?? false;
  }

  void togleRegisterMode(bool value) {
    _isRegisterMode = value;
    notifyListeners();
  }

  bool validatePhoneForm() {
    return phoneFormKey.currentState?.validate() ?? false;
  }

  bool validateEmailForm() {
    return emailFormKey.currentState?.validate() ?? false;
  }

  bool validateRegisterForm1() {
    return validatePhoneForm() && validateEmailForm();
  }

  bool validateRegisterForm2() {
    return registerFormKey2.currentState?.validate() ?? false;
  }

  bool validateResetForm() {
    return resetFormKey.currentState?.validate() ?? false;
  }

  void updateCurrentRegStage(RegStage stage) {
    _currentRegStage = stage;
    if (stage == RegStage.otpEmail) {
      isEditingEmail = false;
    }

    if (stage == RegStage.otpPhone) {
      isEditingMobile = false;
    }

    notifyListeners();
  }

  // Backward compatibility - uses RegStage stages
  int get currentRegForm {
    // Map RegStage to old form numbers for backward compatibility only
    switch (_currentRegStage) {
      case RegStage.contact:
        return 0;
      case RegStage.otpEmail:
      case RegStage.otpPhone:
        return 1;
      case RegStage.register:
        return 2;
      case RegStage.success:
        return 3;
      case RegStage.mobileChoice:
        return 4;
      case RegStage.otpCombined:
        return 5;
    }
  }

  @Deprecated('Use updateCurrentRegStage instead')
  void updateCurrentRegForm(int formNo) {
    _currentRegStage = _currentRegFormToStage(formNo);
    notifyListeners();
  }

  RegStage _currentRegFormToStage(int formNo) {
    switch (formNo) {
      case 0:
        return RegStage.contact;
      case 1:
        return RegStage.register;
      default:
        return RegStage.contact;
    }
  }

  void updateCurrentForgotForm(int formNo) {
    _currentForgotForm = formNo;
    notifyListeners();
  }

  void onChangeSelectedAuthView(AuthView value) {
    _selectedAuthView = value;
    notifyListeners();
  }

  void setVerificationType(VerificationType type) {
    _currentVerificationType = type;
  }

  Future<bool> checkUserIsLogged() async =>
      await sharedPrefsRepository.getUserData() != null;

  Future<bool> loginUser() async {
    try {
      _loginLoading = true;
      notifyListeners();
      final payload = UserLoginRequest(
        shopID: AppIdentifiers.kShopId,
        user: loginUserNameController.text,
        password: loginUserPasswordController.text,
      );

      final response = await userRepository.loginUser(payload);
      return response.fold(
        (error) {
          AlertDialogs.showError(error.message);
          return false;
        },
        (userData) async {
          final userID = userData.user.userID;
          final topicID = "${AppIdentifiers.kFCMTopicID}$userID";

          if (Platform.isIOS) {
            String? apnsToken = await _firebaseMessaging.getAPNSToken();
            if (apnsToken != null) {
              await _firebaseMessaging.subscribeToTopic(topicID);
            } else {
              await Future<void>.delayed(
                const Duration(seconds: 2),
              );
              apnsToken = await _firebaseMessaging.getAPNSToken();
              if (apnsToken != null) {
                await _firebaseMessaging.subscribeToTopic(topicID);
              }
            }
          } else {
            await _firebaseMessaging.subscribeToTopic(topicID);
          }

          return await sharedPrefsRepository.saveUserData(userData);
        },
      );
    } finally {
      _loginLoading = false;
      notifyListeners();
    }
  }

  /// Send SMS OTP to the phone number entered
  Future<bool> sendSmsOtp({String? countryCode}) async {
    try {
      _sendOtpLoading = true;
      notifyListeners();

      final smsSent = await otpProvider.sendPhoneOtp(
        phone: registerUserPhoneController.text,
        countryCode: countryCode ?? AppConfig.instance.country.dialCode,
        purpose: OtpPurpose.signup,
      );
      if (smsSent) {
        otpProvider.startTimer();
        _phoneOtpSent = true;
        return true;
      }
      return false;
    } finally {
      _sendOtpLoading = false;
      notifyListeners();
    }
  }

  /// Send Email OTP
  /// This method should only be called after user is verified as new
  Future<bool> sendEmailOtp() async {
    try {
      _sendOtpLoading = true;
      notifyListeners();

      final userEmail = registerUserEmailController.text.trim();
      final generatedOTP = Utils.generateOTP();

      final response = await userRepository.sendVerifyOTPForUserRegistration(
        userEmail: userEmail,
        otp: generatedOTP,
        customerName: registerUserFullName,
      );

      return response.fold(() {
        _registrationOTP = generatedOTP;
        otpProvider.startTimer();
        _emailOtpSent = true;
        return true;
      }, (error) {
        AlertDialogs.showError(error.message);
        return false;
      });
    } finally {
      _sendOtpLoading = false;
      notifyListeners();
    }
  }

  void initializeRegistrationFlow() {
    _currentRegStage = RegStage.contact;
    isEditingEmail = true;
    isEditingMobile = true;
    _emailOtpSent = false;
    _phoneOtpSent = false;
    _emailOtpVerified = false;
    _phoneOtpVerified = false;
    _registrationOTP = null;
    _emailOtpError = '';
    _phoneOtpError = '';
    _otpSkipped = false;
    _mobileVerifiedLater = false;
    notifyListeners();
  }

  /// Skip OTP flow and proceed directly to register stage
  void skipMobileVerification() {
    _otpSkipped = true;
    _mobileVerifiedLater = true;
    _phoneOtpVerified = false;
    _currentRegStage = RegStage.register;
    notifyListeners();
  }

  /// Proceed after verifying OTP (Verify Now flow)
  void verifyNowAndProceed() {
    _otpSkipped = false;
    _mobileVerifiedLater = false;
    _currentRegStage = RegStage.register;
    notifyListeners();
  }

  /// Main registration flow following the diagram:
  /// Form 1 → Validate → VerifyAlreadyRegistered API → Branch based on response
  Future<bool> startRegistration() async {
    try {
      // Step 1: Validate form (already done before calling this)

      // Step 2: Call VerifyAlreadyRegistered API
      final isNewUser = await checkUserAlreadyRegistered();
      if (!isNewUser) {
        if (verifyResponse?.isPartialUser == true) {
          return false;
        } else if (verifyResponse != null) {
          return false;
        } else {
          return false;
        }
      }

      if (!_smsRequired && !_emailRequired) {
        // Both disabled - Skip OTP, go directly to register
        _currentRegStage = RegStage.register;
      } else if (_emailRequired && _smsRequired) {
        // Both enabled - Start with email OTP first
        _currentRegStage = RegStage.otpEmail;
      } else if (_emailRequired) {
        // Only email enabled
        _currentRegStage = RegStage.otpEmail;
      } else {
        // Only SMS enabled
        _currentRegStage = RegStage.mobileChoice;
      }

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Send email OTP for the inline flow (resets state)
  Future<bool> sendEmailOtpForInline() async {
    _emailOtpSent = false;
    _emailOtpVerified = false;
    _emailOtpError = '';
    emailOtpController.clear();
    final result = await sendEmailOtp();
    return result;
  }

  /// Verify email OTP (local comparison) for inline flow
  bool verifyEmailOtpForInline() {
    _emailOtpError = '';
    if (_registrationOTP != null &&
        _registrationOTP == emailOtpController.text) {
      _emailOtpVerified = true;
      emailVerified = true;
      notifyListeners();
      return true;
    }

    _emailOtpError = 'Invalid Email OTP';
    emailOtpController.clear();
    notifyListeners();
    return false;
  }

  /// Send phone OTP for the inline flow (resets state)
  Future<bool> sendPhoneOtpForInline({String? countryCode}) async {
    _phoneOtpSending = true;
    _phoneOtpSent = false;
    _phoneOtpVerified = false;
    _phoneOtpError = '';
    phoneOtpController.clear();
    notifyListeners();

    final result = await sendSmsOtp(countryCode: countryCode);

    _phoneOtpSending = false;
    if (result) {
      _phoneOtpSent = true;
    }
    notifyListeners();
    return result;
  }

  /// Verify phone OTP for inline flow
  Future<bool> verifyPhoneOtpForInline() async {
    _phoneOtpError = '';
    final result = await verifySmsOtp();
    if (result) {
      _phoneOtpVerified = true;
      phoneVerified = true;
      notifyListeners();
    } else {
      _phoneOtpError = 'Invalid Mobile OTP';
      phoneOtpController.clear();
      notifyListeners();
    }
    return result;
  }

  /// Verify SMS OTP via the OTP provider
  Future<bool> verifySmsOtp() async {
    try {
      _verifyOtpLoading = true;
      notifyListeners();

      final result = await otpProvider.verifyPhoneOtp(
        purpose: OtpPurpose.signup,
        phone: registerUserPhoneController.text,
        countryCode: AppConfig.instance.country.dialCode,
        otp: phoneOtpController.text,
        userID: _userData?.user.userID ?? '',
        userType: 'Registered',
      );
      return result;
    } finally {
      _verifyOtpLoading = false;
      notifyListeners();
    }
  }

  /// Move from email OTP stage to phone OTP stage (when both enabled)
  void proceedToPhoneOtp() {
    if (_emailOtpVerified) {
      _currentRegStage = RegStage.otpPhone;
      notifyListeners();
    }
  }

  /// Proceed to registration after all OTPs are verified
  void proceedToRegister() {
    bool canProceed = true;

    if (_emailRequired && !_emailOtpVerified) {
      canProceed = false;
    }
    if (_smsRequired && !_phoneOtpVerified) {
      canProceed = false;
    }

    if (canProceed) {
      _currentRegStage = RegStage.register;
      notifyListeners();
    }
  }

  /// Verify email OTP (local comparison) - used by verifyRegistrationOtp
  bool verifyEmailOtp() {
    if (_registrationOTP != null &&
        _registrationOTP == emailOtpController.text) {
      return true;
    }
    return false;
  }

  @Deprecated('Use sendEmailOtpForInline / sendPhoneOtpForInline instead')
  Future<bool> sendVerifyOTPForRegistration() async {
    bool smsSent = true;
    bool emailSent = true;

    if (_currentVerificationType == VerificationType.sms ||
        _currentVerificationType == VerificationType.both) {
      smsSent = await sendSmsOtp();
    }

    if (_currentVerificationType == VerificationType.email ||
        _currentVerificationType == VerificationType.both) {
      emailSent = await sendEmailOtp();
    }

    return smsSent && emailSent;
  }

  Future<bool> verifyRegistrationOtp() async {
    try {
      if (_smsRequired) {
        final phoneResult = await otpProvider.verifyPhoneOtp(
          purpose: OtpPurpose.signup,
          phone: registerUserPhoneController.text,
          countryCode: AppConfig.instance.country.dialCode,
          otp: phoneOtpController.text,
          userID: _userData?.user.userID ?? '',
          userType: 'Registered',
        );

        if (!phoneResult) {
          AlertDialogs.showError("Invalid Mobile OTP");
          return false;
        }

        phoneVerified = true;
      }

      if (_emailRequired) {
        if (emailOtpController.text.isEmpty) {
          AlertDialogs.showError("Please enter Email OTP");
          return false;
        }

        if (!verifyEmailOtp()) {
          AlertDialogs.showError("Invalid Email OTP");
          return false;
        }

        emailVerified = true;
      }

      // OTP verified successfully, move to details stage
      _currentRegStage = RegStage.register;
      notifyListeners();
      return true;
    } catch (e) {
      AlertDialogs.showError("OTP verification failed. Please try again.");
      return false;
    }
  }

  @Deprecated('Use sendEmailOtpForInline / sendPhoneOtpForInline instead')
  Future<bool> sendOtpBasedOnSettings() async {
    bool smsSent = true;
    bool emailSent = true;

    if (_smsRequired) {
      smsSent = await sendSmsOtp();
    }

    if (_emailRequired) {
      emailSent = await sendEmailOtp();
    }

    return smsSent && emailSent;
  }

  /// Link partial user - called when user clicks "Yes" on link dialog
  Future<bool> linkPartialUser() async {
    try {
      _registerLoading = true;
      notifyListeners();

      // Call the Link API to link the partial user's mobile with this email
      final response = await userRepository.linkPartialUser(
        userEmail: registerUserEmailController.text,
        userMobile: registerUserPhoneController.text,
        shopID: AppIdentifiers.kShopId,
      );

      return response.fold(
        (error) {
          AlertDialogs.showError(error.message);
          return false;
        },
        (success) {
          // After linking, proceed with registration flow
          if (!_smsRequired && !_emailRequired) {
            _currentRegStage = RegStage.register;
          } else if (_emailRequired && _smsRequired) {
            _currentRegStage = RegStage.otpEmail;
          } else if (_emailRequired) {
            _currentRegStage = RegStage.otpEmail;
          } else {
            _currentRegStage = RegStage.otpPhone;
          }
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      return false;
    } finally {
      _registerLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerUser({String? countryCode}) async {
    try {
      _registerLoading = true;
      notifyListeners();

      final payload = UserRegisterRequest(
        shopID: AppIdentifiers.kShopId,
        userFirstName: registerUserFirstNameController.text,
        userLastName: registerUserLastNameController.text,
        userEmail: registerUserEmailController.text,
        userMobile: registerUserPhoneController.text,
        userPassword: registerUserPasswordController.text,
        countryCode: countryCode ?? AppConfig.instance.country.dialCode,
        userAddress: UserAddress.empty(),
        userPostCode: '',
        userMobileToken: _mobileVerifiedLater ? "" : otpProvider.otpTokenId,
        isEmailVerified: 'Yes',
        mobileVerifiedLater: _mobileVerifiedLater ? "Yes" : "No",
      );
      final response = await userRepository.registerUser(payload);
      print("Mobile OTP Token in Payload: ${payload.userMobileToken}");
      print("Mobile Verified Later: ${payload.mobileVerifiedLater}");
      return response.fold(
        (error) {
          AlertDialogs.showError(error.message);
          return false;
        },
        (userData) {
          return true;
        },
      );
    } finally {
      _registerLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword({bool isResendOTP = false}) async {
    try {
      if (isResendOTP) {
        _resetLoadingSecondary = true;
        notifyListeners();
        final response =
            await userRepository.requestPasswordResetOTP(savedResetEmail);
        return response.fold(() {
          return true;
        }, (error) {
          AlertDialogs.showError(error.message);
          return false;
        });
      }

      if (resetFormKey.currentState == null) {
        return false;
      }

      _resetLoading = true;
      notifyListeners();

      final isValid = resetFormKey.currentState!.saveAndValidate();
      if (!isValid) {
        return false;
      }
      _savedResetEmail = resetEmail;

      final response = await userRepository.requestPasswordResetOTP(resetEmail);

      return response.fold(() {
        return true;
      }, (error) {
        AlertDialogs.showError(error.message);
        return false;
      });
    } finally {
      _resetLoading = false;
      _resetLoadingSecondary = false;

      notifyListeners();
    }
  }

  Future<bool> validateResetPasswordOTP() async {
    try {
      final isValid =
          changePasswordFormKey.currentState?.saveAndValidate() ?? false;

      if (!isValid || savedResetEmail.isEmpty || savedNewPassword.isEmpty) {
        return false;
      }

      _resetLoading = true;
      notifyListeners();

      final response = await userRepository.validateAndResetPassword(
        userEmail: savedResetEmail,
        password: savedNewPassword,
        otp: savedForgotPasswordValidateOTP,
      );

      return response.fold(() {
        log(response.toString(), name: "validateResetPasswordOTP");
        return true;
      }, (error) {
        log(error.toString(), name: "validateResetPasswordOTP");
        AlertDialogs.showError(error.message);
        return false;
      });
    } finally {
      _resetLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkUserAlreadyRegistered() async {
    final response = await userRepository.checkUserAlreadyRegistered(
      userEmail: registerUserEmailController.text,
      userMobile: registerUserPhoneController.text,
      shopID: AppIdentifiers.kShopId,
    );
    print("Response: $response");
    return response.fold((error) {
      // Don't show snackbar here
      return false;
    }, (result) {
      if (result["error"] == true) {
        verifyResponse = VerifyAlreadyRegisteredModel.fromMap(
          result["errorMessage"],
        );
        return false;
      }
      verifyResponse = null;
      return true;
    });
  }

  Future<bool> logoutUser() async {
    final userData = await sharedPrefsRepository.getUserData();
    final userID = userData?.user.userID;
    if (!kDebugMode) {
      // await FirebaseMessaging.instance
      //     .unsubscribeFromTopic("${AppIdentifiers.kFCMTopicID}$userID");
    }

    await sharedPrefsRepository.deleteGuestID();

    return await sharedPrefsRepository.deleteUserData();
  }

  void clearValues({bool registerControllersOnly = false}) {
    registerUserEmailController.clear();
    registerUserFirstNameController.clear();
    registerUserLastNameController.clear();
    registerUserPhoneController.clear();
    registerUserPasswordController.clear();
    registerUserConfirmPasswordController.clear();
    phoneOtpController.clear();
    emailOtpController.clear();
    _registrationOTP = null;
    _currentRegStage = RegStage.contact;
    _emailOtpSent = false;
    _phoneOtpSent = false;
    _emailOtpVerified = false;
    _phoneOtpVerified = false;
    _emailOtpError = '';
    _phoneOtpError = '';
    otpProvider.clear();

    if (!registerControllersOnly) {
      loginUserNameController.clear();
      loginUserPasswordController.clear();
    }
  }

  void clearResetFormValues() {}

  void disposeController() {
    loginUserNameController.dispose();
    loginUserPasswordController.dispose();
    registerUserEmailController.dispose();
    registerUserFirstNameController.dispose();
    registerUserLastNameController.dispose();
    registerUserPhoneController.dispose();
    registerUserPasswordController.dispose();
    registerUserConfirmPasswordController.dispose();
    phoneOtpController.clear();
    emailOtpController.clear();
  }
}
