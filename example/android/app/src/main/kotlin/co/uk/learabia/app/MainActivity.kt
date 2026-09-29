package co.uk.learabia.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private lateinit var appUpdateHelper: AppUpdateHelper

    private val CHANNEL = "app_version_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        appUpdateHelper = AppUpdateHelper(this)
    }

    /**
     * The Flutter engine lives inside a FlutterFragment that is not attached yet
     * while onCreate() runs, so flutterEngine is only safe to use here. Reading
     * it from onCreate() crashes release builds with a NullPointerException inside
     * FlutterFragment.getFlutterEngine() (its delegate is still null at that point).
     */
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                when (call.method) {

                    "checkForUpdate" -> {

                        val forceUpdate =
                            call.argument<Boolean>("forceUpdate")
                                ?: false

                        appUpdateHelper.checkForUpdate(
                            forceUpdate = forceUpdate
                        ) { updateStarted ->

                            result.success(updateStarted)
                        }
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    override fun onResume() {
        super.onResume()

        if (::appUpdateHelper.isInitialized) {
            appUpdateHelper.resumeUpdateIfNeeded()
        }
    }
}
