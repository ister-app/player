import 'package:media_kit/media_kit.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/PlayQueueService.dart';

import '../graphql/fragmentPlayQueue.graphql.dart';

/// Listens to player position and throttles progress updates to the server.
class ProgressSyncer {
  final PlayQueueService _playQueueService;

  Duration? _lastProgress;

  ProgressSyncer(this._playQueueService);

  void listen(
    Player player,
    Fragment$fragmentPlayQueue? Function() getPlayQueue,
    IsterMediaItem? Function() getEpisode,
    String? Function() getServerName,
    void Function(Fragment$fragmentPlayQueue) onUpdated,
  ) {
    player.stream.position.listen((pos) async {
      if (_lastProgress != null &&
          (pos - _lastProgress!).inMilliseconds.abs() <= 10 * 1000) {
        return;
      }
      _lastProgress = pos;

      final playQueue = getPlayQueue();
      final episode = getEpisode();
      final serverName = getServerName();

      if (playQueue == null || episode == null || serverName == null) return;

      final itemId =
          _playQueueService.getPlayQueueItemId(playQueue, episode.id);
      if (itemId == null) return;

      try {
        final client = ClientManager.getClientForUrl(serverName).value;
        final updated = await _playQueueService.updateProgress(
          client,
          playQueue.id,
          itemId,
          pos,
        );
        if (updated != null) onUpdated(updated);
      } catch (e) {
        LoggerService().logger.e('ProgressSyncer: failed to update progress: $e');
      }
    });
  }

  void reset() => _lastProgress = null;
}
