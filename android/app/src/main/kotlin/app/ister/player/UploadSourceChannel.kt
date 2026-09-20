package app.ister.player

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.DocumentsContract
import android.provider.DocumentsContract.Document
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.FileInputStream
import java.nio.ByteBuffer
import java.util.concurrent.Executors

/**
 * The folder source of the admin upload (lib/utils/upload/upload_source_native.dart).
 *
 * A folder picked through the storage access framework is a tree URI, not a
 * path: on Android 11+ the app may neither list nor open the path behind it,
 * and subtitles, nfo files and epubs are outside every media permission. So
 * the tree is walked and read here, through the ContentResolver, and Dart only
 * ever sees document URIs and byte ranges.
 */
class UploadSourceChannel(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "app.ister.player/upload_source")
    private val main = Handler(Looper.getMainLooper())

    // Listing a large tree and reading from a slow provider both block; neither
    // may happen on the platform thread.
    private val io = Executors.newFixedThreadPool(2)
    private var pendingPick: MethodChannel.Result? = null

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "pickFolder" -> pickFolder(result)
                "read" -> read(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun pickFolder(result: MethodChannel.Result) {
        if (pendingPick != null) {
            result.error("busy", "A folder picker is already open", null)
            return
        }
        pendingPick = result
        try {
            activity.startActivityForResult(Intent(Intent.ACTION_OPEN_DOCUMENT_TREE), REQUEST_CODE)
        } catch (e: Exception) {
            pendingPick = null
            result.error("unavailable", e.message, null)
        }
    }

    /** @return whether the result was ours */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CODE) return false
        val result = pendingPick ?: return true
        pendingPick = null
        val tree = data?.data
        if (resultCode != Activity.RESULT_OK || tree == null) {
            result.success(null)
            return true
        }
        io.execute {
            try {
                val rootId = DocumentsContract.getTreeDocumentId(tree)
                val files = ArrayList<Map<String, Any>>()
                walk(tree, rootId, "", files)
                val name = displayName(DocumentsContract.buildDocumentUriUsingTree(tree, rootId))
                    ?: rootId.substringAfterLast(':').substringAfterLast('/')
                main.post { result.success(mapOf("name" to name, "files" to files)) }
            } catch (e: Exception) {
                main.post { result.error("list_failed", e.message, null) }
            }
        }
        return true
    }

    private fun displayName(document: Uri): String? =
        activity.contentResolver.query(document, arrayOf(Document.COLUMN_DISPLAY_NAME), null, null, null)
            ?.use { if (it.moveToFirst()) it.getString(0) else null }

    private fun walk(tree: Uri, documentId: String, prefix: String, out: MutableList<Map<String, Any>>) {
        val children = DocumentsContract.buildChildDocumentsUriUsingTree(tree, documentId)
        val columns = arrayOf(
            Document.COLUMN_DOCUMENT_ID, Document.COLUMN_DISPLAY_NAME, Document.COLUMN_MIME_TYPE, Document.COLUMN_SIZE,
        )
        val folders = ArrayList<Pair<String, String>>()
        activity.contentResolver.query(children, columns, null, null, null)?.use { cursor ->
            while (cursor.moveToNext()) {
                val id = cursor.getString(0)
                val name = cursor.getString(1) ?: continue
                val relative = if (prefix.isEmpty()) name else "$prefix/$name"
                if (cursor.getString(2) == Document.MIME_TYPE_DIR) {
                    folders.add(id to relative)
                } else {
                    out.add(
                        mapOf(
                            "id" to DocumentsContract.buildDocumentUriUsingTree(tree, id).toString(),
                            "relativePath" to relative,
                            "size" to (if (cursor.isNull(3)) 0L else cursor.getLong(3)),
                        ),
                    )
                }
            }
        }
        // after the cursor is closed: a deep tree must not hold one open per level
        for ((id, relative) in folders) walk(tree, id, relative, out)
    }

    private fun read(call: MethodCall, result: MethodChannel.Result) {
        val id = call.argument<String>("id")
        val offset = call.argument<Number>("offset")?.toLong()
        val length = call.argument<Number>("length")?.toInt()
        if (id == null || offset == null || length == null || offset < 0 || length <= 0) {
            result.error("bad_args", "id, offset and length are required", null)
            return
        }
        io.execute {
            try {
                val bytes = readRange(Uri.parse(id), offset, length)
                main.post { result.success(bytes) }
            } catch (e: Exception) {
                main.post { result.error("read_failed", e.message, null) }
            }
        }
    }

    private fun readRange(document: Uri, offset: Long, length: Int): ByteArray {
        val buffer = ByteBuffer.allocate(length)
        val descriptor = activity.contentResolver.openFileDescriptor(document, "r")
            ?: throw IllegalStateException("Cannot open $document")
        descriptor.use { pfd ->
            FileInputStream(pfd.fileDescriptor).use { stream ->
                try {
                    val channel = stream.channel
                    channel.position(offset)
                    while (buffer.hasRemaining() && channel.read(buffer) >= 0) {
                        // keep reading until the range is full or the file ends
                    }
                    return buffer.array().copyOf(buffer.position())
                } catch (e: java.io.IOException) {
                    // Not seekable: a provider that streams (a cloud document). Fall through.
                }
            }
        }
        return readBySkipping(document, offset, length)
    }

    private fun readBySkipping(document: Uri, offset: Long, length: Int): ByteArray {
        val stream = activity.contentResolver.openInputStream(document)
            ?: throw IllegalStateException("Cannot open $document")
        stream.use {
            var toSkip = offset
            while (toSkip > 0) {
                val skipped = it.skip(toSkip)
                if (skipped <= 0) return ByteArray(0)
                toSkip -= skipped
            }
            val bytes = ByteArray(length)
            var filled = 0
            while (filled < length) {
                val read = it.read(bytes, filled, length - filled)
                if (read < 0) break
                filled += read
            }
            return bytes.copyOf(filled)
        }
    }

    companion object {
        private const val REQUEST_CODE = 0x1571
    }
}
