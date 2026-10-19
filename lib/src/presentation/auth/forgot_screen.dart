import 'package:auto_route/auto_route.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:customer_core/src/application/auth/auth_provider.dart';
import 'package:customer_core/src/core/routes/routes.gr.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/widgets/custom_back_button.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../widgets/button_progress.dart';

@RoutePage()
class ForgotPasswordScreen extends GetProviderView<AuthProvider> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = notifier(context);
    final authListener = listener(context);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        leadingWidth: 70,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultScreenPadding),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: authProvider.resetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.lib.assets.images.signInImg.image(),
                Text(
                  "Forgot Password",
                  style: context.customTextTheme.text20W600,
                ),
                verticalSpaceTiny,
                Text(
                  "Enter your email address to reset your password",
                  style: context.customTextTheme.text16W400,
                  textAlign: TextAlign.center,
                ),
                verticalSpaceLarge,
                FormBuilderTextField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                  decoration: const InputDecoration(
                    hintText: "Email Address",
                    prefixIcon: Icon(
                      FluentIcons.mail_24_regular,
                      color: AppColors.kGray3,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.kGray3,
                    ),
                  ),
                  name: 'email-address',
                ),
                verticalSpaceMedium,
                FilledButton(
                  onPressed: authListener.resetLoading
                      ? null
                      : () async {
                          final isValidated =
                              await authProvider.resetPassword();
                          if (isValidated) {
                            // ignore: use_build_context_synchronously
                            context.router.push(const ForgotOtpScreenRoute());
                          }
                        },
                  style: FilledButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 50),
                  ),
                  child: authListener.resetLoading
                      ? showButtonProgress(Colors.white)
                      : Text(
                          "Request OTP",
                          style: context.customTextTheme.text16W400,
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
}
