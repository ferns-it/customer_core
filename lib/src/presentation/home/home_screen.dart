import 'package:auto_route/auto_route.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/contact_utils.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';

import '../../application/products/products_provider.dart';
// import '../../gen/assets.gen.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final contactFunctionalities = ContactUtilities();

  final List<String> imageUrls = [
    // Assets.images.bstoptbanner1.path,
    // Assets.images.bstoptbanner2.path,
    // Assets.images.bstoptbanner3.path,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildAppbar(context),

            _buildImageSlider(),
            verticalSpaceRegular,
            // _buildCategorySection(productListener),
            verticalSpaceRegular,
            _buildOrderOnlineButton(),
            verticalSpaceRegular,
            _buildViewMenuButton(),
            verticalSpaceRegular,
            // _buildTableReservationButton(context),
            verticalSpaceSmall,
            _buildContactSection(),
            verticalSpaceLarge,
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(ProductsProvider productListener) {
    final categoryListResponse = productListener.categories;

    return SizedBox(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryListResponse.length,
          itemBuilder: (context, index) {
            final categoryList = categoryListResponse[index];

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              margin: const EdgeInsets.only(right: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Center(
                child: Text(
                  categoryList.name ?? "",
                  style: context.customTextTheme.text14W600,
                ),
              ),
            );
          }),
    );
  }

  Widget _buildAppbar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: defaultScreenPadding, bottom: 10.0),
      decoration: BoxDecoration(color: AppColors.kWhite, boxShadow: [
        BoxShadow(
          color: AppColors.kGray.withOpacity(0.15),
          blurRadius: 8.0,
          offset: const Offset(0, 4),
        ),
      ]),
      child: Column(
        children: [
          verticalSpaceXLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                // child: Assets.images.ajLogo.image(height: 45.0),
              ),
              InkWell(
                onTap: () => context.router.push(ProfileScreenRoute(
                  isFromHome: true,
                  onTap: () {},
                )),
                child: CircleAvatar(
                  backgroundColor: AppColors.kWhite,
                  radius: 20.0,
                  backgroundImage: AssetImage(UiConfig.instance.logo),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          viewportFraction: 1.0,
          autoPlay: true,
        ),
        items: imageUrls.map((imageUrl) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Image.asset(imageUrl, fit: BoxFit.contain),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderOnlineButton() {
    return Builder(builder: (context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 14.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: <Widget>[
              Assets.lib.assets.images.foodGifAnimation.image(
                height: 200.0,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Positioned(
                bottom: 10.0,
                left: 18.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "From List to Basket:\nOrder Groceries Online for\nEveryday Essentials",
                      style: context.customTextTheme.text14W600.copyWith(
                        color: AppColors.kWhite,
                      ),
                    ),
                    verticalSpaceTiny,
                    FilledButton(
                      onPressed: () async {
                        context.pushRoute(const OrderOnlineScreenRoute());
                      },
                      style: FilledButton.styleFrom(
                          minimumSize: const Size(100, 38.0),
                          textStyle: context.textTheme.bodySmall,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(color: AppColors.kGray2),
                          )),
                      child: const Text("Order Online"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildViewMenuButton() {
    return Builder(builder: (context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 14.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: <Widget>[
              // Assets.images.pakwaanShop.image(
              //   height: 200.0,
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              // ),
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(60, 60, 60, 1),
                        Color.fromRGBO(0, 0, 0, 0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 18.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "We serve passion &\ntradition",
                      style: context.customTextTheme.text20W600.copyWith(
                        color: AppColors.kWhite,
                      ),
                    ),
                    verticalSpaceSmall,
                    InkWell(
                      onTap: () {
                        context.router.push(const StoreScreenRoute());
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "See More",
                            style: context.customTextTheme.text14W600.copyWith(
                              color: AppColors.kWhite,
                              height: 0.0,
                            ),
                          ),
                          horizontalSpaceTiny,
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.kWhite,
                            size: 14.0,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTableReservationButton(BuildContext context) {
    // final tableProvider = notifier(context);
    return Builder(builder: (context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 14.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: <Widget>[
              Assets.lib.assets.images.restaurantSeating.image(
                height: 140.0,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(60, 60, 60, 1),
                        Color.fromRGBO(0, 0, 0, 0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16.0,
                left: 18.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Book your table\ntoday and join us !",
                      style: context.customTextTheme.text20W600.copyWith(
                        color: AppColors.kWhite,
                      ),
                    ),
                    verticalSpaceTiny,
                    Row(
                      children: [
                        FilledButton(
                          onPressed: () {
                            context.router
                                .push(const TableReservationScreenRoute());
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(100, 38.0),
                            textStyle: context.textTheme.bodySmall,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(color: AppColors.kGray2),
                            ),
                          ),
                          child: const Text("Book a Table"),
                        ),
                        horizontalSpaceMedium,
                        FilledButton(
                          onPressed: () async {
                            context.router.push(
                                const TableReservationHistoryScreenRoute());
                            // await tableProvider.fetchAllTableReservations();
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(100, 38.0),
                            textStyle: context.textTheme.bodySmall,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(color: AppColors.kGray2),
                            ),
                          ),
                          child: const Text("History"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContactSection() {
    return Builder(builder: (context) {
      return Column(
        children: <Widget>[
          Text(
            "Get In Touch",
            style: context.customTextTheme.text14W600.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          verticalSpaceTiny,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // contactFunctionalities.makePhoneCall('1245422891');
                      if (AppIdentifiers.kShopInfoPh.length > 1) {
                        showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: AppIdentifiers.kShopInfoPh.map(
                                (e) {
                                  return InkWell(
                                    onTap: () =>
                                        contactFunctionalities.makePhoneCall(e),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: AppColors.kGray2),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(children: [
                                            const Icon(
                                                FluentIcons.call_24_filled),
                                            horizontalSpaceRegular,
                                            Text(e),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          },
                        );
                      }
                    },
                    child: Card(
                      color: const Color(0xFFfaf8fb),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide.none,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              verticalSpaceSmall,
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
                                  FluentIcons.call_24_regular,
                                  color: AppColors.kWhite,
                                ),
                              ),
                              verticalSpaceSmall,
                              Text(
                                "Call Us",
                                style: context.customTextTheme.text12W600,
                              ),
                              verticalSpaceTiny,
                              FittedBox(
                                child: Text(
                                  AppIdentifiers.kShopInfoPh.length > 1
                                      ? "Tel: ${AppIdentifiers.kShopInfoPh.first}, + ${AppIdentifiers.kShopInfoPh.length - 1}"
                                      : "Tel: ${AppIdentifiers.kShopInfoPh.first}",
                                  style: context.customTextTheme.text10W400,
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                ),
                              ),
                              verticalSpaceSmall,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                horizontalSpaceLarge,
                Expanded(
                  child: InkWell(
                    onTap: () {
                      contactFunctionalities.sendEmail(
                        path: AppIdentifiers.kShopInfoEmail,
                      );
                    },
                    child: Card(
                      color: const Color(0xFFfaf8fb),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide.none,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              verticalSpaceSmall,
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
                                  FluentIcons.mail_24_regular,
                                  color: AppColors.kWhite,
                                ),
                              ),
                              verticalSpaceSmall,
                              Text(
                                "Email Us",
                                style: context.customTextTheme.text12W600,
                              ),
                              verticalSpaceTiny,
                              FittedBox(
                                child: Text(
                                  AppIdentifiers.kShopInfoEmail,
                                  style: context.customTextTheme.text10W400,
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                ),
                              ),
                              verticalSpaceSmall,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
