import 'package:auto_route/auto_route.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/user/models/user_consent_list_data_model.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';

@RoutePage()
class NotificationPreferenceScreen extends GetProviderView<UserProvider> {
  const NotificationPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userLisenter = listener(context);
    final userProvider = notifier(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
      ),
      body: userLisenter.isUserConsentLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Column(
              children: [
                verticalSpaceSmall,
                _buildTile(userLisenter.transactionalUserConsent,
                    value: userLisenter.isTransactionalConsentChanged,
                    onChanged: (val) {
                  if (!val) {
                    AlertDialogs.showInfo(
                        'Needed for order updates and account-related messages');
                    return;
                  }
                  userProvider.onChangeTransactionalConsentChanged();
                }, context: context),
                verticalSpaceRegular,
                _buildTile(userLisenter.promotionalUserConsent,
                    value: userLisenter.isPromotionalConsentChanged,
                    onChanged: (_) =>
                        userProvider.onChangePromotionalConsentChanged(),
                    context: context),
                verticalSpaceRegular,
                _buildTile(userLisenter.newsLetterUserConsent,
                    value: userLisenter.isNewsletterConsentChanged,
                    onChanged: (_) =>
                        userProvider.onChangeNewsLetterConsentChanged(),
                    context: context),
                verticalSpaceRegular,
                SizedBox(
                  width: context.screenWidth * 0.3,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () async {
                      await userProvider.saveUserConsent().then(
                        (value) {
                          if (value) {
                            if (!context.mounted) return;

                            context.back();
                          }
                        },
                      );
                    },
                    child: const Text("Update"),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTile(UserConsentSubDataModel? consent,
      {required bool value,
      required void Function(bool)? onChanged,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                consent?.title ?? 'N/A',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              CupertinoSwitch(
                value: value,
                onChanged: onChanged,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          Text(consent?.content ?? 'N/A'),
        ],
      ),
    );
  }
}
