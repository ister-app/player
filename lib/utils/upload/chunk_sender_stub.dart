import 'ChunkSender.dart';
import 'UploadApi.dart';

/// Web: no isolates, and the bytes are browser blobs anyway.
ChunkSender chunkSenderFor(UploadApi api) => ApiChunkSender(api);
