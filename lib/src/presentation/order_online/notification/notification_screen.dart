import 'package:auto_route/auto_route.dart';
import 'package:customer_core/src/application/theme/theme_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/notification/models/notification_model.dart';
import 'package:customer_core/src/infrastructure/notification/notification_shared_prefs_repo.dart';
import 'package:provider/provider.dart';

@RoutePage()
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    NotificationSharedPrefs.getNotification().then((value) {
      setState(() {
        notifications = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeListener = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        title: Text(
          "Notifications",
          style: context.customTextTheme.text20W600,
        ),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications found"))
          : ListView.builder(
              itemCount: notifications.length,
              padding: EdgeInsets.only(bottom: context.screenHeight * 0.1),
              itemBuilder: (context, index) {
                final notification = notifications.elementAt(index);
                return ListTile(
                  leading: Icon(FluentIcons.alert_20_regular,
                      color: context.customTextTheme.color),
                  title: Text(notification.title ?? ''),
                  titleTextStyle:
                      TextStyle(color: context.customTextTheme.color),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.body ?? '',
                        style: TextStyle(color: context.customTextTheme.color),
                      ),
                      notification.dateTime != null
                          ? Text(
                              checkTimeDifference(
                                  notification.dateTime ?? DateTime.now()),
                              style: TextStyle(
                                  color: themeListener.isDarkMode
                                      ? Colors.grey
                                      : Colors.grey),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: notifications.isEmpty
          ? null
          : FloatingActionButton.extended(
              //
              elevation: 6,
              extendedPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () {
                NotificationSharedPrefs.clearNotification();
                setState(() {
                  notifications = [];
                });
              },
              backgroundColor: Colors.red.shade100,
              icon: Icon(FluentIcons.delete_20_regular,
                  color: Colors.red.shade700),
              label: Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  String checkTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
