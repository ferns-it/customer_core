import 'package:auto_route/auto_route.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/app_theme.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/offer/models/offer_details_model.dart';
import 'package:customer_core/src/presentation/widgets/custom_back_button.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';

@RoutePage()
class CoupenScreen extends GetProviderView<CartProvider> {
  const CoupenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = notifier(context);
    final cartListener = listener(context);
    final List<OfferDetailsModel> offerList = cartListener.offerList;

    return Scaffold(
      backgroundColor: AppColors.kLightWhite,
      appBar: AppBar(
        leading: const CustomBackButton(),
        leadingWidth: 70,
        backgroundColor: AppColors.kLightWhite,
        title: Text(
          'Coupons',
          style: context.customTextTheme.text20W600,
        ),
        centerTitle: true,
      ),
      body: cartListener.isOfferListLoading
          ?  Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  verticalSpaceMedium,
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return cartProvider.listCartItems();
                      },
                      child: offerList.isEmpty
                          ? const Center(child: Text("No coupons found."))
                          : ListView.builder(
                              itemCount: offerList.length,
                              itemBuilder: (context, index) {
                                return _CouponDetailsTile(
                                  detailsModel: offerList.elementAt(index),
                                  cartProvider: cartProvider,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _CouponDetailsTile extends StatelessWidget {
  const _CouponDetailsTile({
    required this.detailsModel,
    required this.cartProvider,
  });

  final OfferDetailsModel detailsModel;
  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: quickSandTextTheme(context),
      child: Builder(builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: const BoxDecoration(
            color: AppColors.kWhite,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 110,
          width: double.infinity,
          child: LayoutBuilder(builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildCouponHead(context, detailsModel),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Assets.lib.assets.images.offers.image(
                            height: 20,
                            width: 20,
                          ),
                          horizontalSpaceTiny,
                          Text(
                            detailsModel.coupenCode ?? '',
                            style: context.customTextTheme.text14W700.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          horizontalSpaceSmall,
                        ],
                      ),
                      detailsModel.coupenDetails?.isEmpty == true
                          ? const SizedBox.shrink()
                          : Text(
                              detailsModel.coupenDetails ?? '',
                              style: context.customTextTheme.text14W600
                                  .copyWith(color: AppColors.kGray),
                            ),
                      Text(
                        'Min order ${AppConfig.instance.country.symbol}${detailsModel.minSpend ?? ''}',
                        style: context.customTextTheme.text14W500
                            .copyWith(color: AppColors.kGray),
                      ),
                    ],
                  ),
                ),
                horizontalSpaceSmall,
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      if (detailsModel.coupenCode?.isEmpty == true) {
                        AlertDialogs.showError(
                          "Sorry, unable to apply this coupon right now.",
                        );
                        return;
                      }

                      final applied = await cartProvider
                          .validateOffer(detailsModel.coupenCode!);

                      if (applied) {
                        // ignore: use_build_context_synchronously
                        context.router.back();
                      } else {
                        AlertDialogs.showError(
                          "Sorry, unable to apply this coupon right now. Try again!",
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(20, 22),
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 14, vertical: 5)),
                    child: Text(
                      "APPLY",
                      style: context.customTextTheme.text14W600,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2),
                  child: CustomPaint(
                    size: const Size(2, double.infinity),
                    painter: DashedLineVerticalPainter(),
                  ),
                ),
              ],
            );
          }),
        );
      }),
    );
  }

  Widget buildCouponHead(
    BuildContext context,
    OfferDetailsModel detailsModel,
  ) {
    return Container(
      width: 100,
      color: AppColors.kBlack3,
      child: CustomPaint(
        painter: SpikyEdgePainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              detailsModel.coupenAmount != null
                  ? "${detailsModel.coupenType == "percentage" ? "%" : AppConfig.instance.country.symbol} ${detailsModel.coupenAmount!.replaceAll(".00", "")}"
                  : "",
              style: context.customTextTheme.text20W600.copyWith(
                color: AppColors.kWhite,
              ),
            ),
            Text(
              'OFF',
              style: context.customTextTheme.text20W600.copyWith(
                color: AppColors.kWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpikyEdgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kWhite
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start at the top-left corner
    path.moveTo(0, 0);

    const double spikeWidth = 8.0;
    const double spikeHeight = 10.0;

    // Draw the spikes along the left edge
    for (double i = 0; i < size.height; i += spikeHeight) {
      path.lineTo(spikeWidth, i + spikeHeight / 2); // Diagonal spike inward
      path.lineTo(0, i + spikeHeight); // Back to edge
    }

    path.lineTo(0, size.height); // Bottom-left corner
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CircleCutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Draw the base rectangle
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Add a circular cutout
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, size.height / 2), // Right-center
        radius: size.height / 4, // Adjust radius as needed
      ),
    );

    path.fillType = PathFillType.evenOdd; // Cut out the circle
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
