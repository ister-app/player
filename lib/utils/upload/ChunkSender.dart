import 'UploadApi.dart';
import 'UploadModels.dart';
import 'UploadSource.dart';
import 'chunk_sender_stub.dart' if (dart.library.io) 'chunk_sender_io.dart' as platform;

/// Sends one chunk of a file: the transfer step of [UploadRunner], split off
/// so the runner's bookkeeping stays in the UI isolate while the bytes can
/// move elsewhere.
abstract class ChunkSender {
  /// The sender for this platform: off the UI isolate where that is possible
  /// (desktop, see `IsolateChunkSender`), [ApiChunkSender] everywhere else.
  factory ChunkSender.forApi(UploadApi api) => platform.chunkSenderFor(api);

  /// Sends bytes `[offset, end)` of [source]. Throws [UploadApiException] for
  /// a refused chunk, any other [Exception] for a transport failure.
  Future<UploadChunkResult> send(String nodeUrl, String sessionId, String fileId,
      {required int offset, required int end, required UploadSourceFile source});

  /// Releases what the sender holds between uploads; a later [send] starts over.
  Future<void> dispose();
}

/// Streams the chunk from this isolate through [UploadApi.chunk].
class ApiChunkSender implements ChunkSender {
  ApiChunkSender(this.api);
  final UploadApi api;

  @override
  Future<UploadChunkResult> send(String nodeUrl, String sessionId, String fileId,
          {required int offset, required int end, required UploadSourceFile source}) =>
      api.chunk(nodeUrl, sessionId, fileId, offset: offset, length: end - offset, bytes: source.openRead(offset, end));

  @override
  Future<void> dispose() async {}
}
