import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:customer_core/src/application/order/order_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/routes/routes.gr.dart';

@RoutePage()
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: const Icon(
        Icons.check_circle,
        size: 150,
        color: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: _buildAnimatedIcon()),
          verticalSpaceRegular,
          Text(
            'Order Created Successfully',
            style: context.customTextTheme.text20W600,
          ),
          verticalSpaceSmall,
          Text(
            "Your order has been created successfully.\n We'll keep you updated on your order.",
            style: context.customTextTheme.text14W500
                .copyWith(color: AppColors.kGray3),
            textAlign: TextAlign.center,
          ),
          verticalSpaceRegular,
          verticalSpaceRegular,
          verticalSpaceRegular,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.router.replaceAll([
                        const OrderOnlineScreenRoute(),
                      ]);
                      context.read<HomeProvider>().onChangeCurrentPage(2);
                      context.read<OrderProvider>().fetchAllOrders();
                    },
                    child: Text(
                      'View Orders',
                      style: context.customTextTheme.text14W700,
                    ),
                  ),
                ),
                verticalSpaceRegular,
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      context.router.replaceAll([
                        const OrderOnlineScreenRoute(),
                      ]);
                      context.read<HomeProvider>().onChangeCurrentPage(0);
                      context.read<OrderProvider>().fetchAllOrders();
                    },
                    child: Text(
                      'Continue Shopping',
                      style: context.customTextTheme.text14W700,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
