import 'package:auto_route/annotations.dart';
import 'package:customer_core/customer_core.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/domain/user/models/user_address_list_data_model.dart';
import 'package:customer_core/src/presentation/widgets/button_progress.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/ui_utils.dart';
import '../../../core/utils/utils.dart';

@RoutePage()
class AddNewAddressScreen extends GetProviderView<UserProvider> {
  final UserAddressDataModel? address;
  final bool isFromProfieView;
  const AddNewAddressScreen(this.address,
      {super.key, this.isFromProfieView = false});

  @override
  Widget build(BuildContext context) {
    final userProvider = notifier(context);
    final userListener = listener(context);

    return Form(
      key: userProvider.newAddressFormKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            address != null ? "Edit Address" : "Add Address",
            // style: context.customTextTheme.text24W600,
          ),
          leading: InkWell(
              onTap: () {
                userListener.searchAddressTxtController.clear();
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                // size: 18,
              )
              // leadingWidth: 60,
              ),
          actions: [
            TextButton(
                onPressed: userListener.isAddingOrUpdatingUserAddress
                    ? null
                    : () async {
                        if (userProvider.newAddressFormKey.currentState
                                ?.validate() ??
                            false) {
                          final cartProvider = context.read<CartProvider>();
                          await userListener
                              .addOrUpdateUserAddress(address?.uaID)
                              .then((done) {
                            if (done) {
                              userProvider.clearAddressForm();
                              cartProvider.syncSelectedAddressWithLatestList(
                                userListener.userAddressList,
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                child: Text(
                    userListener.isAddingOrUpdatingUserAddress
                        ? "Saving.."
                        : "Save",
                    style: TextStyle(
                      color: userListener.isAddingOrUpdatingUserAddress
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                    ))),
            horizontalSpaceRegular,
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0).copyWith(bottom: 15),
            child: _buildAddressForm(context, userProvider, address),
          ),
        ),
        // floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0.0
        //     ? buildConfirmButton(context, userProvider)
        //     : null,
      ),
    );
  }

  Widget _buildAddressForm(BuildContext context, UserProvider userProvider,
      UserAddressDataModel? address) {
    // if (address != null) {
    //   userProvider.addressTitleTxtController.text = address.addressTitle ?? '';
    //   userProvider.firstNameTxtController.text = address.firstName ?? '';
    //   userProvider.lastNameTxtController.text = address.lastName ?? '';
    //   userProvider.line1TxtController.text = address.line1 ?? '';
    //   userProvider.line2TxtController.text = address.line2 ?? '';
    //   userProvider.townTxtController.text = address.town ?? '';
    //   userProvider.postCodeTxtController.text = address.postcode ?? '';
    //   userProvider.countyTxtController.text = address.county ?? '';
    //   userProvider.landMarkTxtController.text = address.landmark ?? '';
    // }
    return Column(
      children: [
        // verticalSpaceSmall,
        // buildTextField(
        //   context: context,
        //   title: 'Address Title *',
        //   hintText: 'Address title',
        //   controller: userProvider.addressTitleTxtController,
        //   validator: (value) => Utils.commonValidator(value, '*required'),
        // ),
        verticalSpaceSmall,
        buildTextField(
          context: context,
          title: 'First Name *',
          hintText: 'First name',
          controller: userProvider.firstNameTxtController,
          validator: (value) => Utils.commonValidator(value, '*required'),
        ),
        verticalSpaceSmall,
        buildTextField(
          context: context,
          title: 'Last Name',
          optional: 'Optional',
          hintText: 'Last name',
          controller: userProvider.lastNameTxtController,
        ),
        verticalSpaceSmall,
        buildTextField(
          context: context,
          title: 'Line 1 *',
          hintText: 'Line 1',
          controller: userProvider.line1TxtController,
          validator: (value) => Utils.commonValidator(value, '*required'),
        ),
        verticalSpaceSmall,
        buildTextField(
          context: context,
          title: 'Line 2',
          optional: 'Optional',
          hintText: 'Line 2',
          controller: userProvider.line2TxtController,
        ),
        verticalSpaceSmall,
        buildTextField(
          context: context,
          title: 'Town *',
          hintText: 'Town',
          controller: userProvider.townTxtController,
          validator: (value) => Utils.commonValidator(value, '*required'),
        ),
        verticalSpaceSmall,
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: buildTextField(
                  context: context,
                  title: 'Postcode *',
                  hintText: 'Postcode',
                  controller: userProvider.postCodeTxtController,
                  // validator: (value) =>
                  //     Utils.commonValidator(value, '*required'),
                  inputFormatters: AppConfig.instance.country == Country.ind
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ]
                      : null,
                  validator: (value) => Utils.postcodeValidator(
                    value,
                    AppConfig.instance.country,
                  ),
                ),
              ),
            ),
            verticalSpaceMedium,
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: buildTextField(
                  context: context,
                  title:
                      AppConfig.instance.businessType == BusinessType.restaurant
                          ? 'County'
                          : 'District',
                  optional: 'Optional',
                  hintText: 'District',
                  controller: userProvider.countyTxtController,
                  // validator: (value) =>
                  //     Utils.commonValidator(value, '*required'),
                ),
              ),
            ),
          ],
        ),
        verticalSpaceSmall,
        buildTextField(
          context: context,
          title: 'Landmark',
          optional: 'Optional',
          hintText: 'Landmark',
          controller: userProvider.landMarkTxtController,
          // validator: (value) =>
          //     Utils.commonValidator(value, '*required'),
        ),
        verticalSpaceRegular,
      ],
    );
  }

  Widget buildConfirmButton(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final userLitsner = context.watch<UserProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: SizedBox(
        width: context.screenWidth,
        height: 45,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primary)),
          onPressed: () async {
            if (userLitsner.isAddingOrUpdatingUserAddress) return;
            if (userProvider.newAddressFormKey.currentState?.validate() ??
                false) {
              final cartProvider = context.read<CartProvider>();
              await userLitsner
                  .addOrUpdateUserAddress(address?.uaID)
                  .then((done) {
                if (done) {
                  cartProvider.syncSelectedAddressWithLatestList(
                    userLitsner.userAddressList,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);

                  userProvider.clearAddressForm();
                }
              });
            }
          },
          child: userLitsner.isAddingOrUpdatingUserAddress
              ? showButtonProgress()
              : Text(
                  address != null ? 'Update' : 'Confirm',
                  style: context.customTextTheme.text16W400.copyWith(
                    fontSize: 18,
                    color: AppColors.kWhite,
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    required String title,
    String? optional,
    String? Function(String?)? validator,
    TextEditingController? controller,
    required BuildContext context,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Text(
                title,
                style: context.customTextTheme.text16W700,
              ),
              horizontalSpaceSmall,
              Text(
                optional ?? '',
                style: context.customTextTheme.text12W400
                    .copyWith(color: AppColors.kGray),
              ),
            ],
          ),
        ),
        verticalSpaceSmall,
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            // style: const TextStyle(color: Colors.black),
            controller: controller,
            onChanged: (value) {},
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              errorMaxLines: 2,
              label: Text(hintText),
              labelStyle: context.customTextTheme.text14W500
                  .copyWith(color: AppColors.kGray),
              hintText: hintText,
              hintStyle: context.customTextTheme.text14W700
                  .copyWith(color: AppColors.kGray),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
