import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/domain/user/i_user_repo.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/alert_dialogs.dart';
import '../../core/utils/utils.dart';
import '../../domain/user/i_user_shared_prefs.dart';
import '../../domain/user/models/user_login_request.dart';
import '../../domain/user/models/user_register_request.dart';
import '../core/base_controller.dart';

enum AuthView { login, register, forgotPassword }

@LazySingleton()
class AuthProvider extends ChangeNotifier with BaseController {
  final IUserRepo userRepository;
  final IUserSharedPrefsRepo sharedPrefsRepository;

  AuthProvider({
    required this.userRepository,
    required this.sharedPrefsRepository,
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

  int _currentRegForm = 0;

  int get currentRegForm => _currentRegForm;

  int _currentForgotForm = 0;

  int get currentForgotForm => _currentForgotForm;

  bool _registerLoading = false;

  bool get registerLoading => _registerLoading;

  bool _registerOTPLoading = false;

  bool get registerOTPLoading => _registerOTPLoading;

  // Register Controllers
  final registerUserEmailController = TextEditingController();
  final registerUserFirstNameController = TextEditingController();
  final registerUserLastNameController = TextEditingController();
  final registerUserPhoneController = TextEditingController();
  final registerUserPasswordController = TextEditingController();
  final registerUserConfirmPasswordController = TextEditingController();
  final registerOTPController = TextEditingController();

  String get registerUserFullName =>
      "${registerUserFirstNameController.text} ${registerUserLastNameController.text}";

  String? _registrationOTP;

  bool _registerPasswordHide = true;

  bool get registerPasswordHide => _registerPasswordHide;

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

  String? _savedResetEmail; // Store email from first form

  String get savedResetEmail => _savedResetEmail ?? '';

  void toggleLoginPassword() {
    _loginPasswordHide = !_loginPasswordHide;
    notifyListeners();
  }

  void toggleRegisterPassword() {
    _registerPasswordHide = !_registerPasswordHide;
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

  bool validateRegisterForm1() {
    return registerFormKey1.currentState?.validate() ?? false;
  }

  bool validateRegisterForm2() {
    return registerFormKey2.currentState?.validate() ?? false;
  }

  bool validateResetForm() {
    return resetFormKey.currentState?.validate() ?? false;
  }

  void updateCurrentRegForm(int formNo) {
    _currentRegForm = formNo;
    notifyListeners();
  }

  void updateCurrentForgotForm(int formNo) {
    _currentForgotForm = formNo;
    notifyListeners();
  }

  void onChangeSelectedAuthView(AuthView value) {
    _selectedAuthView = value;

    notifyListeners();
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
                const Duration(
                  seconds: 2,
                ),
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

  Future<bool> sendVerifyOTPForRegistration() async {
    try {
      _registerOTPLoading = true;
      notifyListeners();
      final isNewUser = await checkUserAlreadyRegistered();
      if (!isNewUser) {
        return false;
      }
      final userEmail = registerUserEmailController.text.trim();
      final generatedOTP = Utils.generateOTP();
      final response = await userRepository.sendVerifyOTPForUserRegistration(
        userEmail: userEmail,
        otp: generatedOTP,
        customerName: registerUserFullName,
      );
      return response.fold(() {
        _registrationOTP = generatedOTP;
        return true;
      }, (error) {
        AlertDialogs.showError(error.message);
        return false;
      });
    } finally {
      _registerOTPLoading = false;
      notifyListeners();
    }
  }

  bool validateRegisterOTP() => _registrationOTP == registerOTPController.text;

  Future<bool> registerUser() async {
    try {
      _registerLoading = true;
      _registerOTPLoading = true;
      notifyListeners();
      final payload = UserRegisterRequest(
        shopID: AppIdentifiers.kShopId,
        userFirstName: registerUserFirstNameController.text,
        userLastName: registerUserLastNameController.text,
        userEmail: registerUserEmailController.text,
        userMobile: registerUserPhoneController.text,
        userPassword: registerUserPasswordController.text,
        userAddress: UserAddress.empty(),
        userPostCode: '',
      );
      final response = await userRepository.registerUser(payload);
      return response.fold(
        (error) {
          // AlertDialogs.showError(error.message);
          return false;
        },
        (userData) {
          return true;
        },
      );
    } finally {
      _registerLoading = false;
      _registerOTPLoading = false;
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

  Future<bool> checkUserAlreadyRegistered(
      // {
      // required String userEmail,
      // required String userMobile,
      // required String shopID,
      // }
      ) async {
    final response = await userRepository.checkUserAlreadyRegistered(
      userEmail: registerUserEmailController.text,
      userMobile: registerUserPhoneController.text,
      shopID: AppIdentifiers.kShopId,
    );
    return response.fold((error) {
      AlertDialogs.showError(error.message);
      return false;
    }, (result) {
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
    final result = await sharedPrefsRepository.deleteUserData();
    clearValues();
    return result;
  }

  void clearValues({bool registerControllersOnly = false}) {
    registerUserEmailController.clear();
    registerUserFirstNameController.clear();
    registerUserLastNameController.clear();
    registerUserPhoneController.clear();
    registerUserPasswordController.clear();
    registerUserConfirmPasswordController.clear();
    registerOTPController.clear();

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
    registerOTPController.dispose();
  }
}
