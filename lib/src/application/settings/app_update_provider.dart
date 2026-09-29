import 'dart:io';

import 'package:customer_core/src/domain/firebase/models/remote_config_model.dart';
import 'package:customer_core/src/domain/firebase/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateProvider extends ChangeNotifier {
  final remoteConfigService = RemoteConfigService();

  static const String _dismissedKeyPrefix = 'update_dismissed_at_';

  static const Duration _remindLaterDuration = Duration(hours: 6);

  bool _dialogVisible = false;

  Future<bool> checkForUpdate([BuildContext? context]) async {
    // Prevent stacked duplicate dialogs from repeated calls.
    if (_dialogVisible) {
      debugPrint('Update dialog already visible — skipping duplicate check.');
      return true;
    }

    try {
      debugPrint('========== App Update Check ==========');

      // 1. Refresh Firebase Remote Config (safe: never throws out).
      await remoteConfigService.refresh();

      // 2. Get current app version/build.
      String currentVersion = '1.0.0';
      int currentBuildNumber = 0;
      try {
        final packageInfo = await PackageInfo.fromPlatform().timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            debugPrint('PackageInfo timed out — using fallback version.');
            throw StateError('PackageInfo timed out');
          },
        );
        if (packageInfo.version.trim().isNotEmpty) {
          currentVersion = packageInfo.version.trim();
        }
        currentBuildNumber = int.tryParse(packageInfo.buildNumber.trim()) ?? 0;
      } catch (e) {
        // MissingPluginException in tests / store metadata unavailable:
        // fall back to defaults instead of crashing.
        debugPrint('PackageInfo unavailable (non-fatal): $e');
      }

      final config = remoteConfigService.config;

      if (config == null) {
        debugPrint(
          'Remote config unavailable — checking Play In-App Update only.',
        );
        return _performPlayUpdate(forceUpdate: false);
      }

      final forceUpdateRequired = config.forceUpdateRequired;

      final isVersionBehind = config.isVersionBehind(currentVersion);

      final isBuildBehind = config.isBuildNumberBehind(currentBuildNumber);

      final isUpdateRequired = isVersionBehind || isBuildBehind;

      debugPrint('forceUpdateRequired: $forceUpdateRequired');
      debugPrint('remoteVersion: ${config.version}');
      debugPrint('remoteBuildNumber: ${config.buildNumber}');
      debugPrint('currentVersion: $currentVersion');
      debugPrint('currentBuildNumber: $currentBuildNumber');
      debugPrint('isVersionBehind: $isVersionBehind');
      debugPrint('isBuildBehind: $isBuildBehind');
      debugPrint('isUpdateRequired: $isUpdateRequired');
      debugPrint('updateUrl: ${config.updateUrl}');
      debugPrint('=====================================');

      // ── NO → Check Google Play → In-app update if available ──
      if (!isUpdateRequired) {
        debugPrint('Remote Config: no update required. Checking Play.');
        return _performPlayUpdate(forceUpdate: false);
      }

      // Remote Config says an update is required but there is no UI context
      // (e.g. headless unit test): report it without showing a dialog.
      if (context == null || !context.mounted) {
        debugPrint('Update required but no valid context — skipping dialog.');
        return isUpdateRequired;
      }

      if (!forceUpdateRequired) {
        final prefs = await SharedPreferences.getInstance();
        final dismissedAt = prefs.getString(
          '$_dismissedKeyPrefix${config.version}_${config.buildNumber}',
        );

        if (dismissedAt != null) {
          final dismissedTime = DateTime.tryParse(dismissedAt);

          if (dismissedTime != null &&
              DateTime.now().isBefore(
                dismissedTime.add(_remindLaterDuration),
              )) {
            debugPrint(
              'Optional update was dismissed recently.',
            );
            // Even when snoozed, still allow a silent Play flexible update.
            await _performPlayUpdate(forceUpdate: false);
            return true;
          }
        }
      }
      if (!context.mounted) return true;

      await _showUpdateDialog(
        context: context,
        config: config,
        currentVersion: currentVersion,
        currentBuildNumber: currentBuildNumber,
      );
      return true;
    } catch (e) {
      debugPrint('Error in app update check (non-fatal): $e');
      return false;
    }
  }

  Future<bool> _performPlayUpdate({
    required bool forceUpdate,
  }) async {
    // `in_app_update` is Android-only: guard so iOS/desktop/web never crash
    // with MissingPluginException / PlatformException.
    if (!Platform.isAndroid) return false;
    try {
      final info = await InAppUpdate.checkForUpdate().timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          debugPrint('Play update check timed out');
          throw StateError('Play update check timed out');
        },
      );

      debugPrint(
        'Play update availability: '
        '${info.updateAvailability}',
      );

      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return false;
      }

      if (forceUpdate) {
        // Mandatory update → blocking immediate flow. If Play throws
        // (e.g. update cancelled / not allowed), return false so the
        // dialog's store-URL fallback still gives the user a path forward.
        try {
          await InAppUpdate.performImmediateUpdate();
          return true;
        } catch (e) {
          debugPrint('Immediate Play update failed (non-fatal): $e');
          return false;
        }
      }

      // Optional update → flexible flow (user keeps using the app while it
      // downloads). Do NOT call completeFlexibleUpdate() immediately: it
      // throws until the download reaches DOWNLOADED state; completion is
      // handled via the DOWNLOADED listener / next resume.
      try {
        await InAppUpdate.startFlexibleUpdate();
        return true;
      } catch (e) {
        debugPrint('Flexible Play update failed (non-fatal): $e');
        return false;
      }
    } catch (e) {
      debugPrint(
        'Google Play In-App Update unavailable/failed (non-fatal): $e',
      );
      return false;
    }
  }

  Future<void> _showUpdateDialog({
    required BuildContext context,
    required RemoteConfigModel config,
    required String currentVersion,
    required int currentBuildNumber,
  }) async {
    final forceUpdateRequired = config.forceUpdateRequired;

    final updateUrl = config.updateUrl.trim();
    final updateMessage = config.updateMessage.trim().isEmpty
        ? 'A new version is available. Please update to continue using the app.'
        : config.updateMessage.trim();

    final isVersionBehind = config.isVersionBehind(currentVersion);

    final isBuildBehind = config.isBuildNumberBehind(currentBuildNumber);

    // Safety: never trap the user on a blocking dialog when there is no
    // actionable update path (no Play on this platform AND no store URL).
    // Showing a non-dismissible dialog with no "Update" action would
    // soft-lock the app.
    if (forceUpdateRequired && updateUrl.isEmpty && !Platform.isAndroid) {
      debugPrint(
        'Force update required but no update URL and no Play support — '
        'skipping blocking dialog to avoid soft-lock.',
      );
      return;
    }

    if (!context.mounted || _dialogVisible) return;
    _dialogVisible = true;
    try {
      await showDialog<void>(
        context: context,
        // Optional updates can be dismissed by tapping outside;
        // force updates cannot.
        barrierDismissible: !forceUpdateRequired,
        useRootNavigator: true,
        builder: (dialogContext) {
          return PopScope(
            canPop: !forceUpdateRequired,
            // child: AlertDialog(
            //   title: Row(
            //     children: [
            //       const Icon(
            //         Icons.system_update_alt,
            //         color: Colors.orange,
            //         size: 28,
            //       ),
            //       const SizedBox(width: 8),
            //       const Expanded(
            //         child: Text(
            //           'Update Required',
            //           style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            //   content: SingleChildScrollView(
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Container(
            //           width: double.infinity,
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             color: Colors.orange.shade50,
            //             borderRadius: BorderRadius.circular(8),
            //             border: Border.all(
            //               color: Colors.orange.shade200,
            //             ),
            //           ),
            //           child: Text(
            //             updateMessage,
            //             style: TextStyle(
            //               fontSize: 14,
            //               color: Colors.orange.shade900,
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //         ),
            //         const SizedBox(height: 12),
            //         if (isVersionBehind)
            //           _buildInfoRow(
            //             'New Version',
            //             config.version,
            //             Icons.new_releases_outlined,
            //           ),
            //         const SizedBox(height: 6),
            //         if (isBuildBehind)
            //           _buildInfoRow(
            //             'Build',
            //             config.buildNumber.toString(),
            //             Icons.build_outlined,
            //           ),
            //         const SizedBox(height: 6),
            //         if (!isVersionBehind && !isBuildBehind)
            //           _buildInfoRow(
            //             'Current Version',
            //             currentVersion,
            //             Icons.info_outline,
            //           ),
            //         if (forceUpdateRequired)
            //           const Padding(
            //             padding: EdgeInsets.only(top: 12),
            //             child: Row(
            //               children: [
            //                 Icon(
            //                   Icons.warning_amber_rounded,
            //                   color: Colors.red,
            //                   size: 18,
            //                 ),
            //                 SizedBox(width: 6),
            //                 Expanded(
            //                   child: Text(
            //                     'This update is mandatory',
            //                     style: TextStyle(
            //                       color: Colors.red,
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 13,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //       ],
            //     ),
            //   ),
            //   actions: [
            //     TextButton.icon(
            //       onPressed: () async {
            //         // On Android, prefer the Play In-App Update flow; fall
            //         // back to the store URL when Play is unavailable.
            //         if (Platform.isAndroid) {
            //           try {
            //             final started = await _performPlayUpdate(
            //               forceUpdate: forceUpdateRequired,
            //             );
            //             if (started) return;
            //           } catch (e) {
            //             debugPrint('Play update from dialog failed: $e');
            //           }
            //         }
            //         if (updateUrl.isEmpty) {
            //           debugPrint('No update URL configured.');
            //           return;
            //         }
            //         try {
            //           // Uri.parse throws on malformed URLs — must not crash
            //           // the app from a dialog button.
            //           final uri = Uri.tryParse(updateUrl);
            //           if (uri == null ||
            //               !(uri.isScheme('http') || uri.isScheme('https'))) {
            //             debugPrint('Invalid update URL: $updateUrl');
            //             return;
            //           }
            //           if (await canLaunchUrl(uri)) {
            //             await launchUrl(
            //               uri,
            //               mode: LaunchMode.externalApplication,
            //             );
            //           } else {
            //             debugPrint('Cannot launch update URL: $updateUrl');
            //           }
            //         } catch (e) {
            //           debugPrint(
            //             'Unable to open update URL (non-fatal): $e',
            //           );
            //         }
            //       },
            //       icon: const Icon(
            //         Icons.open_in_new,
            //         size: 18,
            //       ),
            //       label: const Text('Update Now'),
            //     ),
            //     if (!forceUpdateRequired)
            //       TextButton(
            //         onPressed: () async {
            //           try {
            //             final prefs = await SharedPreferences.getInstance();
            //             await prefs.setString(
            //               '$_dismissedKeyPrefix${config.version}_'
            //               '${config.buildNumber}',
            //               DateTime.now().toIso8601String(),
            //             );
            //           } catch (e) {
            //             debugPrint(
            //               'Failed to persist snooze (non-fatal): $e',
            //             );
            //           }
            //           if (dialogContext.mounted) {
            //             Navigator.of(dialogContext, rootNavigator: true).pop();
            //           }
            //         },
            //         child: const Text(
            //           'Remind Me Later',
            //           style: TextStyle(
            //             color: Colors.grey,
            //           ),
            //         ),
            //       ),
            //   ],
            // ),
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.system_update_alt,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Update Required',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Remote config update message
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.35)),
                    ),
                    child: Text(
                      updateMessage.isNotEmpty
                          ? updateMessage
                          : 'A new version is available. Please update to continue using the app.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Version info
                  if (isVersionBehind) ...[
                    _buildInfoRow(
                      'Current Version',
                      currentVersion,
                      Icons.info_outline,
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      'Required Version',
                      config.version,
                      Icons.info_outline,
                    ),
                  ],

                  // Build number info
                  if (isBuildBehind) ...[
                    _buildInfoRow(
                      'Current Build',
                      currentBuildNumber.toString(),
                      Icons.build_outlined,
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      'Required Build',
                      config.buildNumber.toString(),
                      Icons.build_outlined,
                    ),
                  ],

                  if (!isVersionBehind && !isBuildBehind)
                    _buildInfoRow(
                      'Current Version',
                      currentVersion,
                      Icons.info_outline,
                    ),

                  // Mandatory warning
                  if (forceUpdateRequired)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 6),
                          const Text(
                            'This update is mandatory',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              actions: [
                // "Update Now" button — only if we have a URL
                if (updateUrl.isNotEmpty)
                  TextButton.icon(
                    onPressed: () async {
                      try {
                        final uri = Uri.parse(updateUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                      } catch (e) {
                        AlertDialog(
                          title: Text('Unable to open update link'),
                        );
                      }
                    },
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Update Now'),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Please update from your app store',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),

                const SizedBox(width: 8),

                // "Remind Me Later" — only show when NOT a force update
                if (!forceUpdateRequired)
                  // TextButton(
                  //   onPressed: () {
                  //     // Save dismissal time so we don't bug the user again immediately
                  //     _box.write(_dismissedKey, DateTime.now().toIso8601String());
                  //     Get.back();
                  //   },
                  //   child: const Text(
                  //     'Remind Me Later',
                  //     style: TextStyle(color: Colors.grey),
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () async {
                      try {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(
                          '$_dismissedKeyPrefix${config.version}_'
                          '${config.buildNumber}',
                          DateTime.now().toIso8601String(),
                        );
                      } catch (e) {
                        debugPrint(
                          'Failed to persist snooze (non-fatal): $e',
                        );
                      }
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext, rootNavigator: true).pop();
                      }
                    },
                    child: const Text(
                      'Remind Me Later',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  )
              ],
            ),
          );
        },
      );
    } finally {
      _dialogVisible = false;
    }
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  // Widget _buildInfoRow(
  //   String label,
  //   String value,
  //   IconData icon,
  // ) {
  //   return Row(
  //     children: [
  //       Icon(
  //         icon,
  //         size: 16,
  //         color: Colors.grey.shade600,
  //       ),
  //       const SizedBox(width: 6),
  //       Text(
  //         '$label: ',
  //         style: TextStyle(
  //           fontSize: 13,
  //           color: Colors.grey.shade700,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //       Text(
  //         value,
  //         style: const TextStyle(
  //           fontSize: 13,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
