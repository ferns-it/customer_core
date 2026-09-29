package co.uk.learabia.app

import android.app.Activity
import android.util.Log
import com.google.android.play.core.appupdate.AppUpdateInfo
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.InstallStateUpdatedListener
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.InstallStatus
import com.google.android.play.core.install.model.UpdateAvailability

class AppUpdateHelper(
    private val activity: Activity
) {

    companion object {
        const val UPDATE_REQUEST_CODE = 1001
    }

    private val appUpdateManager: AppUpdateManager =
        AppUpdateManagerFactory.create(activity)

    /**
     * A flexible update is only downloaded in the background. Once the download
     * finished the update has to be completed (installed) explicitly.
     */
    private val installStateUpdatedListener =
        InstallStateUpdatedListener { installState ->
            if (installState.installStatus() == InstallStatus.DOWNLOADED) {
                appUpdateManager.completeUpdate()
            }
        }

    fun checkForUpdate(
        forceUpdate: Boolean,
        onResult: (Boolean) -> Unit
    ) {
        appUpdateManager.appUpdateInfo
            .addOnSuccessListener { appUpdateInfo ->

                val updateAvailable =
                    appUpdateInfo.updateAvailability() ==
                        UpdateAvailability.UPDATE_AVAILABLE

                if (!updateAvailable) {
                    onResult(false)
                    return@addOnSuccessListener
                }

                val updateType = if (forceUpdate) {
                    AppUpdateType.IMMEDIATE
                } else {
                    AppUpdateType.FLEXIBLE
                }

                if (appUpdateInfo.isUpdateTypeAllowed(updateType)) {
                    try {
                        startUpdate(appUpdateInfo, updateType)
                        onResult(true)
                    } catch (e: Exception) {
                        // The Dart side awaits this answer, so it must always be
                        // reported exactly once.
                        Log.e("APP_UPDATE", "Could not start the update flow", e)
                        onResult(false)
                    }
                } else {
                    onResult(false)
                }
            }
            .addOnFailureListener {
                onResult(false)
            }
    }

    private fun startUpdate(
        appUpdateInfo: AppUpdateInfo,
        updateType: Int
    ) {
        if (updateType == AppUpdateType.FLEXIBLE) {
            appUpdateManager.registerListener(installStateUpdatedListener)
        }

        appUpdateManager.startUpdateFlowForResult(
            appUpdateInfo,
            activity,
            com.google.android.play.core.appupdate.AppUpdateOptions
                .newBuilder(updateType)
                .build(),
            UPDATE_REQUEST_CODE
        )
    }

    fun resumeUpdateIfNeeded() {
        appUpdateManager.appUpdateInfo
            .addOnSuccessListener { appUpdateInfo ->

                if (
                    appUpdateInfo.updateAvailability() ==
                        UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS
                ) {
                    appUpdateManager.startUpdateFlowForResult(
                        appUpdateInfo,
                        activity,
                        com.google.android.play.core.appupdate.AppUpdateOptions
                            .newBuilder(AppUpdateType.IMMEDIATE)
                            .build(),
                        UPDATE_REQUEST_CODE
                    )
                }
            }
    }
}
