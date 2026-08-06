import 'package:auto_route/auto_route.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/application/order/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/auth/auth_provider.dart';
import 'package:customer_core/src/core/routes/routes.gr.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/widgets/custom_back_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../application/core/dependency_registrar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/alert_dialogs.dart';
import '../widgets/button_progress.dart';

@RoutePage()
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final authListener = context.watch<AuthProvider>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) =>
          authProvider.registerOTPController.clear(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const CustomBackButton(),
          leadingWidth: 70,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultScreenPadding),
          child: SingleChildScrollView(
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
                        authProvider.registerUserEmailController.text,
                        textAlign: TextAlign.center,
                        style: context.customTextTheme.text14W600,
                      ),
                      horizontalSpaceTiny,
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.edit, size: 16.0))
                    ],
                  ),
                ),
                verticalSpaceLarge,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PinCodeTextField(
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.scale,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.0),
                      activeColor: AppColors.kBlack2,
                      inactiveColor: AppColors.kBlack2,
                      inactiveFillColor: AppColors.kOffWhite3,
                      activeFillColor: AppColors.kOffWhite3,
                      selectedColor: AppColors.kBlack2,
                      selectedFillColor: AppColors.kOffWhite3,
                      fieldHeight: 52,
                      fieldWidth: 52,
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
                ),
                verticalSpaceMedium,
                Center(
                  child: InkWell(
                    onTap: () => authProvider.sendVerifyOTPForRegistration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't get OTP? ",
                          style: context.customTextTheme.text12W500
                              .copyWith(color: AppColors.kGray3),
                        ),
                        Text(
                          "Resend OTP",
                          style: context.customTextTheme.text12W600,
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpaceMedium,
                InkWell(
                  onTap: () {
                    final validated = authProvider.validateRegisterOTP();
                    if (validated) {
                      authProvider.registerUser().then((registered) {
                        if (registered) {
                          AlertDialogs.showSuccess(
                            "Registered Successfully!",
                          );
                          authProvider.clearValues();
                          context.read<OrderProvider>().clearData();
                          DependencyRegistrar.initializeAllProviders(context);
                          Future.delayed(const Duration(seconds: 1), () {
                            context.router.replaceAll([
                              HomeScreenRoute(),
                            ]);
                          });
                        }
                      });
                    } else {
                      AlertDialogs.showError(
                        "Invalid OTP",
                      );
                    }
                  },
                  child: Container(
                      width: context.screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Center(
                        child: !authListener.registerLoading
                            ? Text(
                                "SUBMIT",
                                style: context.customTextTheme.text16W400
                                    .copyWith(color: Colors.white),
                              )
                            : showButtonProgress(Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
