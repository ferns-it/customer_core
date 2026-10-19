import 'package:auto_route/auto_route.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:customer_core/src/application/core/time_dropdown_provider.dart';
import 'package:customer_core/src/application/table/table_provider.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/widgets/custom_back_button.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:customer_core/src/presentation/widgets/qty_counter_button.dart';
import 'package:customer_core/src/presentation/widgets/time_dropdown.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';

@RoutePage()
class TableReservationScreen extends GetProviderView<TableProvider> {
  const TableReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tableListener = listener(context);
    final tableProvider = notifier(context);
    final userListener = listener2<UserProvider>(context);
    final timeDropdownProvider = notifier2<TimeDropdownProvider>(context);

    return PopScope(
      onPopInvoked: (_) {
        Future.delayed(const Duration(milliseconds: 800), () {
          timeDropdownProvider.clearValues();
          tableProvider.clearValues();
        });
      },
      child: Scaffold(
        backgroundColor: AppColors.kLightWhite2,
        appBar: AppBar(
          leading: const CustomBackButton(),
          leadingWidth: 70,
          backgroundColor: AppColors.kLightWhite2,
          centerTitle: true,
          title: const Text("Book A Table"),
        ),
        bottomSheet: Visibility(
          visible: MediaQuery.viewInsetsOf(context).bottom == 0.0,
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration:
                BoxDecoration(color: AppColors.kLightWhite2, boxShadow: [
              BoxShadow(
                color: AppColors.kGray.withOpacity(0.15),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(Icons.info_outline, size: 22),
                    horizontalSpaceSmall,
                    Flexible(
                      child: Text(
                        "Booking updates will be sent to your registered email address: ${userListener.userData?.user.userEmail}.",
                        style: context.customTextTheme.text12W500,
                      ),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                FilledButton(
                  onPressed: () async {
                    if (timeDropdownProvider.timeNotSelected) {
                      AlertDialogs.showError("Please select booking time");
                      return;
                    }
                    final reserved = await tableProvider.reserveADiningTable(
                      reservationTime:
                          timeDropdownProvider.selectedTimeAsTimeOfDay!,
                    );
                    if (reserved) {
                      context.router.back();
                    }
                  },
                  child: tableListener.isReservingTable
                      ? CircularProgressIndicator.adaptive()
                      : const Text("Book a Table"),
                ),
                verticalSpaceTiny,
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: defaultScreenPadding,
          ),
          child: FormBuilder(
            key: tableProvider.reservationFormKey,
            child: ListView(
              children: <Widget>[
                verticalSpaceSmall,
                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    selectableDayPredicate: (date) => date.isAfter(
                        DateTime.now().subtract(const Duration(days: 1))),
                    daySplashColor: AppColors.kBlack2.withOpacity(0.1),
                  ),
                  value: [tableListener.reservationDate],
                  onValueChanged: (dates) {
                    tableProvider.onChangeReservationDate(dates.first);
                    context
                        .read<TimeDropdownProvider>()
                        .updateSelectedDate(dates.first);
                  },
                ),
                verticalSpaceSmall,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Booking Time",
                            style: context.customTextTheme.text12W600,
                          ),
                          verticalSpaceTiny,
                          const TimeDropdown(),
                        ],
                      ),
                    ),
                    horizontalSpaceMedium,
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        verticalSpaceTiny,
                        Text(
                          "No of Party Size",
                          style: context.customTextTheme.text12W600,
                        ),
                        verticalSpaceSmall,
                        QtyCounterButton2(
                          qty: tableListener.totalChair,
                          onIncrementQty: tableProvider.incrementTotalChairs,
                          onDecrementQty: tableProvider.decrementTotalChairs,
                        ),
                      ],
                    ))
                  ],
                ),
                verticalSpaceRegular,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Booking Person Name",
                            style: context.customTextTheme.text12W600,
                          ),
                          verticalSpaceTiny,
                          FormBuilderTextField(
                            decoration: const InputDecoration(
                              hintText: "Name",
                            ),
                            textInputAction: TextInputAction.done,
                            name: 'name',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ],
                      ),
                    ),
                    horizontalSpaceSmall,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Phone number",
                            style: context.customTextTheme.text12W600,
                          ),
                          verticalSpaceTiny,
                          FormBuilderTextField(
                            decoration: const InputDecoration(
                              hintText: "Phone Number",
                            ),
                            name: "phone",
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.phoneNumber(),
                            ]),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                verticalSpaceRegular,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Message to restaurant",
                      style: context.customTextTheme.text12W600,
                    ),
                    verticalSpaceTiny,
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        hintText: "Message...",
                      ),
                      name: "message",
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLines: 3,
                    ),
                  ],
                ),
                verticalSpaceRegular,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
