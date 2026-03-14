import 'package:audio_service/audio_service.dart';
import 'package:player/dto/MediaItemId.dart';

class IsterMediaItem {
  /// A unique id.
  final String id;

  final String serverName;

  final IsterMediaTypes isterMediaType;

  /// The title of this media item.
  final String title;

  /// The album this media item belongs to.
  final String? stubTitle;

  /// The duration of this media item.
  final Duration? duration;

  final Uri? artUri;

  IsterMediaItem({required this.id, required this.serverName, required this.isterMediaType, required this.title, required this.stubTitle, required this.duration, required this.artUri});

  MediaItem get mediaItem => MediaItem(id: MediaItemId(serverName, isterMediaType, id).toString(), title: title);

}

enum IsterMediaTypes {
  episode,
  show,
  list // I.E. Recent or last added
}
