import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/PlaylistService.dart';
import 'package:player/utils/filter/MediaFilterModel.dart';

import 'support/harness.dart';

/// Playlists end-to-end against the kind deployment: a manual playlist built
/// from real tracks plays as a PLAYLIST queue, and a smart playlist resolves
/// its filter server-side. One boot for both scenarios — a second cold start
/// (mpv/GL init) in the same process is flaky, see doc_tour_test. Needs a
/// server with the playlist schema (2.7.1+ snapshot line).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('manual and smart playlists play as PLAYLIST queues',
      (tester) async {
    await bootApp(tester);
    await enterServerShell(tester);
    final client = await appClient();
    final handler = MediaPlayerHandler.instance;
    final player = handler.player;

    // Two playable tracks of the fixture music library.
    final libraries = await gqlRaw('{ libraries { id name type } }');
    final musicLibrary = (libraries['libraries'] as List).firstWhere(
        (library) => library['type'] == 'MUSIC',
        orElse: () => fail('no music library in the fixture data'));
    final libraryId = musicLibrary['id'] as String;
    final tracks = await gqlRaw(
        'query(\$libraryId: ID) { tracks(size: 50, libraryId: \$libraryId) '
        '{ content { id mediaFile { id } } } }',
        variables: {'libraryId': libraryId});
    final trackIds = (tracks['tracks']['content'] as List)
        .where((track) => (track['mediaFile'] as List? ?? []).isNotEmpty)
        .map((track) => track['id'] as String)
        .take(2)
        .toList();
    if (trackIds.length < 2) fail('need at least two playable tracks');

    // Manual: create, fill, play, and verify the queue shape.
    final manual = await PlaylistService.create(
      client,
      name: 'E2E Mix',
      libraryId: libraryId,
      type: Enum$PlaylistType.MANUAL,
    );
    expect(manual, isNotNull, reason: 'createPlaylist failed');
    try {
      for (final trackId in trackIds) {
        expect(
            await PlaylistService.addItem(client,
                playlistId: manual!.id, mediaId: trackId),
            isTrue,
            reason: 'addPlaylistItem failed for $trackId');
      }
      final loaded = await PlaylistService.byId(client, manual!.id);
      expect(loaded?.items, hasLength(2));

      await handler.startPlaylistPlay(client, testServer, manual.id);
      await pumpUntil(
        tester,
        () => player.state.playing,
        timeout: const Duration(minutes: 2),
        description: 'manual playlist playback to start',
      );
      expect(handler.playQueue?.sourceType, Enum$PlayQueueSourceType.PLAYLIST);
      expect(handler.playQueue?.playQueueItems, hasLength(2));

      final startPosition = player.state.position;
      await pumpUntil(
        tester,
        () =>
            player.state.position - startPosition >= const Duration(seconds: 3),
        // Audio goes through an HLS transcode too; a cold pass on a busy CI
        // cluster can take minutes before the first segment plays.
        timeout: const Duration(minutes: 3),
        description: 'the playlist position to advance 3 seconds',
      );
      await handler.stop();
    } finally {
      await PlaylistService.delete(client, manual!.id);
    }

    // Smart: a match-all track filter resolves into a playing queue.
    final smart = await PlaylistService.create(
      client,
      name: 'E2E Smart',
      libraryId: libraryId,
      type: Enum$PlaylistType.SMART,
      filter: MediaFilterModel(),
      filterKind: Enum$FilterKind.TRACK,
    );
    expect(smart, isNotNull, reason: 'createPlaylist (smart) failed');
    try {
      await handler.startPlaylistPlay(client, testServer, smart!.id);
      await pumpUntil(
        tester,
        () =>
            handler.playQueue?.sourceType ==
                Enum$PlayQueueSourceType.PLAYLIST &&
            player.state.playing,
        timeout: const Duration(minutes: 2),
        description: 'smart playlist playback to start',
      );
      expect(handler.playQueue?.playQueueItems, isNotEmpty);
      await handler.stop();
    } finally {
      await PlaylistService.delete(client, smart!.id);
    }
  });
}
