package app.ister.player

import android.os.Build
import android.view.Display
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Extends audio_service's activity (the manifest used it directly before) so
 * background audio keeps working while this adds the display platform channel.
 */
class MainActivity : AudioServiceActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app.ister.player/display")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getHdrCapabilities" -> result.success(hdrCapabilities())
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Whether the current display can show HDR content, and which HDR types it
     * supports (values from [Display.HdrCapabilities], e.g. 2 = HDR10, 3 = HLG).
     */
    private fun hdrCapabilities(): Map<String, Any> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return mapOf("isHdr" to false, "hdrTypes" to emptyList<Int>())
        }
        val display: Display? =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) display
            else @Suppress("DEPRECATION") windowManager.defaultDisplay
        val isHdr = display?.isHdr ?: false
        val types =
            display?.hdrCapabilities?.supportedHdrTypes?.toList() ?: emptyList()
        return mapOf("isHdr" to isHdr, "hdrTypes" to types)
    }
}
