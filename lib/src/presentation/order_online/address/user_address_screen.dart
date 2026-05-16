import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/order_online/address/add_new_address_screen.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:auto_route/annotations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

@RoutePage()
class UserAddressScreen extends GetProviderView<UserProvider> {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userListener = listener(context);
    final userNotifier = notifier(context);

    final cartProvider = context.read<CartProvider>();
    return Theme(
        data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.quicksandTextTheme(),
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leadingWidth: 70,
            title: Text(
              "Address",
              style: context.customTextTheme.text20W600,
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              userNotifier.initAllTextEditingController();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddNewAddressScreen(null),
                      fullscreenDialog: true));
            },
            child: const Icon(
              FluentIcons.add_24_regular,
              color: Colors.white,
            ),
          ),
          body: userListener.isAddingOrUpdatingUserAddress
              ? const Center(child: CupertinoActivityIndicator())
              : userListener.userAddressList.isEmpty
                  ? Center(
                      child: Text(
                        "No Address Found",
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? null
                                    : Colors.white),
                      ),
                    )
                  : Column(
                      children: [
                        Visibility(
                          visible: userListener.isUserAddressListLoading,
                          child: LinearProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            minHeight: 2.0,
                            backgroundColor: AppColors.kBlack2.withOpacity(0.1),
                          ),
                        ),
                        verticalSpaceRegular,
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => userNotifier.getAddressList(),
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15)
                                      .copyWith(bottom: 100),
                              separatorBuilder: (context, index) =>
                                  verticalSpaceRegular,
                              itemCount: userListener.userAddressList.length,
                              itemBuilder: (context, index) {
                                final address = userListener.userAddressList
                                    .elementAt(index);

                                return ListTile(
                                  tileColor: null,
                                  // shape: RoundedRectangleBorder(
                                  //     side: BorderSide(
                                  //         color:
                                  //             AppColors.kGray.withOpacity(0.3)),
                                  //     borderRadius: BorderRadius.circular(10)),

                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            address.userFullname,
                                            style: context
                                                .customTextTheme.text18W600
                                                .copyWith(
                                                    color: context
                                                        .customTextTheme.color),
                                          ),
                                          horizontalSpaceSmall,
                                          if (address.dDefault == "1")
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                "Default",
                                                style: context
                                                    .customTextTheme.text12W500
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        address.userFulladdress,
                                        style: context
                                            .customTextTheme.text14W700
                                            .copyWith(
                                                color: context
                                                    .customTextTheme.color),
                                      ),
                                    ],
                                  ),
                                  trailing: PopupMenuButton<_AddressMenuAction>(
                                    color: Theme.of(context).cardColor,
                                    icon: Icon(
                                        FluentIcons.more_vertical_24_regular,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 20),
                                    onSelected: (value) async {
                                      switch (value) {
                                        case _AddressMenuAction.edit:
                                          userNotifier
                                              .initAllTextEditingController();
                                          userNotifier.loadDataForAddressUpdate(
                                              address);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AddNewAddressScreen(
                                                address,
                                                isFromProfieView: true,
                                              ),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                          break;

                                        case _AddressMenuAction.delete:
                                          if (address.uaID != null) {
                                            await userNotifier
                                                .deleteUserAddress(
                                                    address.uaID!);
                                            await userNotifier.getAddressList();

                                            cartProvider
                                                .clearSelectedAddressSecondary();
                                            cartProvider.clearSelectedAddress();
                                          }
                                          break;

                                        case _AddressMenuAction.setDefault:
                                          if (address.uaID != null) {
                                            await userNotifier
                                                .setDefaultUserAddress(
                                                    address.uaID!);
                                          }
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: _AddressMenuAction.setDefault,
                                        enabled: address.dDefault == "0",
                                        child: Text(
                                          'Set as default',
                                          style: TextStyle(
                                              color: context
                                                  .customTextTheme.color),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: _AddressMenuAction.edit,
                                        child: Text('Edit',
                                            style: TextStyle(
                                                color: context
                                                    .customTextTheme.color)),
                                      ),
                                      PopupMenuItem(
                                        value: _AddressMenuAction.delete,
                                        child: Text('Delete',
                                            style: TextStyle(
                                                color: context
                                                    .customTextTheme.color)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
        ));
  }
}

enum _AddressMenuAction {
  edit,
  delete,
  setDefault,
}
