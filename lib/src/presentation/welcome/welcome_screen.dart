import 'package:auto_route/auto_route.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/core/routes/routes.gr.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:provider/provider.dart';

import '../../application/auth/auth_provider.dart';

@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final authListener = context.watch<AuthProvider>();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        alignment: Alignment.topCenter,
        image: AssetImage(
          Assets.lib.assets.images.bg01.path,
        ),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0),
        body: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: context.screenHeight * 0.15),
              Assets.lib.assets.images.appLogo01.image(height: 150.0),
              buildWelcomeText(context),
              verticalSpaceRegular,
              buildButtons(context, authProvider, authListener)
            ],
          ),
        ),
      ),
    );

    // Content
  }

  Widget buildButtons(BuildContext context, AuthProvider authProvider,
      AuthProvider authListener) {
    return Column(
      children: [
        Center(
          child: OutlinedButton(
            onPressed: () {
              authProvider.onChangeSelectedAuthView(AuthView.login);
              context.router.push(LoginScreenRoute());
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(1),
                width: 1,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              foregroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: Size(context.screenWidth * 0.8, 50.0),
              // backgroundColor: AppColors.kGray.withOpacity(0.3),
            ),
            child: const Text('Start with email or phone'),
          ),
        ),
        verticalSpaceRegular,
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Don't have an account? ",
                style: context.customTextTheme.text14W400
                    .copyWith(color: AppColors.kBlack),
              ),
              TextSpan(
                text: "Register",
                style: context.customTextTheme.text14W500
                    .copyWith(color: Theme.of(context).colorScheme.primary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    authProvider.onChangeSelectedAuthView(AuthView.register);
                    context.router.push(LoginScreenRoute());
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildWelcomeText(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.75,
      child: Column(
        children: [
          Text(
            "Everyday Essentials\nAt Your Doorstep",
            textAlign: TextAlign.center,
            style: context.customTextTheme.text20W600.copyWith(
              color: AppColors.kBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
          verticalSpaceSmall,
          Text(
            "Shop groceries, fresh produce, and daily needs. Get them delivered quickly and easily.",
            textAlign: TextAlign.center,
            style: context.customTextTheme.text16W400.copyWith(
              color: AppColors.kGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Container BuildCustomDivider() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.kGray2, borderRadius: BorderRadius.circular(20)),
      width: 60,
      height: 2,
    );
  }
}
