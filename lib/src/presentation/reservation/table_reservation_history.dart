import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/application/table/table_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/table/models/table_reservation_details.dart';
import 'package:customer_core/src/presentation/widgets/button_progress.dart';
import 'package:customer_core/src/presentation/widgets/custom_back_button.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:intl/intl.dart';

@RoutePage()
class TableReservationHistoryScreen extends GetProviderView<TableProvider> {
  const TableReservationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tableListener = listener(context);
    final tableProvider = notifier(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.kLightWhite,
        appBar: AppBar(
          backgroundColor: AppColors.kLightWhite,
          leadingWidth: 70,
          leading: const CustomBackButton(),
          centerTitle: true,
          title: Text(
            "Table Reservations",
            style: context.customTextTheme.text20W600
                .copyWith(color: AppColors.kBlack),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.kBlack,
            labelStyle: context.customTextTheme.text14W600,
            tabs: const [
              Tab(text: 'History'),
              Tab(text: 'Upcoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // History Tab
            _buildHistoryTab(tableListener),
            // Upcoming Tab
            _buildUpcomingTab(tableListener),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(TableProvider tableListener) {
    return tableListener.tableRespo.when(
      initial: () => const Center(child: Text("Initializing...")),
      loading: () => Center(child: showButtonProgress(AppColors.kBlack2)),
      completed: (data) {
        if (data.isEmpty) {
          return const Center(child: Text("No reservations found."));
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final reservation = data[index];
            log(reservation.bookingTime.toString(), name: "bookingTime");
            return !reservation.bookingTime!.isAfter(DateTime.now())
                ? _buildReservationCard(reservation, context)
                : const SizedBox();
          },
        );
      },
      error: (message, exception) =>
          Center(child: Text(message ?? "An error occurred")),
    );
  }

  Widget _buildUpcomingTab(TableProvider tableListener) {
    return tableListener.tableRespo.when(
      initial: () => const Center(child: Text("Initializing...")),
      loading: () => Center(child: showButtonProgress(AppColors.kBlack2)),
      completed: (data) {
        if (data.isEmpty) {
          return const Center(child: Text("No reservations found."));
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final reservation = data[index];
            return reservation.bookingTime!.isAfter(DateTime.now())
                ? _buildReservationCard(reservation, context)
                : const SizedBox();
          },
        );
      },
      error: (message, exception) =>
          Center(child: Text(message ?? "An error occurred")),
    );
  }

  Widget _buildReservationCard(
      TableReservationDetails reservation, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.kGray.withOpacity(0.2)),
        color: AppColors.kWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_circle_outlined,
                color: AppColors.kBlack,
              ),
              horizontalSpaceSmall,
              Text(
                "${reservation.name}",
                style: context.customTextTheme.text16W700.copyWith(
                  color: AppColors.kBlack,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          verticalSpaceSmall,
          Text(
            'Reservation ID : ${reservation.id}',
            style: context.customTextTheme.text14W500
                .copyWith(color: AppColors.kGray),
          ),
          verticalSpaceSmall,
          Text(
            'Guests : ${reservation.chairs}',
            style: context.customTextTheme.text14W500.copyWith(
              color: AppColors.kGray,
            ),
          ),
          verticalSpaceSmall,
          Text(
            'Phone : ${reservation.phone}',
            style: context.customTextTheme.text14W500
                .copyWith(color: AppColors.kGray),
          ),
          verticalSpaceSmall,
          Text(
            'Date & Time: ${DateFormat('M/d/yyyy h:mm a').format(reservation.bookingTime!)}',
            style: context.customTextTheme.text14W500
                .copyWith(color: AppColors.kGray),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationUpcomingCard(
      TableReservationDetails reservation, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.kGray.withOpacity(0.2)),
        color: AppColors.kWhite,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date : ${DateFormat('MM/dd/yyyy').format(reservation.addedTime!)}',
                style: context.customTextTheme.text12W600
                    .copyWith(color: AppColors.kBlack),
              ),
              Text(
                'Time :  ${DateFormat.jm().format(reservation.addedTime!)}',
                style: context.customTextTheme.text12W600.copyWith(
                  color: AppColors.kBlack,
                ),
              ),
              Text('Reservation ID : ${reservation.id}',
                  style: context.customTextTheme.text12W600.copyWith(
                    color: AppColors.kBlack,
                  ))
            ],
          ),
          verticalSpaceSmall,
          const Divider(
            color: AppColors.kGray,
            thickness: 0.2,
          ),
          verticalSpaceTiny,
          const Divider(
            color: AppColors.kGray,
            thickness: 0.2,
          ),
          verticalSpaceSmall,
          Container(
            child: Row(
              children: [
                // Image.asset(
                //   Assets.images.tableHistory.path,
                //   width: context.screenWidth * 0.25,
                // ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            reservation.name ?? '',
                            style: context.customTextTheme.text14W600
                                .copyWith(color: AppColors.kBlack3),
                          ),
                          horizontalSpaceLarge,
                          horizontalSpaceLarge,
                          horizontalSpaceLarge,
                          Text(reservation.chairs ?? ''),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Phn No : ${reservation.phone.toString()}',
                    style: context.customTextTheme.text12W600,
                  ),
                  Text(
                    'Email : ${reservation.email}',
                    style: context.customTextTheme.text12W600,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // return Card(
  //   color: AppColors.kWhite,
  //   borderOnForeground: false,
  //   margin: const EdgeInsets.all(8.0),
  //   child: ListTile(
  //     title: Row(
  //       children: [
  //         Icon(Icons.account_circle_outlined),
  //         horizontalSpaceSmall,
  //         Text("${reservation.name}"),
  //       ],
  //     ),

  //     subtitle: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Chairs: ${reservation.chairs}"),
  //         Text(
  //           "Booking Time: ${reservation.bookingTime != null ? DateFormat('M/d/yyyy h:mm a').format(reservation.bookingTime!) : ''}",
  //         ),
  //         Text("Phone: ${reservation.phone}"),
  //         Text("Phone: ${reservation.phone}"),
  //       ],
  //     ),

  //   ),
  // );
}
