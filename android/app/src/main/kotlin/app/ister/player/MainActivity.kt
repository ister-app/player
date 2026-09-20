package app.ister.player

import android.content.Intent
import android.content.pm.ActivityInfo
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// Extends AudioServiceActivity (not FlutterActivity): audio_service needs its
// activity to share the Flutter engine with the background audio task.
class MainActivity : AudioServiceActivity() {
    private var uploadSource: UploadSourceChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        uploadSource = UploadSourceChannel(this, flutterEngine.dartExecutor.binaryMessenger)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "app.ister.player/orientation",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                // SENSOR_LANDSCAPE follows the sensor between both landscape
                // orientations even when the system rotation lock is on —
                // SystemChrome's [landscapeLeft, landscapeRight] maps to
                // USER_LANDSCAPE, which respects the lock and never flips 180°.
                "lockSensorLandscape" -> {
                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
                    result.success(null)
                }
                "unlock" -> {
                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    // The folder picker of the admin upload answers here; everything else is the plugins'.
    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (uploadSource?.onActivityResult(requestCode, resultCode, data) == true) return
        super.onActivityResult(requestCode, resultCode, data)
    }
}
