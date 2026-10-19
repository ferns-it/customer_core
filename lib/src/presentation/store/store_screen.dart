import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/widgets/custom_back_button.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';

import '../../domain/store/models/store_timing_data_model.dart';

@RoutePage()
class StoreScreen extends GetProviderView<ShopProvider> {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopListner = listener(context);
    return Scaffold(
      backgroundColor: AppColors.kLightWhite2,
      appBar: AppBar(
        backgroundColor: AppColors.kLightWhite2,
        leading: const CustomBackButton(),
        leadingWidth: 70,
        centerTitle: true,
        title: const Text("About"),
      ),
      body: shopListner.shopTiming.when(
        initial: () => const Center(child: Text("Initializing...")),
        loading: () =>  Center(
            child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        )),
        completed: (data) => Container(
          padding: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.kBlack,
                      ),
                      color: AppColors.kLightWhite2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Basic Information',
                              style: context.customTextTheme.text14W500,
                            ),
                            Text(
                              AppIdentifiers.kShopName,
                              style: context.customTextTheme.text16W700,
                            ),
                            Text(
                              AppIdentifiers.kShopInfoEmail,
                              style: context.customTextTheme.text16W700,
                            ),
                            Row(
                              children: AppIdentifiers.kShopInfoPh
                                  .map(
                                    (e) => Text(
                                      e,
                                      style: context.customTextTheme.text16W700,
                                    ),
                                  )
                                  .toList(),
                            )
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 20,
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          AppIdentifiers.kShopInfoAddress,
                          style: context.customTextTheme.text14W400,
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.kWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kGray2.withOpacity(0.5),
                          blurRadius: 6.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTimeWidget("Monday", data.monday, context),
                        _buildTimeWidget("Tuesday", data.tuesday, context),
                        _buildTimeWidget("Wednesday", data.wednesday, context),
                        _buildTimeWidget("Thursday", data.thursday, context),
                        _buildTimeWidget("Friday", data.friday, context),
                        _buildTimeWidget("Saturday", data.saturday, context),
                        _buildTimeWidget("Sunday", data.sunday, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        error: (message, exceptions) => Center(child: Text(message ?? "")),
      ),
    );
  }

  Widget _buildTimeWidget(
      String title, List<ShopTimingDetails> details, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: context.screenWidth * 0.15,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
              child: Center(
                child: Text(
                  title.substring(0, 3).toUpperCase(),
                  style: context.customTextTheme.text14W700
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            horizontalSpaceSmall,
            const VerticalDivider(
              thickness: 4,
              color: AppColors.kGray,
            ),
            horizontalSpaceMedium,
            Column(
              children: details
                  .map(
                    (e) => Text("${e.openingTime} - ${e.closingTime}"),
                  )
                  .toList(),
            ),
            const Spacer(),
            const Icon(
              Icons.work_history,
              color: AppColors.kGray,
            )
          ],
        ),
      ),
    );
  }
}

class CustomVerticalDivider extends StatelessWidget {
  const CustomVerticalDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      child: VerticalDivider(
        color: AppColors.kBlack,
        width: 2,
      ),
    );
  }
}
