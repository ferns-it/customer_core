import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/core/utils/country_flag.dart';
import 'package:customer_core/src/domain/store/models/store_settings_data_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:customer_core/src/application/auth/auth_provider.dart';
import 'package:customer_core/src/application/theme/theme_provider.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/routes/routes.gr.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../application/core/dependency_registrar.dart';
import '../../core/utils/alert_dialogs.dart';
import '../widgets/button_progress.dart';
import '../widgets/custom_text_field.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  LoginScreen({
    this.isFromProfile = false,
    this.showBackButton = false,
    super.key,
  });

  bool isFromProfile;
  final bool showBackButton;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();
  Timer? _timer;
  int _secondsRemaining = 60;

  void startTimer() {
    _timer?.cancel();
    _secondsRemaining = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        _streamController.add(_secondsRemaining);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = notifier(context);
    // final authListener = listener(context);
    final authProvider = context.read<AuthProvider>();
    final authListener = context.watch<AuthProvider>();
    final homeProvider = context.read<HomeProvider>();
    final homeListener = context.watch<HomeProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(UiConfig.instance.bgImage), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultScreenPadding),
          child: PopScope(
            onPopInvokedWithResult: (_, __) {
              authProvider.clearValues(registerControllersOnly: true);
            },
            child: buildContent(authProvider, context, authListener,
                homeProvider, homeListener),
          ),
        ),
      ),
    );
  }

  Widget buildContent(
      AuthProvider authProvider,
      BuildContext context,
      AuthProvider authListener,
      HomeProvider homeProvider,
      HomeProvider homeListener) {
    return Center(
        child: ListView(
      children: [
        Image.asset(UiConfig.instance.logo, height: 125),
        verticalSpaceMedium,
        ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.kBlack.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                      color: AppColors.kWhite.withOpacity(0.2), width: 1.0),
                ),
                child: authListener.selectedAuthView == AuthView.register
                    ? _registerFormParent(authProvider, context, homeProvider,
                        homeListener, authListener)
                    : authListener.selectedAuthView == AuthView.login
                        ? _loginForm(
                            authProvider, context, authListener, homeProvider)
                        : _forgotWidgetParent(
                            authProvider, context, authListener),
              ),
            )),
      ],
    ));
  }

  Widget _loginForm(
    AuthProvider authProvider,
    BuildContext context,
    AuthProvider authListener,
    HomeProvider homeProvider,
  ) {
    return SingleChildScrollView(
      child: PopScope(
        onPopInvokedWithResult: (_, __) {
          authProvider.clearValues();
        },
        child: SizedBox(
          child: Form(
            key: authProvider.loginFormKey,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    verticalSpaceSmall,
                    Text(
                      "Welcome Back",
                      style: context.customTextTheme.text24W600
                          .copyWith(color: AppColors.kWhite),
                    ),
                    verticalSpaceSmall,
                    Text(
                      "Enter your email and password to log in",
                      style: context.customTextTheme.text12W400
                          .copyWith(color: AppColors.kWhite),
                    ),
                    verticalSpaceMedium,
                    CustomTextField(
                      textColor: AppColors.kWhite,
                      controller: authProvider.loginUserNameController,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(FluentIcons.mail_24_regular,
                          color: AppColors.kGray3),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    verticalSpaceRegular,
                    CustomTextField(
                      textColor: AppColors.kWhite,
                      controller: authProvider.loginUserPasswordController,
                      hintText: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(FluentIcons.password_24_regular,
                          color: AppColors.kGray3),
                      obscureText: authProvider.loginPasswordHide,
                      suffixIcon: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: authProvider.toggleLoginPassword,
                          child: Icon(
                            authListener.loginPasswordHide
                                ? FluentIcons.eye_24_regular
                                : FluentIcons.eye_off_24_regular,
                            color: AppColors.kGray3,
                          )),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        // FormBuilderValidators.password(),
                      ]),
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    verticalSpaceMedium,
                    InkWell(
                      onTap: () {
                        // context.router.push(const ForgotPasswordScreenRoute());
                        authProvider
                            .onChangeSelectedAuthView(AuthView.forgotPassword);
                      },
                      child: Text(
                        "Forgot Password ?",
                        style: context.customTextTheme.text14W700
                            .copyWith(color: AppColors.kWhite),
                      ),
                    ),
                    verticalSpaceSmall,
                    InkWell(
                      onTap: authListener.loginLoading
                          ? null
                          : () async {
                              final validated =
                                  authProvider.validateLoginForm();
                              if (validated) {
                                await authProvider
                                    .loginUser()
                                    .then((logged) async {
                                  if (logged) {
                                    AlertDialogs.showSuccess(
                                        "Login successfully!");
                                    if (widget.showBackButton) {
                                      await context
                                          .read<UserProvider>()
                                          .getUserData();
                                      context
                                          .read<CartProvider>()
                                          .checkUserIsLogged();
                                      if (context.mounted) {
                                        Navigator.pop(context, true);
                                      }
                                      return;
                                    }

                                    homeProvider.onChangeCurrentPage(0);
                                    DependencyRegistrar.initializeAllProviders(
                                        context);
                                    await Future.delayed(
                                        const Duration(seconds: 1), () {
                                      context.router.replaceAll([
                                        const OrderOnlineScreenRoute(),
                                      ]).then((_) {
                                        authProvider.clearValues();
                                        // productProvider.getAllCategories();
                                      });
                                    });
                                  }
                                });
                              }
                            },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary),
                        height: 50,
                        width: context.screenWidth,
                        child: Center(
                          child: !authListener.loginLoading
                              ? Text(
                                  "Log In",
                                  style: context.customTextTheme.text16W400
                                      .copyWith(color: AppColors.kBlack),
                                )
                              : showButtonProgress(Colors.black),
                        ),
                      ),
                    ),
                    verticalSpaceLarge,
                    Visibility(
                      visible: authListener.isRegisterMode == false,
                      child: Row(
                        children: [
                          const Flexible(
                              child: Divider(
                            thickness: 2,
                            color: AppColors.kGray,
                          )),
                          horizontalSpaceMedium,
                          Text(
                            'OR',
                            style: context.customTextTheme.text12W600
                                .copyWith(color: AppColors.kGray),
                          ),
                          horizontalSpaceMedium,
                          const Flexible(
                              child: Divider(
                            thickness: 2,
                            color: AppColors.kGray,
                          )),
                        ],
                      ),
                    ),
                    verticalSpaceMedium,
                    RichText(
                      text: TextSpan(
                        style: context.customTextTheme.text14W500
                            .copyWith(color: AppColors.kWhite),
                        children: [
                          const TextSpan(text: "Don't have an account?   "),
                          TextSpan(
                            text: "Sign Up",
                            style: context.customTextTheme.text14W700
                                .copyWith(color: AppColors.kWhite),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                authProvider.onChangeSelectedAuthView(
                                    AuthView.register);
                                authProvider.clearValues();
                                // context.router.push(const RegisterScreenRoute());
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: widget.showBackButton,
                  child: Positioned(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.kGray3,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerFormParent(
      AuthProvider authProvider,
      BuildContext context,
      HomeProvider homeProvider,
      HomeProvider homeListener,
      AuthProvider authListener) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        authProvider.clearValues(registerControllersOnly: true);
      },
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Visibility(
                visible: authListener.currentRegStage != RegStage.success,
                child: IconButton(
                  onPressed: () {
                    if (authListener.currentRegStage == RegStage.contact) {
                      authListener.onChangeSelectedAuthView(AuthView.login);
                      authProvider.clearValues(registerControllersOnly: true);
                    } else if (authListener.currentRegStage ==
                        RegStage.otpEmail) {
                      authProvider.updateCurrentRegStage(RegStage.contact);
                    } else if (authListener.currentRegStage ==
                        RegStage.otpPhone) {
                      authProvider.updateCurrentRegStage(RegStage.otpEmail);
                    } else if (authListener.currentRegStage ==
                        RegStage.register) {
                      // Go back to the last OTP stage
                      if (authProvider.smsRequired &&
                          authProvider.emailRequired) {
                        authProvider.updateCurrentRegStage(RegStage.otpPhone);
                      } else if (authProvider.emailRequired) {
                        authProvider.updateCurrentRegStage(RegStage.otpEmail);
                      } else if (authProvider.smsRequired) {
                        authProvider.updateCurrentRegStage(RegStage.otpPhone);
                      } else {
                        authProvider.updateCurrentRegStage(RegStage.contact);
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kGray3,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                verticalSpaceSmall,
                authListener.currentRegStage == RegStage.success
                    ? const SizedBox.shrink()
                    : Text(
                        _getRegisterTitle(authListener),
                        style: context.customTextTheme.text20W600
                            .copyWith(color: AppColors.kWhite),
                      ),
                verticalSpaceSmall,
                authListener.currentRegStage == RegStage.success
                    ? const SizedBox.shrink()
                    : Text(
                        _getRegisterSubtitle(authListener),
                        style: context.customTextTheme.text12W400
                            .copyWith(color: AppColors.kWhite),
                      ),
                verticalSpaceMedium,
                _buildRegisterContent(authProvider, context, authListener),
                verticalSpaceRegular,
                _buildRegisterActionButton(authProvider, context, authListener),
                verticalSpaceLarge,
                Visibility(
                  visible: authListener.currentRegStage == RegStage.contact,
                  child: Row(
                    children: [
                      const Flexible(
                          child: Divider(
                        thickness: 2,
                        color: AppColors.kGray,
                      )),
                      horizontalSpaceMedium,
                      Text(
                        'OR',
                        style: context.customTextTheme.text12W600
                            .copyWith(color: AppColors.kGray),
                      ),
                      horizontalSpaceMedium,
                      const Flexible(
                          child: Divider(
                        thickness: 2,
                        color: AppColors.kGray,
                      )),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                Visibility(
                  visible: authListener.currentRegStage == RegStage.contact,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account?  ",
                          style: context.customTextTheme.text14W500
                              .copyWith(color: AppColors.kWhite),
                        ),
                        TextSpan(
                          text: "Login",
                          style: context.customTextTheme.text14W700
                              .copyWith(color: AppColors.kWhite),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              authProvider.initializeRegistrationFlow();
                              authProvider
                                  .onChangeSelectedAuthView(AuthView.login);
                            },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRegisterTitle(AuthProvider authListener) {
    switch (authListener.currentRegStage) {
      case RegStage.contact:
        return "Create Account";
      case RegStage.otpEmail:
        // When both enabled, don't show title for email verification
        // if (authListener.emailRequired && authListener.smsRequired) {
        //   return "";
        // }
        // return "Verify Email";
        return '';
      case RegStage.otpPhone:
        // When both enabled, don't show title for phone verification
        // if (authListener.emailRequired && authListener.smsRequired) {
        //   return "";
        // }
        // return "Verify Phone";
        return '';
      case RegStage.register:
        return "Create Account";
      case RegStage.success:
        return "";
    }
  }

  String _getRegisterSubtitle(AuthProvider authListener) {
    switch (authListener.currentRegStage) {
      case RegStage.contact:
        return "Please enter your details to create an account";
      case RegStage.otpEmail:
        // When both enabled, don't show subtitle for email verification
        // if (authListener.emailRequired && authListener.smsRequired) {
        //   return "";
        // }
        return "";
      case RegStage.otpPhone:
        // When both enabled, don't show subtitle for phone verification
        // if (authListener.emailRequired && authListener.smsRequired) {
        //   return "";
        // }
        // return "Enter the OTP sent to your phone";
        return '';
      case RegStage.register:
        return "Set your password to complete registration";
      case RegStage.success:
        return "";
    }
  }

  Widget _buildRegisterContent(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    switch (authListener.currentRegStage) {
      case RegStage.contact:
        return _registerForm1(authProvider, context, authListener);
      case RegStage.otpEmail:
        // Only show email OTP if email is required
        if (!authProvider.emailRequired) {
          // If email is not required but phone is, go to phone OTP
          if (authProvider.smsRequired) {
            return _inlinePhoneOtpWidget(authProvider, context, authListener);
          }
          // If neither is required, go to register
          return _registerForm2(authProvider, context, authListener);
        }
        return _inlineEmailOtpWidget(authProvider, context, authListener);
      case RegStage.otpPhone:
        // Only show phone OTP if SMS is required
        if (!authProvider.smsRequired) {
          // If SMS is not required but email is, go to register
          if (authProvider.emailRequired && authProvider.emailOtpVerified) {
            return _registerForm2(authProvider, context, authListener);
          }
          // If neither is required, go to register
          return _registerForm2(authProvider, context, authListener);
        }
        return _inlinePhoneOtpWidget(authProvider, context, authListener);
      case RegStage.register:
        return _registerForm2(authProvider, context, authListener);
      case RegStage.success:
        return _successWidget(authProvider, context, authListener);
    }
  }

  Widget _buildRegisterActionButton(AuthProvider authProvider,
      BuildContext context, AuthProvider authListener) {
    // When both OTP are enabled and we're in OTP stages, the button is hidden
    // because OTP auto-verifies on completion
    if (authProvider.emailRequired &&
        authProvider.smsRequired &&
        (authListener.currentRegStage == RegStage.otpEmail ||
            authListener.currentRegStage == RegStage.otpPhone)) {
      // Show verify button only for the manual verify case (when both enabled, we auto-verify)
      // Still show it for the phone OTP step when it's the last one
      if (authListener.currentRegStage == RegStage.otpEmail) {
        // For email when both enabled - auto-verify, no button needed
        return const SizedBox.shrink();
      }
    }

    return InkWell(
      onTap: authListener.registerLoading || authListener.loginLoading
          ? null
          : () => _onRegisterButtonTap(authProvider, context, authListener),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary),
        height: 50,
        width: context.screenWidth,
        child: Center(
            child: !authListener.registrationButtonLoading
                ? Text(
                    _getRegisterButtonText(authListener),
                    style: context.customTextTheme.text16W400
                        .copyWith(color: AppColors.kWhite),
                  )
                : showButtonProgress(Colors.white)),
      ),
    );
  }

  String _getRegisterButtonText(AuthProvider authListener) {
    switch (authListener.currentRegStage) {
      case RegStage.contact:
        return "Next";
      case RegStage.otpEmail:
        // When both enabled, email OTP auto-verifies
        if (authListener.emailRequired && authListener.smsRequired) {
          return "";
        }
        return "Verify Email OTP";
      case RegStage.otpPhone:
        return "Verify Phone OTP";
      case RegStage.register:
        return "Register";
      case RegStage.success:
        return "Go To Login Page";
    }
  }

  Future<void> _onRegisterButtonTap(AuthProvider authProvider,
      BuildContext context, AuthProvider authListener) async {
    switch (authListener.currentRegStage) {
      case RegStage.contact:
        final phoneValid = authProvider.validatePhoneForm();
        final emailValid = authProvider.validateEmailForm();
        if (!phoneValid || !emailValid) return;

        final isAvailable = await authProvider.checkUserAlreadyRegistered();
        if (!isAvailable) {
          if (authProvider.verifyResponse?.isPartialUser == true) {
            _showLinkDialog(context, authProvider);
          } else {
            AlertDialogs.showError(
              authProvider.verifyResponse?.message ?? "User already exists",
            );
          }
          return;
        }

        // Read store settings
        final settings = context.read<ShopProvider>().storeSettings.data;
        authProvider.initializeOtpRequirement(settings!);

        if (!authProvider.smsRequired && !authProvider.emailRequired) {
          // Case 4: Both disabled - Skip OTP, go directly to register
          authProvider.updateCurrentRegStage(RegStage.register);
        } else if (authProvider.emailRequired && authProvider.smsRequired) {
          // Case 1: Both enabled - Send BOTH OTPs simultaneously
          await Future.wait([
            authProvider.sendEmailOtpForInline(),
            authProvider.sendPhoneOtpForInline(),
          ]);
          // Go to a combined OTP screen (use otpEmail stage but show both)
          authProvider.updateCurrentRegStage(RegStage.otpEmail);
          startTimer();
        } else if (authProvider.emailRequired) {
          // Case 3: Only email
          await authProvider.sendEmailOtpForInline();
          authProvider.updateCurrentRegStage(RegStage.otpEmail);
          startTimer();
        } else {
          // Case 2: Only SMS
          await authProvider.sendPhoneOtpForInline();
          authProvider.updateCurrentRegStage(RegStage.otpPhone);
          startTimer();
        }
        break;

      case RegStage.otpEmail:
        if (authProvider.emailOtpController.text.isEmpty) {
          AlertDialogs.showError("Please enter the email OTP");
          return;
        }
        final verified = authProvider.verifyEmailOtpForInline();
        if (verified) {
          AlertDialogs.showSuccess("Email verified successfully!");
          // Check if phone OTP is also needed
          if (authProvider.smsRequired) {
            final phoneOtpSent = await authProvider.sendPhoneOtpForInline();
            if (phoneOtpSent) {
              authProvider.updateCurrentRegStage(RegStage.otpPhone);
              startTimer();
            } else {
              AlertDialogs.showError(
                  "Failed to send phone OTP. Please try again.");
            }
          } else {
            authProvider.updateCurrentRegStage(RegStage.register);
          }
        } else {
          // Error is set inline in the widget - no need for snackbar
        }
        break;

      case RegStage.otpPhone:
        if (authProvider.phoneOtpController.text.isEmpty) {
          AlertDialogs.showError("Please enter the phone OTP");
          return;
        }
        final verified = await authProvider.verifyPhoneOtpForInline();
        if (verified) {
          AlertDialogs.showSuccess("Phone verified successfully!");
          authProvider.updateCurrentRegStage(RegStage.register);
        }
        break;

      case RegStage.register:
        final validated = authProvider.validateRegisterForm2();
        if (validated) {
          final registered = await authProvider.registerUser();
          if (registered) {
            AlertDialogs.showSuccess('Account Created Successfully');
            authProvider.loginUserNameController.text =
                authProvider.registerUserEmailController.text;
            authProvider.loginUserPasswordController.text =
                authProvider.registerUserPasswordController.text;
            final loggedIn = await authProvider.loginUser();
            if (loggedIn) {
              if (widget.showBackButton) {
                Navigator.pop(context, true);
                context.read<UserProvider>().getUserData();
                context.read<CartProvider>().checkUserIsLogged();
              }
              authProvider.initializeRegistrationFlow();
              authProvider.clearValues();
              authProvider.onChangeSelectedAuthView(AuthView.login);
            }
          } else {
            AlertDialogs.showError('Registration failed. Please try again.');
          }
        }
        break;

      case RegStage.success:
        authProvider.initializeRegistrationFlow();
        authProvider.onChangeSelectedAuthView(AuthView.login);
        break;
    }
  }

  void _showLinkDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Link Mobile Number"),
        content: Text(authProvider.verifyResponse?.message ?? ""),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Call Link API
              authProvider.linkPartialUser().then((linked) {
                if (linked) {
                  // Proceed with OTP flow
                  if (!authProvider.smsRequired &&
                      !authProvider.emailRequired) {
                    authProvider.updateCurrentRegStage(RegStage.register);
                  } else if (authProvider.emailRequired &&
                      authProvider.smsRequired) {
                    authProvider.sendEmailOtpForInline().then((_) {
                      authProvider.updateCurrentRegStage(RegStage.otpEmail);
                    });
                  } else if (authProvider.emailRequired) {
                    authProvider.sendEmailOtpForInline().then((_) {
                      authProvider.updateCurrentRegStage(RegStage.otpEmail);
                    });
                  } else {
                    authProvider.sendPhoneOtpForInline().then((_) {
                      authProvider.updateCurrentRegStage(RegStage.otpPhone);
                    });
                  }
                }
              });
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Widget _otpWidget(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    return Column(
      children: [
        PopScope(
          canPop: true,
          onPopInvokedWithResult: (_, __) =>
              authProvider.phoneOtpController.clear(),
          child: PinCodeTextField(
            textStyle: const TextStyle(
              color: AppColors.kWhite,
            ),
            length: 4,
            obscureText: false,
            animationType: AnimationType.scale,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10.0),
              activeColor: AppColors.kBlack,
              inactiveColor: AppColors.kGray,
              inactiveFillColor: AppColors.kWhite.withOpacity(0.1),
              activeFillColor: AppColors.kWhite.withOpacity(0.1),
              selectedColor: Theme.of(context).colorScheme.primary,
              selectedFillColor: AppColors.kWhite.withOpacity(0.1),
              fieldHeight: MediaQuery.of(context).size.width * 0.12,
              fieldWidth: MediaQuery.of(context).size.width * 0.12,
              fieldOuterPadding: const EdgeInsets.all(16.0),
            ),
            controller: authProvider.phoneOtpController,
            showCursor: false,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            keyboardType: TextInputType.phone,
            onCompleted: (v) {},
            onChanged: (value) {},
            appContext: context,
            autoDisposeControllers: false,
          ),
        ),
        PopScope(
          canPop: true,
          onPopInvokedWithResult: (_, __) =>
              authProvider.emailOtpController.clear(),
          child: PinCodeTextField(
            textStyle: const TextStyle(
              color: AppColors.kWhite,
            ),
            length: 4,
            obscureText: false,
            animationType: AnimationType.scale,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10.0),
              activeColor: AppColors.kBlack,
              inactiveColor: AppColors.kGray,
              inactiveFillColor: AppColors.kWhite.withOpacity(0.1),
              activeFillColor: AppColors.kWhite.withOpacity(0.1),
              selectedColor: Theme.of(context).colorScheme.primary,
              selectedFillColor: AppColors.kWhite.withOpacity(0.1),
              fieldHeight: MediaQuery.of(context).size.width * 0.12,
              fieldWidth: MediaQuery.of(context).size.width * 0.12,
              fieldOuterPadding: const EdgeInsets.all(16.0),
            ),
            controller: authProvider.emailOtpController,
            showCursor: false,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            keyboardType: TextInputType.phone,
            onCompleted: (v) {},
            onChanged: (value) {},
            appContext: context,
            autoDisposeControllers: false,
          ),
        )
      ],
    );
  }

  //Widget 4
  Widget _successWidget(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FluentIcons.checkmark_circle_24_regular,
              size: 100, color: Colors.green.shade500),
          verticalSpaceSmall,
          authListener.selectedAuthView == AuthView.register
              ? Text('Account Created\nSuccessfully',
                  textAlign: TextAlign.center,
                  style: context.customTextTheme.text24W600
                      .copyWith(color: AppColors.kWhite))
              : Text('Password Reset\nSuccessfully',
                  textAlign: TextAlign.center,
                  style: context.customTextTheme.text24W600
                      .copyWith(color: AppColors.kWhite)),
          verticalSpaceTiny,
          authListener.selectedAuthView == AuthView.register
              ? Text(
                  textAlign: TextAlign.center,
                  'Your Account Created Successfully. Shop Your Favourite Products',
                  style: context.customTextTheme.text14W400
                      .copyWith(color: AppColors.kWhite),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _inlineEmailOtpWidget(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    final bool bothEnabled =
        authProvider.emailRequired && authProvider.smsRequired;

    // If email is not required, don't show email OTP widget at all
    if (!authProvider.emailRequired) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<int>(
      stream: _streamController.stream,
      initialData: _secondsRemaining,
      builder: (context, snapshot) {
        return Form(
          key: authProvider.emailFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              // Email verification header with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FluentIcons.mail_24_regular,
                      color: AppColors.kWhite, size: 20),
                  horizontalSpaceSmall,
                  Text(
                    "Email Verification",
                    style: context.customTextTheme.text16W600
                        .copyWith(color: AppColors.kWhite),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.kWhite.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "📧 ${authProvider.registerUserEmailController.text}",
                  style: context.customTextTheme.text14W400
                      .copyWith(color: AppColors.kWhite),
                ),
              ),
              verticalSpaceRegular,
              // Email OTP Field
              PinCodeTextField(
                textStyle: const TextStyle(
                  color: AppColors.kWhite,
                ),
                length: 4,
                obscureText: false,
                animationType: AnimationType.scale,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10.0),
                  activeColor: AppColors.kBlack,
                  inactiveColor: AppColors.kGray,
                  inactiveFillColor: AppColors.kWhite.withOpacity(0.1),
                  activeFillColor: AppColors.kWhite.withOpacity(0.1),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  selectedFillColor: AppColors.kWhite.withOpacity(0.1),
                  fieldHeight: MediaQuery.of(context).size.width * 0.12,
                  fieldWidth: MediaQuery.of(context).size.width * 0.12,
                  fieldOuterPadding: const EdgeInsets.all(8.0),
                ),
                controller: authProvider.emailOtpController,
                showCursor: false,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                onCompleted: (v) async {
                  print("COMPLETED: $v");
                  // Auto-verify when both OTPs are enabled
                  if (bothEnabled && authProvider.smsRequired) {
                    final verified = authProvider.verifyEmailOtpForInline();

                    if (verified) {
                      final sent = await authProvider.sendPhoneOtpForInline();

                      if (sent) {
                        startTimer();
                      }
                    }
                  }
                },
                onChanged: (value) {
                  print("Email OTP: $value");
                  // Clear error when typing
                  if (authProvider.emailOtpError.isNotEmpty &&
                      value.isNotEmpty) {
                    // Reset error state via internal set
                  }
                },
                appContext: context,
                autoDisposeControllers: false,
              ),
              // Error message display
              if (authProvider.emailOtpError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    authProvider.emailOtpError,
                    style: context.customTextTheme.text14W500
                        .copyWith(color: Colors.red.shade300),
                  ),
                ),
              // Verified indicator
              if (authProvider.emailOtpVerified)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green.shade400, size: 20),
                      horizontalSpaceSmall,
                      Text(
                        "✓ Email Verified",
                        style: context.customTextTheme.text14W600
                            .copyWith(color: Colors.green.shade400),
                      ),
                    ],
                  ),
                ),
              verticalSpaceSmall,
              if (snapshot.data! > 0 && !authProvider.emailOtpVerified)
                Text(
                  "Resend OTP in ${snapshot.data} seconds",
                  style: context.customTextTheme.text14W700
                      .copyWith(color: AppColors.kWhite),
                )
              else if (!authProvider.emailOtpVerified)
                TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () async {
                    final result = await authProvider.sendEmailOtpForInline();
                    if (result) {
                      AlertDialogs.showSuccess("OTP sent successfully");
                      startTimer();
                    }
                  },
                  icon: authProvider.sendOtpLoading
                      ? const CupertinoActivityIndicator(
                          color: AppColors.kWhite)
                      : const SizedBox.shrink(),
                  label: Text(
                    'Resend OTP',
                    style: context.customTextTheme.text14W700
                        .copyWith(color: AppColors.kWhite),
                  ),
                ),
              // When both enabled and email verified, show phone section
              if (bothEnabled && authProvider.emailOtpVerified) ...[
                verticalSpaceMedium,
                const Divider(color: AppColors.kGray),
                verticalSpaceSmall,
                if (authProvider.phoneOtpSending)
                  const CircularProgressIndicator(color: AppColors.kWhite)
                else
                  _inlinePhoneOtpWidget(authProvider, context, authListener),
              ],

              // When only email is enabled, don't show anything after email verification
              if (authProvider.emailRequired &&
                  !authProvider.smsRequired &&
                  authProvider.emailOtpVerified)
                const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _inlinePhoneOtpWidget(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    final bool bothEnabled =
        authProvider.emailRequired && authProvider.smsRequired;
    final bool onlyPhone =
        !authProvider.emailRequired && authProvider.smsRequired;

    // If SMS is disabled, don't show phone OTP widget at all
    if (!authProvider.smsRequired) {
      return const SizedBox.shrink();
    }

    // Get phone number mask
    String phoneText = authProvider.registerUserPhoneController.text;
    String maskedPhone = phoneText.length > 8
        ? "${phoneText.substring(0, 2)}****${phoneText.substring(phoneText.length - 4)}"
        : phoneText;

    Widget buildPhoneContent(int? seconds) {
      return Column(
        children: [
          // Phone verification header with icon - only show when not both enabled
          if (!bothEnabled) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FluentIcons.phone_24_regular,
                    color: AppColors.kWhite, size: 20),
                horizontalSpaceSmall,
                Text(
                  "Mobile Verification",
                  style: context.customTextTheme.text16W600
                      .copyWith(color: AppColors.kWhite),
                ),
              ],
            ),
            verticalSpaceSmall,
          ],
          verticalSpaceSmall,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.kWhite.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "📱 ${AppConfig.instance.country.dialCode}$maskedPhone",
              style: context.customTextTheme.text14W400
                  .copyWith(color: AppColors.kWhite),
            ),
          ),
          verticalSpaceRegular,
          // Phone OTP Field - disabled until email is verified when both enabled
          PinCodeTextField(
            textStyle: const TextStyle(
              color: AppColors.kWhite,
            ),
            length: 4,
            obscureText: false,
            animationType: AnimationType.scale,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10.0),
              activeColor: AppColors.kBlack,
              inactiveColor: AppColors.kGray,
              inactiveFillColor: bothEnabled && !authProvider.emailOtpVerified
                  ? AppColors.kGray.withOpacity(0.3)
                  : AppColors.kWhite.withOpacity(0.1),
              activeFillColor: bothEnabled && !authProvider.emailOtpVerified
                  ? AppColors.kGray.withOpacity(0.3)
                  : AppColors.kWhite.withOpacity(0.1),
              selectedColor: Theme.of(context).colorScheme.primary,
              selectedFillColor: bothEnabled && !authProvider.emailOtpVerified
                  ? AppColors.kGray.withOpacity(0.3)
                  : AppColors.kWhite.withOpacity(0.1),
              fieldHeight: MediaQuery.of(context).size.width * 0.12,
              fieldWidth: MediaQuery.of(context).size.width * 0.12,
              fieldOuterPadding: const EdgeInsets.all(8.0),
            ),
            controller: authProvider.phoneOtpController,
            showCursor: false,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            readOnly: bothEnabled && !authProvider.emailOtpVerified,
            onCompleted: (v) {
              // Only auto-verify when ONLY phone is enabled
              if (onlyPhone) {
                _onAutoVerifyPhoneOtp(authProvider, context);
              }
              // When both enabled, user must click verify button manually
            },
            onChanged: (value) {},
            appContext: context,
            autoDisposeControllers: false,
          ),
          // Error message display
          if (authProvider.phoneOtpError.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                authProvider.phoneOtpError,
                style: context.customTextTheme.text14W500
                    .copyWith(color: Colors.red.shade300),
              ),
            ),
          // Verified indicator
          if (authProvider.phoneOtpVerified)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle,
                      color: Colors.green.shade400, size: 20),
                  horizontalSpaceSmall,
                  Text(
                    "✓ Mobile Verified",
                    style: context.customTextTheme.text14W600
                        .copyWith(color: Colors.green.shade400),
                  ),
                ],
              ),
            ),
          verticalSpaceSmall,
          // Only show resend timer for single phone OTP flow
          if (!bothEnabled) ...[
            if (seconds != null &&
                seconds > 0 &&
                !authProvider.phoneOtpVerified)
              Text(
                "Resend OTP in $seconds seconds",
                style: context.customTextTheme.text14W700
                    .copyWith(color: AppColors.kWhite),
              )
            else if (!authProvider.phoneOtpVerified)
              TextButton.icon(
                iconAlignment: IconAlignment.end,
                onPressed: () async {
                  final result = await authProvider.sendPhoneOtpForInline();
                  if (result) {
                    AlertDialogs.showSuccess("OTP sent successfully");
                    startTimer();
                  }
                },
                icon: authProvider.sendOtpLoading
                    ? const CupertinoActivityIndicator(color: AppColors.kWhite)
                    : const SizedBox.shrink(),
                label: Text(
                  'Resend OTP',
                  style: context.customTextTheme.text14W700
                      .copyWith(color: AppColors.kWhite),
                ),
              ),
          ],
        ],
      );
    }

    // For standalone phone-only flow, wrap in StreamBuilder for timer
    if (!bothEnabled) {
      return StreamBuilder<int>(
        stream: _streamController.stream,
        initialData: _secondsRemaining,
        builder: (context, snapshot) {
          return buildPhoneContent(snapshot.data);
        },
      );
    }
    // For both-enabled flow (called from email widget), no timer needed
    return buildPhoneContent(null);
  }

  Future<void> _onAutoVerifyPhoneOtp(
      AuthProvider authProvider, BuildContext context) async {
    if (authProvider.phoneOtpController.text.isEmpty) return;

    print("Auto-verifying phone OTP...");
    final verified = await authProvider.verifyPhoneOtpForInline();
    print("Phone OTP verification result: $verified");

    if (verified) {
      print("Phone verified, moving to register screen...");
      // Auto-move to register screen after a brief delay
      await Future.delayed(const Duration(milliseconds: 800));
      if (context.mounted) {
        authProvider.updateCurrentRegStage(RegStage.register);
      }
    } else {
      print("Phone OTP verification failed");
    }
  }

  Widget _forgotEmailForm(AuthProvider authProvider, AuthProvider authListener,
      BuildContext context) {
    final themeListener = context.watch<ThemeProvider>();
    return FormBuilder(
      key: authListener.resetFormKey,
      child: FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // key: authListener.emailFieldKey,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.email(),
        ]),
        style: const TextStyle(color: AppColors.kWhite),

        decoration: InputDecoration(
            fillColor: Colors.white.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(FluentIcons.mail_24_regular,
                color: AppColors.kGray3),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            hintText: "Email",
            hintStyle: TextStyle(color: Colors.grey)),
        name: 'email-address',
      ),
    );
  }

  Widget _forgotWidgetParent(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    final widgets = [
      _forgotEmailForm(authProvider, authListener, context),
      _forgotNewPasswordForm(authProvider, authListener, context),
      _successWidget(authProvider, context, authListener),

      // _forgotWidget(authProvider, context, authListener),
    ];
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: authListener.currentForgotForm != 2,
              child: IconButton(
                onPressed: () {
                  if (widget.isFromProfile) {
                    Navigator.pop(context);
                  }
                  if (authListener.currentForgotForm == 0) {
                    authProvider.onChangeSelectedAuthView(AuthView.login);
                  }

                  if (authListener.currentForgotForm == 1) {
                    authProvider
                        .onChangeSelectedAuthView(AuthView.forgotPassword);
                    authProvider.updateCurrentForgotForm(
                        (authListener.currentForgotForm - 1) % widgets.length);
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.kGray3,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SizedBox(
              //     height: 200,
              //     child: Image(image: AssetImage(Assets.images.loginImage.path))),
              verticalSpaceSmall,

              authListener.currentForgotForm == 0
                  ? Text('Reset Password',
                      textAlign: TextAlign.center,
                      style: context.customTextTheme.text18W600
                          .copyWith(color: AppColors.kWhite))
                  : const SizedBox.shrink(),
              verticalSpaceSmall,
              authListener.currentForgotForm == 0
                  ? Text(
                      textAlign: TextAlign.center,
                      'Enter Your Email Address To Reset Your Password',
                      style: context.customTextTheme.text12W400
                          .copyWith(color: AppColors.kWhite),
                    )
                  : authListener.currentForgotForm == 1
                      ? Text(
                          textAlign: TextAlign.center,
                          'Enter OTP To Reset Your Password',
                          style: context.customTextTheme.text14W400
                              .copyWith(color: AppColors.kWhite),
                        )
                      : const SizedBox.shrink(),
              verticalSpaceRegular,
              AnimatedCrossFade(
                firstChild: widgets[authListener.currentForgotForm],
                secondChild: widgets[
                    (authListener.currentForgotForm + 1) % widgets.length],
                duration: const Duration(seconds: 1),
                firstCurve: Curves.ease,
                secondCurve: Curves.ease,
                reverseDuration: const Duration(seconds: 1),
                sizeCurve: Curves.ease,
                crossFadeState: CrossFadeState.showFirst,
              ),

              verticalSpaceSmall,

              InkWell(
                onTap: authListener.resetLoading
                    ? null
                    : () async {
                        if (authListener.currentForgotForm == 0) {
                          final isValidated =
                              await authProvider.resetPassword();
                          if (isValidated) {
                            authProvider.resetFormKey.currentState?.save();
                            AlertDialogs.showSuccess('Otp Sent Successfully!');
                            startTimer();
                            authProvider.updateCurrentForgotForm(1);
                          } else {
                            log('INVALIDATED', name: 'isValidated');
                          }
                        } else if (authListener.currentForgotForm == 1) {
                          final isValidated =
                              await authProvider.validateResetPasswordOTP();
                          if (isValidated) {
                            AlertDialogs.showSuccess(
                                "Password Changed successfully!");
                            authProvider.updateCurrentForgotForm(2);
                            return;
                          } else {
                            log('INVALIDATED', name: 'isValidated');
                          }
                        } else if (authListener.currentForgotForm == 2) {
                          if (widget.isFromProfile) {
                            context.router.back();
                          } else {
                            setState(() {
                              widget.isFromProfile = false;
                            });
                          }
                          authProvider.onChangeSelectedAuthView(AuthView.login);
                          authProvider.updateCurrentForgotForm(0);
                        }
                      },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary),
                  height: 50,
                  width: context.screenWidth,
                  child: Center(
                      child: authListener.resetLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.kWhite),
                              ))
                          : Text(
                              authListener.currentForgotForm == 0
                                  ? 'Request OTP'
                                  : authListener.currentForgotForm == 1
                                      ? 'Submit'
                                      : 'Done',
                              style: context.customTextTheme.text16W400
                                  .copyWith(color: AppColors.kWhite),
                            )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _forgotNewPasswordForm(AuthProvider authProvider,
      AuthProvider authListener, BuildContext context) {
    final themeListener = context.watch<ThemeProvider>();
    return FormBuilder(
      key: authListener.changePasswordFormKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'OTP',
            validator: FormBuilderValidators.required(
              errorText: 'Required OTP',
            ),
            style: const TextStyle(color: AppColors.kWhite),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
                fillColor: Colors.white.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.confirmation_number_outlined,
                    color: AppColors.kGray3),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                hintText: "OTP",
                hintStyle: TextStyle(color: Colors.grey)),
          ),
          verticalSpaceRegular,
          FormBuilderTextField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: authListener.newPasswordFieldKey,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.password(),
            ]),
            style: const TextStyle(color: AppColors.kWhite),
            // obscureText: authListener.resetPasswordHide,
            decoration: InputDecoration(
                fillColor: Colors.white.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(
                  FluentIcons.password_24_regular,
                  color: AppColors.kGray3,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                hintText: "New Password",
                hintStyle: TextStyle(color: Colors.grey)),
            name: 'new-password',
          ),
          verticalSpaceRegular,
          FormBuilderTextField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.password(),
              FormBuilderValidators.equal(
                authProvider.newPassword,
                checkNullOrEmpty: false,
                errorText: "Passwords do not match",
              ),
            ]),
            obscureText: authListener.resetPasswordHide,
            style: const TextStyle(color: AppColors.kWhite),
            decoration: InputDecoration(
                fillColor: Colors.white.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(
                  FluentIcons.password_24_regular,
                  color: AppColors.kGray3,
                ),
                suffixIcon: InkWell(
                    onTap: () {
                      authProvider.toggleResetPassword();
                    },
                    child: Icon(
                        authListener.resetPasswordHide
                            ? FluentIcons.eye_24_regular
                            : FluentIcons.eye_off_24_regular,
                        color: AppColors.kGray3)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                hintText: "Confirm Password",
                hintStyle: TextStyle(color: Colors.grey)),
            name: 'confirm-password',
          ),
          verticalSpaceSmall,
          StreamBuilder<int>(
            stream: _streamController.stream,
            initialData: _secondsRemaining,
            builder: (context, snapshot) {
              if (snapshot.data! > 0) {
                return Text(
                  "Resend OTP in ${snapshot.data} seconds",
                  style: context.customTextTheme.text14W700
                      .copyWith(color: AppColors.kWhite),
                );
              } else {
                return TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () async {
                    final result =
                        await authProvider.resetPassword(isResendOTP: true);

                    if (result) {
                      AlertDialogs.showSuccess("OTP sent successfully");
                    }
                  },
                  icon: authListener.resetLoadingSecondary
                      ? const CupertinoActivityIndicator(
                          color: AppColors.kWhite)
                      : const SizedBox.shrink(),
                  label: Text(
                    'Resend OTP',
                    style: context.customTextTheme.text14W700
                        .copyWith(color: AppColors.kWhite),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _registerForm1(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        verticalSpaceSmall,
        _phoneInputForm(authProvider, context, authListener),
        _emailInputForm(authProvider, context, authListener),
      ],
    );
  }

  Widget _phoneInputForm(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    final shopProvider = context.watch<ShopProvider>();

    return Form(
      key: authProvider.phoneFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomTextField(
          textColor: AppColors.kWhite,
          fillColor: Colors.white.withOpacity(0.1),
          controller: authProvider.registerUserPhoneController,
          hintText: "Phone Number",
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          textInputAction: TextInputAction.done,
          prefixIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SmsAvailableCountrieData>(
                value: shopProvider.selectedCountry,
                isDense: true,
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: shopProvider.smsCountries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Row(
                      children: [
                        Text(
                          countryCodeToEmoji(country.iso ?? ""),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          country.code ?? "",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    shopProvider.updateSelectedCountry(value);
                  }
                },
              ),
            ),
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.match(
              RegExp((r'^[0-9]{10,11}$')),
              errorText:
                  'Enter valid ${AppConfig.instance.country.name} number',
            ),
          ]),
        ),
      ),
    );
  }

  Widget _emailInputForm(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    return Form(
      key: authProvider.emailFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomTextField(
          textColor: AppColors.kWhite,
          fillColor: Colors.white.withOpacity(0.1),
          controller: authProvider.registerUserEmailController,
          hintText: "Email Address",
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          prefixIcon:
              const Icon(FluentIcons.mail_24_regular, color: AppColors.kGray3),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ),
      ),
    );
  }

  Widget _registerForm2(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    return Form(
      key: authProvider.registerFormKey2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First Name
          CustomTextField(
            textColor: AppColors.kWhite,
            fillColor: Colors.white.withOpacity(0.1),
            controller: authProvider.registerUserFirstNameController,
            hintText: "First Name",
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(FluentIcons.person_24_regular,
                color: AppColors.kGray3),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),

          verticalSpaceRegular,
          // Last Name
          CustomTextField(
            textColor: AppColors.kWhite,
            fillColor: Colors.white.withOpacity(0.1),
            controller: authProvider.registerUserLastNameController,
            hintText: "Last Name",
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(FluentIcons.person_24_regular,
                color: AppColors.kGray3),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),

          verticalSpaceRegular,
          // Password
          CustomTextField(
            textColor: AppColors.kWhite,
            fillColor: Colors.white.withOpacity(0.1),
            controller: authProvider.registerUserPasswordController,
            hintText: "Password",
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(FluentIcons.password_24_regular,
                color: AppColors.kGray3),
            obscureText: authListener.registerPasswordHide,
            suffixIcon: InkWell(
                customBorder: const CircleBorder(),
                onTap: authProvider.toggleRegisterPassword,
                child: Icon(
                  authListener.registerPasswordHide
                      ? FluentIcons.eye_24_regular
                      : FluentIcons.eye_off_24_regular,
                  color: AppColors.kGray3,
                )),
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            onChanged: (_) => setState(() {}),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.password(),
            ]),
          ),

          verticalSpaceRegular,
          // Confirm Password
          CustomTextField(
            textColor: AppColors.kWhite,
            fillColor: Colors.white.withOpacity(0.1),
            controller: authProvider.registerUserConfirmPasswordController,
            hintText: "Confirm Password",
            obscureText: authListener.registerPasswordHide,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            prefixIcon: const Icon(FluentIcons.password_24_regular,
                color: AppColors.kGray3),
            suffixIcon: InkWell(
                customBorder: const CircleBorder(),
                onTap: authProvider.toggleRegisterPassword,
                child: Icon(
                  authListener.registerPasswordHide
                      ? FluentIcons.eye_24_regular
                      : FluentIcons.eye_off_24_regular,
                  color: AppColors.kGray3,
                )),
            onChanged: (_) => setState(() {}),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.password(),
              FormBuilderValidators.equal(
                authProvider.registerUserPasswordController.text,
                checkNullOrEmpty: false,
                errorText: 'Passwords do not match',
              )
            ]),
          ),
        ],
      ),
    );
  }
}
