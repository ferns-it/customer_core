import 'package:auto_route/auto_route.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:customer_core/src/application/auth/auth_provider.dart';
import 'package:customer_core/src/core/routes/routes.gr.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/widgets/button_progress.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

@RoutePage()
class ForgotOtpScreen extends GetProviderView<AuthProvider> {
  const ForgotOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = notifier(context);
    final authListener = listener(context);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) =>
          authProvider.emailOtpController.clear(),
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultScreenPadding),
          child: SingleChildScrollView(
            child: FormBuilder(
              key: authProvider.changePasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  verticalSpaceMedium,
                  Assets.lib.assets.images.otpVerification.svg(),
                  verticalSpaceMedium,
                  Center(
                    child: Text(
                      "OTP Verification",
                      style: context.customTextTheme.text20W600,
                    ),
                  ),
                  verticalSpaceTiny,
                  Center(
                    child: Text(
                      "We Will send you a one time password on this Email Id",
                      textAlign: TextAlign.center,
                      style: context.customTextTheme.text14W500,
                    ),
                  ),
                  verticalSpaceTiny,
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          authProvider.resetEmail,
                          textAlign: TextAlign.center,
                          style: context.customTextTheme.text14W600,
                        ),
                        horizontalSpaceTiny,
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.edit, size: 16.0),
                        )
                      ],
                    ),
                  ),
                  verticalSpaceLarge,
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //   child: PinCodeTextField(
                  //     length: 6,
                  //     obscureText: false,
                  //     animationType: AnimationType.scale,
                  //     pinTheme: PinTheme(
                  //       shape: PinCodeFieldShape.circle,
                  //       borderRadius: BorderRadius.circular(10.0),
                  //       activeColor: AppColors.kBlack2,
                  //       inactiveColor: AppColors.kBlack2,
                  //       inactiveFillColor: AppColors.kOffWhite3,
                  //       activeFillColor: AppColors.kOffWhite3,
                  //       selectedColor: AppColors.kBlack2,
                  //       selectedFillColor: AppColors.kOffWhite3,
                  //       fieldHeight: 48,
                  //       fieldWidth: 48,
                  //       fieldOuterPadding:const  EdgeInsets.all(5)
                  //     ),
                  //     controller: authProvider.registerOTPController,
                  //     showCursor: false,
                  //     animationDuration: const Duration(milliseconds: 300),
                  //     enableActiveFill: true,
                  //     keyboardType: TextInputType.phone,
                  //     onCompleted: (v) {},
                  //     onChanged: (value) {},
                  //     appContext: context,
                  //     autoDisposeControllers: false,
                  //   ),
                  // ),
                  FormBuilderTextField(
                    name: 'OTP',
                    validator: FormBuilderValidators.required(
                      errorText: 'Required OTP',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Enter OTP',
                      hintStyle: const TextStyle(
                        color: AppColors.kGray3,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                  FormBuilderTextField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: authListener.newPasswordFieldKey,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.password(),
                    ]),
                    obscureText: authListener.resetPasswordHide,
                    decoration: InputDecoration(
                      hintText: "New Password",
                      suffixIcon: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: authProvider.toggleResetPassword,
                        child: Icon(
                          authListener.resetPasswordHide
                              ? FluentIcons.eye_24_regular
                              : FluentIcons.eye_off_24_regular,
                          color: AppColors.kGray3,
                        ),
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppColors.kGray3,
                      ),
                    ),
                    name: 'new-password',
                  ),
                  verticalSpaceRegular,
                  FormBuilderTextField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      suffixIcon: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: authProvider.toggleResetPassword,
                        child: Icon(
                          authListener.resetPasswordHide
                              ? FluentIcons.eye_24_regular
                              : FluentIcons.eye_off_24_regular,
                          color: AppColors.kGray3,
                        ),
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppColors.kGray3,
                      ),
                    ),
                    name: 'confirm-password',
                  ),
                  verticalSpaceMedium,
                  Center(
                    child: InkWell(
                      onTap: () => authProvider.resetPassword(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't get OTP? ",
                            style: context.customTextTheme.text12W500
                                .copyWith(color: AppColors.kGray3),
                          ),
                          Text(
                            " Resend OTP",
                            style: context.customTextTheme.text12W600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  FilledButton(
                    onPressed: !authListener.resetLoading
                        ? () async {
                            final validated =
                                await authProvider.validateResetPasswordOTP();
                            if (validated) {
                              context.router.replaceAll([
                                const OrderOnlineScreenRoute(),
                              ]);
                            }
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      fixedSize: Size(context.screenWidth, 50),
                    ),
                    child: !authListener.resetLoading
                        ? Text(
                            "Submit",
                            style: context.customTextTheme.text16W400,
                          )
                        : showButtonProgress(Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
