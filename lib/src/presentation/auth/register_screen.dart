import 'package:auto_route/auto_route.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/core/routes/routes.gr.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/core/utils/utils.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../application/auth/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/button_progress.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final authListener = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: PopScope(
        onPopInvokedWithResult: (_, __) {
          authProvider.clearValues(registerControllersOnly: true);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultScreenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Assets.lib.assets.images.a1.image(),
                verticalSpaceLarge,
                // Register Text
                Center(
                  child: Text(
                    'Register',
                    style: context.customTextTheme.text20W600,
                  ),
                ),
                // Subtitle Text
                Center(
                  child: Text(
                    'Require information to account creations',
                    style: context.customTextTheme.text16W400,
                  ),
                ),
                verticalSpaceMedium,
                authListener.currentRegForm == 0
                    ? _registerForm1()
                    : _registerForm2(),

                verticalSpaceMedium,
                InkWell(
                    onTap: () async {
                      bool validated = false;
                      if (authProvider.currentRegForm == 0) {
                        validated = authProvider.validateRegisterForm1();
                        if (validated) {
                          authProvider.updateCurrentRegForm(1);
                        }
                      } else {
                        final settings =
                            context.read<ShopProvider>().storeSettings.data;

                        final smsEnabled =
                            settings?.smsVerification == "Enabled";
                        final emailEnabled =
                            settings?.emailVerification == "Enabled";

                        await authProvider
                            .sendVerifyOTPForRegistration()
                            .then((done) {
                          if (done) {
                            // Navigate to OTP Screen
                            context.pushRoute(const OtpScreenRoute());
                          }
                        });
                      }
                    },
                    child: Container(
                      height: 50,
                      width: context.screenWidth,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        // gradient: LinearGradient(colors: [
                        //   AppColors.kSecondaryColor,
                        //   Theme.of(context).colorScheme.primary,
                        // ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      ),
                      child: Center(
                        child: !authListener.registrationButtonLoading
                            ? Text(
                                authListener.currentRegForm == 1
                                    ? "REGISTER"
                                    : "NEXT",
                                style: context.customTextTheme.text16W400
                                    .copyWith(color: AppColors.kWhite),
                              )
                            : showButtonProgress(),
                      ),
                    )),
                if (authListener.currentRegForm == 1) ...[
                  TextButton(
                    onPressed: () => authProvider.updateCurrentRegForm(0),
                    child: const Text("Go Back"),
                  ),
                  verticalSpaceSmall,
                ] else
                  verticalSpaceLarge,
                // Next Button
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: context.customTextTheme.text14W500
                            .copyWith(color: AppColors.kGray3),
                      ),
                      InkWell(
                        onTap: () {
                          context.router.replaceAll([
                            LoginScreenRoute(),
                          ]);
                        },
                        child: Text(
                          "Login",
                          style: context.customTextTheme.text14W600,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerForm1() {
    return Builder(builder: (context) {
      final authProvider = context.read<AuthProvider>();
      final authListener = context.watch<AuthProvider>();
      return Form(
        key: authProvider.registerFormKey1,
        child: Column(
          children: [
            // First Name Field
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: authProvider.registerUserFirstNameController,
              validator: (value) => Utils.commonValidator(value),
              decoration: InputDecoration(
                hintText: 'First Name',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.kGray3,
                ),
                prefixIcon: const Icon(
                  FluentIcons.person_24_regular,
                  color: AppColors.kGray3,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            verticalSpaceRegular,
            // Last Name Field
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: authProvider.registerUserLastNameController,
              textInputAction: TextInputAction.next,
              validator: (value) => Utils.commonValidator(value),
              decoration: InputDecoration(
                hintText: 'Last Name',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.kGray3,
                ),
                prefixIcon: const Icon(
                  FluentIcons.person_24_regular,
                  color: AppColors.kGray3,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            verticalSpaceRegular,
            // Mobile Number Field
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: authProvider.registerUserPhoneController,
              textInputAction: TextInputAction.done,
              validator: (value) => Utils.validateMobileNumber(value),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Mobile number',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.kGray3,
                ),
                prefixIcon: const Icon(
                  FluentIcons.call_24_regular,
                  color: AppColors.kGray3,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _registerForm2() {
    return Builder(builder: (context) {
      final authProvider = context.read<AuthProvider>();
      final authListener = context.watch<AuthProvider>();
      return Form(
        key: context.read<AuthProvider>().registerFormKey2,
        child: Column(
          children: [
            // Email Field
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              controller: authProvider.registerUserEmailController,
              textInputAction: TextInputAction.next,
              validator: Utils.validateEmail,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.kGray3,
                ),
                prefixIcon: const Icon(
                  FluentIcons.mail_24_regular,
                  color: AppColors.kGray3,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            verticalSpaceRegular,
            // Password Field
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.visiblePassword,
              controller: authProvider.registerUserPasswordController,
              textInputAction: TextInputAction.next,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.password(),
              ]),
              onChanged: (_) => setState(() {}),
              obscureText: authListener.registerPasswordHide,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.kGray3,
                ),
                prefixIcon: const Icon(
                  FluentIcons.lock_closed_24_regular,
                  color: AppColors.kGray3,
                ),
                suffixIcon: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: authProvider.toggleRegisterPassword,
                    child: Icon(
                      authListener.registerPasswordHide
                          ? FluentIcons.eye_24_regular
                          : FluentIcons.eye_off_24_regular,
                      color: AppColors.kGray3,
                    )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            verticalSpaceRegular,
            // Confirm Field
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.visiblePassword,
              controller: authProvider.registerUserConfirmPasswordController,
              obscureText: authListener.registerPasswordHide,
              onChanged: (_) => setState(() {}),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.password(),
                FormBuilderValidators.equal(
                  authProvider.registerUserPasswordController.text,
                  checkNullOrEmpty: false,
                  errorText: 'Passwords do not match',
                ),
              ]),
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.kGray3,
                ),
                prefixIcon: const Icon(
                  FluentIcons.lock_closed_24_regular,
                  color: AppColors.kGray3,
                ),
                suffixIcon: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: authProvider.toggleRegisterPassword,
                    child: Icon(
                      authListener.registerPasswordHide
                          ? FluentIcons.eye_24_regular
                          : FluentIcons.eye_off_24_regular,
                      color: AppColors.kGray3,
                    )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
