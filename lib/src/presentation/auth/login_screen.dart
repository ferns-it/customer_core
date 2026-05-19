import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:auto_route/auto_route.dart';
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
    final widgets = [
      _registerForm1(authProvider, context, authListener),
      _registerForm2(authProvider, context, authListener),
      _otpWidget(authProvider, context, authListener),
      _successWidget(authProvider, context, authListener),
    ];
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
                visible: authListener.currentRegForm != 3,
                child: IconButton(
                  onPressed: () {
                    if (authListener.currentRegForm == 0) {
                      authListener.onChangeSelectedAuthView(AuthView.login);
                      authProvider.clearValues(registerControllersOnly: true);
                    }
                    if (authListener.currentRegForm == 1) {
                      authProvider.updateCurrentRegForm(0);
                    }
                    if (authListener.currentRegForm == 2) {
                      authProvider.updateCurrentRegForm(1);
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
                authListener.currentRegForm == 3
                    ? const SizedBox.shrink()
                    : const SizedBox.shrink(),
                verticalSpaceSmall,
                authListener.currentRegForm == 3
                    ? const SizedBox.shrink()
                    : Text(
                        authListener.currentRegForm == 0 ||
                                authListener.currentRegForm == 1
                            ? "Create Account"
                            : authListener.currentRegForm == 2
                                ? "Enter OTP"
                                : '',
                        style: context.customTextTheme.text20W600
                            .copyWith(color: AppColors.kWhite),
                      ),
                verticalSpaceSmall,
                authListener.currentRegForm == 3
                    ? const SizedBox.shrink()
                    : Text(
                        authListener.currentRegForm == 0 ||
                                authListener.currentRegForm == 1
                            ? "Require information to account registrations"
                            : authListener.currentRegForm == 2
                                ? "Enter the OTP send to your registered email"
                                : '',
                        style: context.customTextTheme.text12W400
                            .copyWith(color: AppColors.kWhite),
                      ),
                verticalSpaceMedium,
                AnimatedCrossFade(
                  firstChild: widgets[authListener.currentRegForm],
                  secondChild: widgets[
                      (authListener.currentRegForm + 1) % widgets.length],
                  duration: const Duration(seconds: 1),
                  firstCurve: Curves.ease,
                  secondCurve: Curves.ease,
                  reverseDuration: const Duration(seconds: 1),
                  sizeCurve: Curves.ease,
                  crossFadeState: CrossFadeState.showFirst,
                ),
                if (authListener.currentRegForm == 2) verticalSpaceSmall,
                verticalSpaceRegular,
                Visibility(
                  visible: authListener.currentRegForm == 2,
                  child: StreamBuilder<int>(
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
                            final result = await authProvider
                                .sendVerifyOTPForRegistration();

                            if (result) {
                              AlertDialogs.showSuccess("OTP sent successfully");
                              startTimer();
                            }
                          },
                          icon: authListener.registerOTPLoading
                              ? const CupertinoActivityIndicator(
                                  color: AppColors.kBlack3)
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
                ),
                if (authListener.currentRegForm == 2) verticalSpaceSmall,
                InkWell(
                  onTap: authListener.registerLoading ||
                          authListener.loginLoading
                      ? null
                      : () async {
                          bool validated = false;
                          if (authListener.currentRegForm == 0) {
                            validated = authProvider.validateRegisterForm1();
                            if (validated) {
                              authProvider.updateCurrentRegForm(1);
                            }
                          } else if (authListener.currentRegForm == 1) {
                            validated = authProvider.validateRegisterForm2();
                            if (validated) {
                              authProvider.registerOTPController.clear();
                              authProvider
                                  .sendVerifyOTPForRegistration()
                                  .then((done) {
                                if (done) {
                                  authProvider.updateCurrentRegForm(2);
                                  startTimer();
                                }
                              });
                            }
                          } else if (authListener.currentRegForm == 2) {
                            bool validated = authProvider.validateRegisterOTP();
                            if (validated) {
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
                                          .registerUserPasswordController.text;
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
                                    authProvider.updateCurrentRegForm(0);
                                    authProvider.clearValues();
                                    authProvider.onChangeSelectedAuthView(
                                        AuthView.login);
                                  });

                                  // Future.delayed(const Duration(seconds: 1),
                                  //     () {
                                  //   authProvider.updateCurrentRegForm(3);
                                  // });
                                } else {
                                  AlertDialogs.showError(
                                      'Registration failed. Please try again.');
                                }
                              }).catchError((error) {
                                AlertDialogs.showError(
                                    'An error occurred: $error');
                              });
                            } else {
                              AlertDialogs.showError('Invalid OTP');
                            }
                          } else if (authListener.currentRegForm == 3) {
                            authProvider.updateCurrentRegForm(0);

                            authProvider
                                .onChangeSelectedAuthView(AuthView.login);
                          }
                        },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary),
                    height: 50,
                    width: context.screenWidth,
                    child: Center(
                        child: !authListener.registerOTPLoading
                            ? Text(
                                authListener.currentRegForm == 0
                                    ? "Next"
                                    : authListener.currentRegForm == 1
                                        ? "Register"
                                        : authListener.currentRegForm == 2
                                            ? "Confirm"
                                            : "Go To Login Page",
                                style: context.customTextTheme.text16W400
                                    .copyWith(color: AppColors.kWhite),
                              )
                            : showButtonProgress(Colors.white)),
                  ),
                ),
                verticalSpaceLarge,
                Visibility(
                  visible: authListener.currentRegForm == 0 ||
                      authListener.currentRegForm == 1,
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
                  visible: authListener.currentRegForm == 0 ||
                      authListener.currentRegForm == 1,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: !authListener.isRegisterMode
                              ? "Already have an account?  "
                              : "Don't have an account?  ",
                          style: context.customTextTheme.text14W500
                              .copyWith(color: AppColors.kWhite),
                        ),
                        TextSpan(
                          text:
                              authListener.isRegisterMode ? "Sign Up" : "Login",
                          style: context.customTextTheme.text14W700
                              .copyWith(color: AppColors.kWhite),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              authProvider.updateCurrentRegForm(0);
                              authProvider
                                  .onChangeSelectedAuthView(AuthView.login);
                              // context.router.push(const RegisterScreenRoute());
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

  Widget _otpWidget(AuthProvider authProvider, BuildContext context,
      AuthProvider authListener) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) =>
          authProvider.registerOTPController.clear(),
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
        controller: authProvider.registerOTPController,
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
                      "+973",
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
                  RegExp(r'^[0-9]{8}$'),
                  errorText: 'Enter valid Bahrain number',
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
                errorText: 'Passwords do not ma',
              )
            ]),
          ),
        ],
      ),
    );
  }
}
