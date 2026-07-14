import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:customer_core/src/application/otp/otp_provider.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
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
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

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
  // final StreamController<int> _streamController =
  //     StreamController<int>.broadcast();

  // Timer? _timer;
  // int _secondsRemaining = 60;

  // void startTimer() {
  //   _timer?.cancel();
  //   _secondsRemaining = 60;

  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (_secondsRemaining > 0) {
  //       _secondsRemaining--;
  //       _streamController.add(_secondsRemaining);
  //     } else {
  //       timer.cancel();
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   // startTimer();

  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   // _timer?.cancel();
  //   // _streamController.close();
  //   super.dispose();
  // }

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
    final productsProvider = context.read<ProductsProvider>();
    final shopProvider = context.read<ShopProvider>();
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
                                    productsProvider
                                        .getFeaturedPopularProducts();

                                    if (widget.showBackButton) {
                                      Navigator.pop(context, true);
                                      context
                                          .read<UserProvider>()
                                          .getUserData();
                                      context
                                          .read<CartProvider>()
                                          .checkUserIsLogged();

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
                                      .copyWith(color: Colors.white),
                                )
                              : showButtonProgress(Colors.white),
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
                            // recognizer: TapGestureRecognizer()
                            //   ..onTap = () {
                            //     authProvider.onChangeSelectedAuthView(
                            //         AuthView.register);
                            //     authProvider.clearValues();
                            //     // context.router.push(const RegisterScreenRoute());
                            //   },
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                authProvider.clearValues();

                                authProvider.initializeRegistrationFlow(
                                  shopProvider.verificationType,
                                );

                                authProvider.onChangeSelectedAuthView(
                                    AuthView.register);
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
    final otpListener = context.watch<OtpProvider>();
    final shopProvider = context.watch<ShopProvider>();
    final currentStage = authListener.currentRegStage;

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        authProvider.clearValues(registerControllersOnly: true);
      },
      child: SingleChildScrollView(
        child: Stack(
          children: [
            // Back button
            Positioned(
              top: 0,
              left: 0,
              child: Visibility(
                visible: currentStage != RegStage.register,
                child: IconButton(
                  onPressed: () {
                    switch (currentStage) {
                      case RegStage.phone:
                        authListener.onChangeSelectedAuthView(AuthView.login);
                        authProvider.clearValues(registerControllersOnly: true);
                      case RegStage.verifySms:
                        authProvider.updateCurrentRegStage(RegStage.phone);
                      case RegStage.email:
                        // If SMS is enabled, go back to verifySms
                        if (shopProvider.verificationType ==
                                VerificationType.sms ||
                            shopProvider.verificationType ==
                                VerificationType.both) {
                          authProvider
                              .updateCurrentRegStage(RegStage.verifySms);
                        } else {
                          authProvider.updateCurrentRegStage(RegStage.phone);
                        }
                      case RegStage.verifyEmail:
                        authProvider.updateCurrentRegStage(RegStage.email);
                      case RegStage.details:
                        // Go back to the appropriate verify stage
                        if (shopProvider.verificationType ==
                                VerificationType.sms ||
                            shopProvider.verificationType ==
                                VerificationType.both) {
                          authProvider
                              .updateCurrentRegStage(RegStage.verifySms);
                        } else if (shopProvider.verificationType ==
                            VerificationType.email) {
                          authProvider
                              .updateCurrentRegStage(RegStage.verifyEmail);
                        } else {
                          authProvider.updateCurrentRegStage(RegStage.phone);
                        }
                      default:
                        authProvider.updateCurrentRegStage(RegStage.phone);
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
                // Title
                Text(
                  currentStage == RegStage.phone
                      ? "Enter Mobile Number"
                      : currentStage == RegStage.verifySms
                          ? "Verify SMS OTP"
                          : currentStage == RegStage.email
                              ? "Enter Email"
                              : currentStage == RegStage.verifyEmail
                                  ? "Verify Email OTP"
                                  : currentStage == RegStage.details
                                      ? "Enter Details"
                                      : "Register",
                  style: context.customTextTheme.text20W600
                      .copyWith(color: AppColors.kWhite),
                ),
                verticalSpaceSmall,
                // Subtitle
                Text(
                  currentStage == RegStage.phone
                      ? "Enter your mobile number to get started"
                      : currentStage == RegStage.verifySms
                          ? "Enter the OTP sent to your mobile"
                          : currentStage == RegStage.email
                              ? "Enter your email address"
                              : currentStage == RegStage.verifyEmail
                                  ? "Enter the OTP sent to your email"
                                  : currentStage == RegStage.details
                                      ? "Enter your details to complete registration"
                                      : "",
                  style: context.customTextTheme.text12W400
                      .copyWith(color: AppColors.kWhite),
                ),
                verticalSpaceMedium,
                // Content based on stage
                if (currentStage == RegStage.phone)
                  _phoneInputForm(authProvider, context, authListener)
                else if (currentStage == RegStage.verifySms ||
                    currentStage == RegStage.verifyEmail)
                  _otpWidget(authProvider, context, authListener)
                else if (currentStage == RegStage.email)
                  _emailInputForm(authProvider, context, authListener)
                else if (currentStage == RegStage.details)
                  _registerForm1(authProvider, context, authListener)
                else if (currentStage == RegStage.register)
                  _registerForm2(authProvider, context, authListener),
                // OTP timer & resend
                if (currentStage == RegStage.verifySms ||
                    currentStage == RegStage.verifyEmail) ...[
                  verticalSpaceSmall,
                  Consumer<OtpProvider>(
                    builder: (_, otpProvider, __) {
                      if (!otpProvider.canResend) {
                        return Text(
                          "Resend OTP in ${otpProvider.seconds} seconds",
                        );
                      } else {
                        return TextButton.icon(
                          iconAlignment: IconAlignment.end,
                          onPressed: () async {
                            bool result;
                            if (currentStage == RegStage.verifySms) {
                              result = await authProvider.sendSmsOtp();
                            } else {
                              result = await authProvider.sendEmailOtp();
                            }
                            if (result) {
                              AlertDialogs.showSuccess("OTP sent successfully");
                            }
                          },
                          icon: const SizedBox.shrink(),
                          label: Text(
                            'Resend OTP',
                            style: context.customTextTheme.text14W700
                                .copyWith(color: AppColors.kWhite),
                          ),
                        );
                      }
                    },
                  ),
                  verticalSpaceSmall,
                ],
                // Main action button
                InkWell(
                  onTap: authListener.registrationButtonLoading
                      ? null
                      : () async {
                          if (authListener.registrationButtonLoading) return;

                          switch (currentStage) {
                            case RegStage.phone:
                              debugPrint(
                                  "Phone: ${authProvider.registerUserPhoneController.text}");
                              debugPrint(
                                  "Verification Type: ${shopProvider.verificationType}");
                              if (authProvider.validatePhoneForm()) {
                                authProvider.setVerificationType(
                                    shopProvider.verificationType);
                                if (shopProvider.verificationType ==
                                        VerificationType.sms ||
                                    shopProvider.verificationType ==
                                        VerificationType.both) {
                                  // SMS enabled - send SMS OTP
                                  final sent = await authProvider.sendSmsOtp();
                                  if (sent) {
                                    authProvider.updateCurrentRegStage(
                                        RegStage.verifySms);
                                  }
                                } else {
                                  // SMS disabled - go to email
                                  authProvider
                                      .updateCurrentRegStage(RegStage.email);
                                }
                              }
                              break;

                            case RegStage.verifySms:
                              final verified =
                                  await authProvider.verifySmsOtp();
                              if (verified) {
                                AlertDialogs.showSuccess("OTP Verified!");
                                // Check if email also needed
                                if (shopProvider.verificationType ==
                                    VerificationType.both) {
                                  authProvider
                                      .updateCurrentRegStage(RegStage.email);
                                } else {
                                  authProvider
                                      .updateCurrentRegStage(RegStage.details);
                                }
                              } else {
                                AlertDialogs.showError("Invalid OTP");
                              }
                              break;

                            case RegStage.email:
                              if (authProvider.validateEmailForm()) {
                                final sent = await authProvider.sendEmailOtp();
                                if (sent) {
                                  authProvider.updateCurrentRegStage(
                                      RegStage.verifyEmail);
                                }
                              }
                              break;

                            case RegStage.verifyEmail:
                              final verified = authProvider.verifyEmailOtp();
                              if (verified) {
                                AlertDialogs.showSuccess("OTP Verified!");
                                authProvider
                                    .updateCurrentRegStage(RegStage.details);
                              } else {
                                AlertDialogs.showError("Invalid OTP");
                              }
                              break;

                            case RegStage.details:
                              if (authProvider.validateRegisterForm1()) {
                                authProvider
                                    .updateCurrentRegStage(RegStage.register);
                              }
                              break;

                            case RegStage.register:
                              if (authProvider.validateRegisterForm2()) {
                                await authProvider
                                    .registerUser()
                                    .then((registered) async {
                                  if (registered) {
                                    AlertDialogs.showSuccess(
                                        'Account Created Successfully');
                                    authProvider.loginUserNameController.text =
                                        authProvider
                                            .registerUserEmailController.text;
                                    authProvider
                                            .loginUserPasswordController.text =
                                        authProvider
                                            .registerUserPasswordController
                                            .text;
                                    await authProvider
                                        .loginUser()
                                        .then((loggedin) {
                                      if (widget.showBackButton) {
                                        Navigator.pop(context, true);
                                        context
                                            .read<UserProvider>()
                                            .getUserData();
                                        context
                                            .read<CartProvider>()
                                            .checkUserIsLogged();
                                      }
                                      authProvider.clearValues();
                                      authProvider.onChangeSelectedAuthView(
                                          AuthView.login);
                                    });
                                  } else {
                                    AlertDialogs.showError(
                                        'Registration failed. Please try again.');
                                  }
                                });
                              }
                              break;
                          }
                        },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary),
                    height: 50,
                    width: context.screenWidth,
                    child: Center(
                        child: !authListener.registrationButtonLoading
                            ? Text(
                                currentStage == RegStage.phone
                                    ? "Send OTP"
                                    : currentStage == RegStage.verifySms
                                        ? "Verify OTP"
                                        : currentStage == RegStage.email
                                            ? "Send OTP"
                                            : currentStage ==
                                                    RegStage.verifyEmail
                                                ? "Verify OTP"
                                                : currentStage ==
                                                        RegStage.details
                                                    ? "Next"
                                                    : "Register",
                                style: context.customTextTheme.text16W400
                                    .copyWith(color: AppColors.kWhite),
                              )
                            : showButtonProgress(Colors.white)),
                  ),
                ),
                verticalSpaceLarge,
                // Login link
                RichText(
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
                            authProvider.clearValues();
                            authProvider
                                .onChangeSelectedAuthView(AuthView.login);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
          // Consumer<AuthProvider>(
          //   builder: (_, authProvider, __) {
          //     return CountryCodePicker(
          //       initialSelection: AppConfig.instance.country.dialCode,
          //       favorite: const ['IN', 'AE', 'US', 'GB'],
          //       showCountryOnly: false,
          //       showOnlyCountryWhenClosed: false,
          //       showDropDownButton: true,
          //       alignLeft: false,
          //       textStyle: const TextStyle(
          //         color: AppColors.kWhite,
          //         fontSize: 14,
          //       ),
          //       dialogTextStyle: const TextStyle(
          //         color: Colors.black,
          //       ),
          //       searchDecoration: const InputDecoration(
          //         hintText: 'Search Country',
          //       ),
          //       // onChanged: (country) {
          //       //   authProvider.updateCountry(country);
          //       // },
          //     );
          //   },
          // ),
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

  Widget _otpWidget(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    final otpProvider = context.watch<OtpProvider>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) =>
          authProvider.registerOTPController.clear(),
      child: PinCodeTextField(
        textStyle: const TextStyle(
          color: AppColors.kWhite,
        ),
        length: 6,
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
          // fieldHeight: MediaQuery.of(context).size.width * 0.12,
          // fieldWidth: MediaQuery.of(context).size.width * 0.12,
          fieldHeight: MediaQuery.of(context).size.width * 0.11,
          fieldWidth: MediaQuery.of(context).size.width * 0.11,
          fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 4),
        ),
        // controller: authProvider.registerOTPController,
        controller: otpProvider.otpController,
        showCursor: false,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        keyboardType: TextInputType.phone,
        onCompleted: (v) {},
        onChanged: (value) {},
        appContext: context,
        autoDisposeControllers: false,
      ),
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
    final otpListener = context.watch<OtpProvider>();
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
                            otpListener.startTimer();

                            // startTimer();
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
    final otpListener = context.watch<OtpProvider>();
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
                errorMaxLines: 2,
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
                errorMaxLines: 2,
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
          Consumer<OtpProvider>(
            builder: (_, otpProvider, __) {
              if (!otpProvider.canResend) {
                return Text(
                  "Resend OTP in ${otpProvider.seconds} seconds",
                );
              } else {
                return TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () async {
                    final result =
                        await authProvider.resetPassword(isResendOTP: true);

                    if (result) {
                      AlertDialogs.showSuccess("OTP sent successfully");
                      otpListener.startTimer();
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
    return Form(
      key: authProvider.registerFormKey1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              textColor: AppColors.kWhite,
              fillColor: Colors.white.withOpacity(0.1),
              controller: authProvider.registerUserFirstNameController,
              hintText: "First Name",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(FluentIcons.person_24_regular,
                  color: AppColors.kGray3),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),

            verticalSpaceRegular,
            // Last Name Field
            CustomTextField(
              textColor: AppColors.kWhite,
              fillColor: Colors.white.withOpacity(0.1),
              controller: authProvider.registerUserLastNameController,
              hintText: "Last Name",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(FluentIcons.person_24_regular,
                  color: AppColors.kGray3),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                // FormBuilderValidators.lastName(),
              ]),
            ),

            verticalSpaceRegular,
            // Mobile Number Field
            CustomTextField(
              textColor: AppColors.kWhite,
              fillColor: Colors.white.withOpacity(0.1),
              controller: authProvider.registerUserPhoneController,
              hintText: "Phone Number",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textInputAction: TextInputAction.next,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(FluentIcons.call_24_regular,
                        color: AppColors.kGray3),
                    const SizedBox(width: 8),
                    Text(
                      AppConfig.instance.country.dialCode,
                      style: context.customTextTheme.text14W400
                          .copyWith(color: AppColors.kWhite),
                    ),
                    const SizedBox(width: 8),
                    Container(height: 20, width: 1, color: AppColors.kGray3),
                    const SizedBox(width: 8),
                  ],
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
          ],
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
          CustomTextField(
            textColor: AppColors.kWhite,
            fillColor: Colors.white.withOpacity(0.1),
            controller: authProvider.registerUserEmailController,
            hintText: "Email",
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(FluentIcons.mail_24_regular,
                color: AppColors.kGray3),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
          ),

          verticalSpaceRegular,
          // Last Name Field
          CustomTextField(
            textColor: AppColors.kWhite,
            fillColor: Colors.white.withOpacity(0.1),
            controller: authProvider.registerUserPasswordController,
            hintText: "Password",
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(FluentIcons.password_24_regular,
                color: AppColors.kGray3),
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            onChanged: (_) => setState(() {}),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.password(),
            ]),
          ),

          verticalSpaceRegular,
          // Mobile Number Field
          CustomTextField(
            textColor: AppColors.kWhite,
            fillColor: Colors.white.withOpacity(0.1),
            controller: authProvider.registerUserConfirmPasswordController,
            hintText: "Confirm Password",
            obscureText: authListener.registerPasswordHide,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
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
