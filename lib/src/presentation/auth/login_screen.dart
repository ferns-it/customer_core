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
  String _phoneFieldError = '';
  // String _emailFieldError = '';

  String _validatePhoneField(String phone, String? countryCode) {
    if (phone.isEmpty) {
      return "Phone number is required";
    }

    if (countryCode == "+91") {
      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
        return "Enter a valid Indian mobile number";
      }
    } else if (countryCode == "+44") {
      if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
        return "Enter a valid UK mobile number";
      }
    }

    return '';
  }

  // String _validateEmailField(String email) {
  //   if (email.isEmpty) {
  //     return "Email is required";
  //   }

  //   final emailRegex = RegExp(
  //     r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+([.-]?[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$',
  //   );

  //   if (!emailRegex.hasMatch(email)) {
  //     return "Enter a valid email address";
  //   }

  //   return '';
  // }

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
                child: Stack(
                  children: [
                    authListener.selectedAuthView == AuthView.register
                        ? _registerFormParent(authProvider, context,
                            homeProvider, homeListener, authListener)
                        : authListener.selectedAuthView == AuthView.login
                            ? _loginForm(authProvider, context, authListener,
                                homeProvider)
                            : _forgotWidgetParent(
                                authProvider, context, authListener),
                    // Back button - visible when showBackButton is true
                    if (widget.showBackButton)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: IconButton(
                          onPressed: () {
                            if (authListener.selectedAuthView ==
                                AuthView.register) {
                              switch (authListener.currentRegStage) {
                                case RegStage.contact:
                                  // First registration page -> go back to login
                                  authProvider.onChangeSelectedAuthView(
                                    AuthView.login,
                                  );
                                  authProvider.clearValues();
                                  break;
                                case RegStage.otpCombined:
                                  authProvider
                                      .updateCurrentRegStage(RegStage.contact);
                                case RegStage.otpEmail:
                                  // Email OTP -> go back to contact/email page
                                  authProvider.updateCurrentRegStage(
                                    RegStage.contact,
                                  );
                                  break;

                                case RegStage.otpPhone:
                                  // Phone OTP -> go back to email OTP
                                  authProvider.updateCurrentRegStage(
                                    RegStage.contact,
                                  );
                                  break;
                                case RegStage.register:
                                  // Details page -> go back based on verification flow
                                  if (authProvider.smsRequired &&
                                      authProvider.emailRequired) {
                                    authProvider.updateCurrentRegStage(
                                      RegStage.otpCombined,
                                    );
                                  } else if (authProvider.emailRequired) {
                                    authProvider.updateCurrentRegStage(
                                      RegStage.otpEmail,
                                    );
                                  } else if (authProvider.smsRequired) {
                                    authProvider.updateCurrentRegStage(
                                      RegStage.otpPhone,
                                    );
                                  } else {
                                    authProvider.updateCurrentRegStage(
                                      RegStage.contact,
                                    );
                                  }
                                  break;

                                case RegStage.success:
                                  break;
                              }
                            } else if (authListener.selectedAuthView ==
                                AuthView.forgotPassword) {
                              authProvider.onChangeSelectedAuthView(
                                AuthView.login,
                              );
                              authProvider.clearValues();
                            } else {
                              Navigator.pop(context, false);
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.kGray3,
                          ),
                        ),
                      ),
                  ],
                ),
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
      child: SizedBox(
        child: Form(
          key: authProvider.loginFormKey,
          child: Column(
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
                          ? FluentIcons.eye_off_24_regular
                          : FluentIcons.eye_24_regular,
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
                        final validated = authProvider.validateLoginForm();
                        if (validated) {
                          await authProvider.loginUser().then((logged) async {
                            if (logged) {
                              AlertDialogs.showSuccess("Login successfully!");
                              if (widget.showBackButton) {
                                Navigator.pop(context, true);
                                context.read<UserProvider>().getUserData();
                                context
                                    .read<CartProvider>()
                                    .checkUserIsLogged();

                                return;
                              }

                              homeProvider.onChangeCurrentPage(0);
                              DependencyRegistrar.initializeAllProviders(
                                  context);
                              await Future.delayed(const Duration(seconds: 1),
                                  () {
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
                                .copyWith(color: AppColors.kWhite),
                          )
                        : showButtonProgress(AppColors.kWhite),
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
                          authProvider
                              .onChangeSelectedAuthView(AuthView.register);
                          authProvider.clearValues();
                          // context.router.push(const RegisterScreenRoute());
                        },
                    ),
                  ],
                ),
              )
            ],
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
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: authListener.currentRegStage != RegStage.success,
              child: IconButton(
                onPressed: () {
                  print("CURRENT STAGE: ${authListener.currentRegStage}");
                  if (authListener.currentRegStage == RegStage.contact) {
                    authListener.onChangeSelectedAuthView(AuthView.login);
                    authProvider.clearValues(registerControllersOnly: true);
                  } else if (authListener.currentRegStage ==
                      RegStage.otpEmail) {
                    authProvider.updateCurrentRegStage(
                      RegStage.contact,
                    );
                  } else if (authListener.currentRegStage ==
                      RegStage.otpPhone) {
                    if (authProvider.emailRequired) {
                      authProvider.updateCurrentRegStage(
                        RegStage.otpEmail,
                      );
                    } else {
                      authProvider.updateCurrentRegStage(
                        RegStage.contact,
                      );
                    }
                  } else if (authListener.currentRegStage ==
                      RegStage.register) {
                    if (authProvider.smsRequired &&
                        authProvider.emailRequired) {
                      authProvider.updateCurrentRegStage(
                        RegStage.otpCombined,
                      );
                    } else if (authProvider.emailRequired) {
                      authProvider.updateCurrentRegStage(
                        RegStage.otpEmail,
                      );
                    } else if (authProvider.smsRequired) {
                      authProvider.updateCurrentRegStage(
                        RegStage.otpPhone,
                      );
                    } else {
                      authProvider.updateCurrentRegStage(
                        RegStage.contact,
                      );
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
      case RegStage.otpCombined:
        return "Verify your details";
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
      case RegStage.otpCombined:
        return '';
    }
  }

  Widget _buildRegisterContent(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    switch (authListener.currentRegStage) {
      case RegStage.contact:
        return _registerForm1(authProvider, context, authListener);
      case RegStage.otpEmail:
        return _inlineEmailOtpWidget(authProvider, context, authListener);
      case RegStage.otpPhone:
        return _inlinePhoneOtpWidget(authProvider, context, authListener);
      case RegStage.register:
        return _registerForm2(authProvider, context, authListener);
      case RegStage.success:
        return _successWidget(authProvider, context, authListener);
      case RegStage.otpCombined:
        return _inlineCombinedOtpWidget(authProvider, context, authListener);
    }
  }

  Widget _buildRegisterActionButton(AuthProvider authProvider,
      BuildContext context, AuthProvider authListener) {
    if (authListener.currentRegStage == RegStage.otpCombined) {
      return const SizedBox.shrink();
    }
    if (authListener.currentRegStage == RegStage.otpPhone) {
      return const SizedBox.shrink();
    }

    //   if (authListener.emailVerified && authListener.phoneVerified) {
    //     return SizedBox(
    //       width: double.infinity,
    //       child: ElevatedButton(
    //         style: ButtonStyle(
    //             backgroundColor: WidgetStatePropertyAll(
    //                 Theme.of(context).colorScheme.primary),
    //             foregroundColor: WidgetStatePropertyAll(Colors.white),
    //             shape: WidgetStatePropertyAll(RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10)))),
    //         onPressed: () {
    //           authProvider.updateCurrentRegStage(
    //             RegStage.register,
    //           );
    //         },
    //         child: const Text("Continue"),
    //       ),
    //     );
    //   } else {
    //     return const SizedBox.shrink();
    //   }
    // }

    // When both OTP are enabled, hide button during OTP stages (auto-verify)
    if (authProvider.emailRequired && authProvider.smsRequired) {
      if (authListener.currentRegStage == RegStage.otpEmail ||
          authListener.currentRegStage == RegStage.otpPhone) {
        // For both enabled - OTP auto-verifies, no button needed
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
        return "Continue";
      // case RegStage.otpPhone:
      //   return "Continue";
      case RegStage.register:
        return "Register";
      case RegStage.success:
        return "Go To Login Page";
      case RegStage.otpCombined:
        return "";
      default:
        return "";
    }
  }

  Future<void> _onRegisterButtonTap(AuthProvider authProvider,
      BuildContext context, AuthProvider authListener) async {
    switch (authListener.currentRegStage) {
      case RegStage.contact:
        final phoneValid = authProvider.validatePhoneForm();
        final emailValid = authProvider.validateEmailForm();
        if (!phoneValid || !emailValid) return;
        final settings = context.read<ShopProvider>().storeSettings.data;
        authProvider.initializeOtpRequirement(settings!);
        authProvider.setContactLoading(true);
        try {
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
          } // Read store settings
          // final settings = context.read<ShopProvider>().storeSettings.data;
          // authProvider.initializeOtpRequirement(settings!);

          if (!authProvider.smsRequired && !authProvider.emailRequired) {
            // Case 4: Both disabled - Skip OTP, go directly to register
            authProvider.updateCurrentRegStage(RegStage.register);
          } else if (authProvider.emailRequired && authProvider.smsRequired) {
            // Case 1: Both enabled - Send ONLY email OTP first
            await authProvider.sendEmailOtpForInline();
            // Phone OTP will be sent after email verification
            authProvider.updateCurrentRegStage(RegStage.otpEmail);
            startTimer();
          } else if (authProvider.emailRequired && !authProvider.smsRequired) {
            // Case 3: Only email enabled
            await authProvider.sendEmailOtpForInline();
            authProvider.updateCurrentRegStage(RegStage.otpEmail);
            startTimer();
          } else if (!authProvider.emailRequired && authProvider.smsRequired) {
            // Case 2: Only SMS enabled - Navigate to phone OTP stage; OTP is sent when user clicks "Send OTP"
            authProvider.updateCurrentRegStage(RegStage.otpPhone);
          }
        } finally {
          authProvider.setContactLoading(false);
        }
        break;

      case RegStage.otpEmail:
        if (authProvider.emailOtpController.text.isEmpty) {
          AlertDialogs.showError("Please enter the email OTP");
          return;
        }
        bool verified = await authProvider.verifyEmailOtpForInline();
        if (verified) {
          AlertDialogs.showSuccess("Email verified successfully!");
          if (verified) {
            authProvider.updateCurrentRegStage(
              RegStage.register,
            );
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
      default:
        break;
    }
  }

  void _showLinkDialog(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Link Mobile Number"),
        content: Text(
          authProvider.verifyResponse?.message ?? "",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);

              // Mark the link as accepted so the same email+mobile
              // combination won't trigger the dialog again in this session.
              authProvider.markLinkAccepted();

              if (!authProvider.smsRequired && !authProvider.emailRequired) {
                // No verification required
                authProvider.updateCurrentRegStage(
                  RegStage.register,
                );
              } else if (authProvider.emailRequired &&
                  authProvider.smsRequired) {
                // Both enabled
                authProvider.updateCurrentRegStage(
                  RegStage.otpCombined,
                );
                startTimer();
                await authProvider.sendEmailOtpForInline();
              } else if (authProvider.emailRequired) {
                // Only email enabled
                authProvider.updateCurrentRegStage(
                  RegStage.otpEmail,
                );
                startTimer();
                await authProvider.sendEmailOtpForInline();
              } else if (authProvider.smsRequired) {
                // Only SMS enabled - Navigate to phone OTP stage; OTP is sent when user clicks "Send OTP"
                authProvider.updateCurrentRegStage(
                  RegStage.otpPhone,
                );
              }
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inlineCombinedOtpWidget(AuthProvider authProvider,
      BuildContext context, AuthProvider authListener) {
    return Column(
      children: [
        _inlineEmailOtpWidget(
          authProvider,
          context,
          authListener,
        ),
        // Only show phone verification section after email is verified
        // if (authProvider.emailOtpVerified) ...[
        //   const SizedBox(height: 16),
        //   const Divider(color: AppColors.kGray),
        //   const SizedBox(height: 8),
        //   _inlinePhoneOtpWidget(
        //     authProvider,
        //     context,
        //     authListener,
        //   ),
        // ],
        if (authProvider.emailOtpVerified) ...[
          Divider(
            color: Colors.grey,
          ),
          verticalSpaceSmall,
          _inlinePhoneOtpWidget(
            authProvider,
            context,
            authListener,
          ),
        ],
        // if (authProvider.emailOtpVerified && authProvider.phoneOtpVerified)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 16),
        //     child: SizedBox(
        //       width: double.infinity,
        //       child: ElevatedButton(
        //         style: ButtonStyle(
        //             backgroundColor: WidgetStatePropertyAll(
        //                 Theme.of(context).colorScheme.primary),
        //             foregroundColor: WidgetStatePropertyAll(Colors.white),
        //             shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(10)))),
        //         onPressed: () {
        //           authProvider.updateCurrentRegStage(
        //             RegStage.register,
        //           );
        //         },
        //         child: const Text("Continue"),
        //       ),
        //     ),
        //   ),
      ],
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

    return StreamBuilder<int>(
      stream: _streamController.stream,
      initialData: _secondsRemaining,
      builder: (context, snapshot) {
        return Column(
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
            verticalSpaceMedium,
            Form(
              key: authProvider.emailFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: authProvider.isEditingEmail
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : Border.all(
                                color: Colors.transparent,
                              ),
                        color: AppColors.kWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: authProvider.isEditingEmail
                          ? TextFormField(
                              controller:
                                  authProvider.registerUserEmailController,
                              style:
                                  context.customTextTheme.text14W400.copyWith(
                                color: AppColors.kWhite,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                hintText: "Enter email",
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                                // errorStyle: TextStyle(
                                //   fontSize: 0,
                                //   height: 0,
                                // ),
                              ),
                              // onChanged: (_) {
                              //   setState(() {
                              //     _emailFieldError = _validateEmailField(
                              //       authProvider
                              //           .registerUserEmailController.text,
                              //     );
                              //   });
                              // },
                            )
                          : Text(
                              authProvider.registerUserEmailController.text,
                              style:
                                  context.customTextTheme.text14W400.copyWith(
                                color: AppColors.kWhite,
                              ),
                            ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  Container(
                      height: 38,
                      width: 38,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                          onPressed: () {
                            authProvider.enableEmailEdit();
                          },
                          icon: Icon(
                            FluentIcons.edit_24_regular,
                            color: Colors.white,
                            size: 16,
                          ))),
                ],
              ),
            ),
            verticalSpaceMedium,
            // Email OTP Field
            if (!authProvider.emailOtpVerified)
              PinCodeTextField(
                textStyle: const TextStyle(
                  color: AppColors.kWhite,
                ),
                length: 6,
                obscureText: false,
                animationType: AnimationType.scale,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10.0),
                  activeColor: AppColors.kGray,
                  inactiveColor: AppColors.kGray,
                  inactiveFillColor: AppColors.kWhite.withOpacity(0.1),
                  activeFillColor: AppColors.kWhite.withOpacity(0.1),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  selectedFillColor: AppColors.kWhite.withOpacity(0.1),
                  fieldHeight: MediaQuery.of(context).size.width * 0.11,
                  fieldWidth: MediaQuery.of(context).size.width * 0.11,
                  fieldOuterPadding: const EdgeInsets.all(4.0),
                ),
                controller: authProvider.emailOtpController,
                showCursor: false,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                onCompleted: (v) async {
                  print("COMPLETED: $v");
                  // Auto-verify when both OTPs are enabled
                  // if (bothEnabled) {
                  //   final verified = authProvider.verifyEmailOtpForInline();

                  //   if (verified) {
                  //    if(authProvider.smsRequired){
                  //      authProvider.updateCurrentRegStage(RegStage.mobileChoice);
                  //    }else return;
                  // final sent = await authProvider.sendPhoneOtpForInline();

                  // if (sent) {
                  //   startTimer();
                  // }
                  //   }
                  // }

                  final verified = await authProvider.verifyEmailOtpForInline();
                  if (verified) {
                    // Clear OTP controller after successful verification
                    authProvider.emailOtpController.clear();
                    if (bothEnabled) {
                      // Stop the email OTP timer when transitioning to phone OTP
                      _timer?.cancel();
                      _secondsRemaining = 0;
                      _streamController.add(0);
                      authProvider.updateCurrentRegStage(
                        RegStage.otpCombined,
                      );
                    } else {
                      await Future.delayed(const Duration(milliseconds: 500));
                      // No SMS verification required
                      authProvider.updateCurrentRegStage(
                        RegStage.register,
                      );
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
                      " Email Verified",
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
                    ? const CupertinoActivityIndicator(color: AppColors.kWhite)
                    : const SizedBox.shrink(),
                label: Text(
                  'Resend OTP',
                  style: context.customTextTheme.text14W700
                      .copyWith(color: AppColors.kWhite),
                ),
              ),
            verticalSpaceRegular
          ],
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
    final shopProvider = context.watch<ShopProvider>();

    // Get phone number mask
    String phoneText = authProvider.registerUserPhoneController.text;
    String maskedPhone = phoneText.length > 8
        ? "${phoneText.substring(0, 2)}****${phoneText.substring(phoneText.length - 4)}"
        : phoneText;

    Widget buildPhoneContent(int? seconds) {
      return StreamBuilder<int>(
          stream: _streamController.stream,
          initialData: _secondsRemaining,
          builder: (context, snapshot) {
            return Column(
              children: [
                // Phone verification header with icon
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
                verticalSpaceMedium,
                Form(
                  key: authProvider.phoneFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Row(
                    children: [
                      Expanded(
                        child: authProvider.isEditingMobile
                            ? Container(
                                height: 42,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  border: authProvider.isEditingMobile
                                      ? Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 2,
                                        )
                                      : null,
                                  color: AppColors.kWhite.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<
                                          SmsAvailableCountriesData>(
                                        value: shopProvider.selectedCountry,
                                        isDense: true,
                                        dropdownColor:
                                            Colors.white.withOpacity(0.9),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        selectedItemBuilder: (context) {
                                          return shopProvider.smsCountries
                                              .map((country) {
                                            return Row(
                                              children: [
                                                Text(
                                                  countryCodeToEmoji(
                                                      country.iso ?? ""),
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  country.code ?? "",
                                                  style: context.customTextTheme
                                                      .text14W400
                                                      .copyWith(
                                                    color: AppColors.kWhite,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList();
                                        },
                                        items: shopProvider.smsCountries
                                            .map((country) {
                                          return DropdownMenuItem(
                                            value: country,
                                            child: Row(
                                              children: [
                                                Text(
                                                  countryCodeToEmoji(
                                                      country.iso ?? ""),
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  country.code ?? "",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            shopProvider
                                                .updateSelectedCountry(value);
                                          }
                                        },
                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    Expanded(
                                      child: TextFormField(
                                        controller: authProvider
                                            .registerUserPhoneController,
                                        keyboardType: TextInputType.phone,
                                        cursorColor: Colors.white,
                                        style: context
                                            .customTextTheme.text14W400
                                            .copyWith(
                                          color: AppColors.kWhite,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          errorStyle: TextStyle(
                                            fontSize: 0,
                                            height: 0,
                                          ),
                                        ),
                                        onChanged: (_) {
                                          setState(() {
                                            _phoneFieldError =
                                                _validatePhoneField(
                                              authProvider
                                                  .registerUserPhoneController
                                                  .text,
                                              shopProvider
                                                  .selectedCountry?.code,
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 42,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: AppColors.kWhite.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${shopProvider.selectedCountry?.code ?? ''} ${authProvider.registerUserPhoneController.text}",
                                  style: context.customTextTheme.text14W400
                                      .copyWith(
                                    color: AppColors.kWhite,
                                  ),
                                ),
                              ),
                      ),
                      horizontalSpaceSmall,
                      Container(
                          height: 42,
                          width: 38,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: AppColors.kWhite.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                              onPressed: () {
                                if (authProvider.isEditingMobile) {
                                  authProvider.disableMobileEdit();
                                } else {
                                  authProvider.enableMobileEdit();
                                }
                              },
                              icon: Icon(
                                FluentIcons.edit_24_regular,
                                color: Colors.white,
                                size: 16,
                              ))),
                    ],
                  ),
                ),

                // Phone field error message displayed outside the container
                if (_phoneFieldError.isNotEmpty && authProvider.isEditingMobile)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4),
                    child: Text(
                      _phoneFieldError,
                      style: context.customTextTheme.text14W500
                          .copyWith(color: Colors.red.shade300),
                    ),
                  ),

                verticalSpaceSmall,
                // if (authProvider.isEditingMobile)
                //   SizedBox(
                //     // width: double.infinity,
                //     child: ElevatedButton(
                //       style: ButtonStyle(
                //         backgroundColor: WidgetStatePropertyAll(
                //           Theme.of(context).colorScheme.primary,
                //         ),
                //         foregroundColor:
                //             const WidgetStatePropertyAll(Colors.white),
                //         shape: WidgetStatePropertyAll(
                //           RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //         ),
                //       ),
                //       onPressed: () async {
                //         print(
                //             "${shopProvider.selectedCountry?.code}${authProvider.registerUserPhoneController.text}");
                //         if (!authProvider.validatePhoneForm()) {
                //           return;
                //         }
                //         final available =
                //             await authProvider.checkUserAlreadyRegistered();
                //         if (!available) {
                //           if (authProvider.verifyResponse?.isPartialUser ==
                //               true) {
                //             _showLinkDialog(context, authProvider);
                //           } else {
                //             AlertDialogs.showError(
                //               authProvider.verifyResponse?.message ??
                //                   "User already exists",
                //             );
                //           }
                //           return;
                //         }
                //         // Send OTP
                //         final sent = await authProvider.sendPhoneOtpForInline();
                //         if (sent) {
                //           AlertDialogs.showSuccess("OTP sent successfully");
                //           authProvider.disableMobileEdit();
                //           startTimer();
                //         } else {
                //           AlertDialogs.showError(
                //             "Failed to send OTP. Please try again.",
                //           );
                //         }
                //       },
                //       child: const Text("Send OTP"),
                //     ),
                // ),
                verticalSpaceRegular,
                // Phone OTP Field - disabled until email is verified when both enabled
                if (!authProvider.isEditingMobile &&
                    !authProvider.phoneOtpVerified)
                  PinCodeTextField(
                    textStyle: const TextStyle(
                      color: AppColors.kWhite,
                    ),
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.scale,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.0),
                      activeColor: AppColors.kGray,
                      inactiveColor: AppColors.kGray,
                      inactiveFillColor:
                          bothEnabled && !authProvider.emailOtpVerified
                              ? AppColors.kGray.withOpacity(0.3)
                              : AppColors.kWhite.withOpacity(0.1),
                      activeFillColor:
                          bothEnabled && !authProvider.emailOtpVerified
                              ? AppColors.kGray.withOpacity(0.3)
                              : AppColors.kWhite.withOpacity(0.1),
                      selectedColor: Theme.of(context).colorScheme.primary,
                      selectedFillColor:
                          bothEnabled && !authProvider.emailOtpVerified
                              ? AppColors.kGray.withOpacity(0.3)
                              : AppColors.kWhite.withOpacity(0.1),
                      fieldHeight: MediaQuery.of(context).size.width * 0.11,
                      fieldWidth: MediaQuery.of(context).size.width * 0.11,
                      fieldOuterPadding: const EdgeInsets.all(4.0),
                    ),
                    controller: authProvider.phoneOtpController,
                    showCursor: false,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                    readOnly: bothEnabled && !authProvider.emailOtpVerified,
                    onCompleted: (v) async {
                      // Auto-verify when ONLY phone is enabled OR when both are enabled
                      if (onlyPhone || bothEnabled) {
                        _onAutoVerifyPhoneOtp(authProvider, context);
                      }
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

                // Only show resend timer for single phone OTP flow
                // if (!bothEnabled) ...[
                //   if (seconds != null &&
                //       seconds > 0 &&
                //       !authProvider.phoneOtpVerified)
                //     Text(
                //       "Resend OTP in $seconds seconds",
                //       style: context.customTextTheme.text14W700
                //           .copyWith(color: AppColors.kWhite),
                //     )
                //   else if (!authProvider.phoneOtpVerified)
                //     TextButton.icon(
                //       iconAlignment: IconAlignment.end,
                //       onPressed: () async {
                //         final result = await authProvider.sendPhoneOtpForInline();
                //         if (result) {
                //           AlertDialogs.showSuccess("OTP sent successfully");
                //           startTimer();
                //         }
                //       },
                //       icon: authProvider.sendOtpLoading
                //           ? const CupertinoActivityIndicator(color: AppColors.kWhite)
                //           : const SizedBox.shrink(),
                //       label: Text(
                //         'Resend OTP',
                //         style: context.customTextTheme.text14W700
                //             .copyWith(color: AppColors.kWhite),
                //       ),
                //     ),
                // ],
                if (authProvider.phoneOtpSent &&
                    snapshot.data! > 0 &&
                    !authProvider.phoneOtpVerified)
                  Text(
                    "Resend OTP in ${snapshot.data} seconds",
                    style: context.customTextTheme.text14W700
                        .copyWith(color: AppColors.kWhite),
                  )
                else if (authProvider.phoneOtpSent &&
                    !authProvider.phoneOtpVerified)
                  TextButton.icon(
                    iconAlignment: IconAlignment.end,
                    onPressed: () async {
                      final countryCode = shopProvider.selectedCountry?.code;
                      final result = await authProvider.sendPhoneOtpForInline(
                          countryCode: countryCode);
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

                verticalSpaceSmall,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primary),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: () async {
                      if (authProvider.phoneOtpVerified) {
                        authProvider.updateCurrentRegStage(
                          RegStage.register,
                        );
                        return;
                      }
                      final available =
                          await authProvider.checkUserAlreadyRegistered();
                      if (!available) {
                        if (authProvider.verifyResponse?.isPartialUser ==
                            true) {
                          _showLinkDialog(context, authProvider);
                        } else {
                          AlertDialogs.showError(
                            authProvider.verifyResponse?.message ??
                                "User already exists",
                          );
                        }
                        return;
                      }
                      // Send OTP
                      final countryCode = shopProvider.selectedCountry?.code;
                      final sent = await authProvider.sendPhoneOtpForInline(
                          countryCode: countryCode);
                      if (sent) {
                        AlertDialogs.showSuccess("OTP sent successfully");
                        authProvider.disableMobileEdit();
                        startTimer();
                      } else {
                        AlertDialogs.showError(
                          "Failed to send OTP. Please try again.",
                        );
                      }
                    },
                    child: Text(
                      authProvider.phoneOtpVerified ? "Continue" : "Send OTP",
                    ),
                  ),
                ),
                verticalSpaceMedium,
                Row(
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
                verticalSpaceMedium,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        foregroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primary),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: () {
                      authProvider.skipMobileVerification();
                    },
                    child: const Text("Verify later"),
                  ),
                ),
                // if (!bothEnabled && authProvider.phoneOtpVerified)
                //   ElevatedButton(
                //     style: ButtonStyle(
                //         backgroundColor: WidgetStatePropertyAll(
                //             Theme.of(context).colorScheme.primary),
                //         foregroundColor: WidgetStatePropertyAll(Colors.white),
                //         shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)))),
                //     onPressed: () {
                //       authProvider.updateCurrentRegStage(
                //         RegStage.register,
                //       );
                //     },
                //     child: Text("Continue"),
                //   )
              ],
            );
          });
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

    print("Verifying phone OTP: ${authProvider.phoneOtpController.text}");
    final verified = await authProvider.verifyPhoneOtpForInline();
    print("Phone OTP verification result: $verified");

    if (verified) {
      print("Phone verified successfully, moving to register...");
      // Auto-move to register screen after a brief delay
      await Future.delayed(const Duration(milliseconds: 500));
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
              child: DropdownButton<SmsAvailableCountriesData>(
                borderRadius: BorderRadius.circular(10),
                value: shopProvider.selectedCountry,
                isDense: true,
                dropdownColor: Colors.white.withOpacity(0.9),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                selectedItemBuilder: (context) {
                  return shopProvider.smsCountries.map((country) {
                    return Row(
                      children: [
                        Text(
                          countryCodeToEmoji(country.iso ?? ""),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          country.code ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
                items: shopProvider.smsCountries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Row(
                      children: [
                        Text(
                          countryCodeToEmoji(country.iso ?? ""),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          country.code ?? "",
                          style: const TextStyle(color: Colors.black),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Phone number is required";
            }

            final phone = value.trim();
            final countryCode = shopProvider.selectedCountry?.code;

            if (countryCode == "+91") {
              if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                return "Enter a valid Indian mobile number";
              }
            } else if (countryCode == "+44") {
              if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
                return "Enter a valid UK mobile number";
              }
            }

            return null;
          },
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
                      ? FluentIcons.eye_off_24_regular
                      : FluentIcons.eye_24_regular,
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
            obscureText: authListener.confirmPasswordHide,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            prefixIcon: const Icon(FluentIcons.password_24_regular,
                color: AppColors.kGray3),
            suffixIcon: InkWell(
                customBorder: const CircleBorder(),
                onTap: authProvider.confirmRegisterPassword,
                child: Icon(
                  authListener.confirmPasswordHide
                      ? FluentIcons.eye_off_24_regular
                      : FluentIcons.eye_24_regular,
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
