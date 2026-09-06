import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ServerActivityPresentation.dart';

void main() {
  group('kindFor', () {
    // Every MessageQueue name the server defines must map to a non-other kind,
    // so the screen never shows a raw queue name for known work.
    const expectations = <String, ActivityKind>{
      'app.ister.server.MediaFileFound': ActivityKind.analyzeFile,
      'app.ister.server.FileScanRequested': ActivityKind.scan,
      'app.ister.server.NewDirectoriesScanRequested': ActivityKind.scan,
      'app.ister.server.MetadataBackfillRequested': ActivityKind.analyzeLibrary,
      'app.ister.server.AnalyzeData': ActivityKind.analyzeLibrary,
      'app.ister.server.ShowFound': ActivityKind.metadata,
      'app.ister.server.MovieFound': ActivityKind.metadata,
      'app.ister.server.EpisodeFound': ActivityKind.metadata,
      'app.ister.server.PersonFound': ActivityKind.metadata,
      'app.ister.server.AlbumFound': ActivityKind.metadata,
      'app.ister.server.TrackFound': ActivityKind.metadata,
      'app.ister.server.BookFound': ActivityKind.metadata,
      'app.ister.server.ChapterFound': ActivityKind.metadata,
      'app.ister.server.ComicSeriesFound': ActivityKind.metadata,
      'app.ister.server.NfoFileFound': ActivityKind.metadata,
      'app.ister.server.AudioFileFound': ActivityKind.importFiles,
      'app.ister.server.EpubFileFound': ActivityKind.importFiles,
      'app.ister.server.ComicFileFound': ActivityKind.importFiles,
      'app.ister.server.SubtitleFileFound': ActivityKind.importFiles,
      'app.ister.server.ImageFound': ActivityKind.artwork,
      'app.ister.server.UpdateImagesRequested': ActivityKind.artwork,
      'app.ister.server.TranscodeRequested': ActivityKind.transcode,
      'app.ister.server.TranscodePassRequested': ActivityKind.transcode,
      'app.ister.server.PreTranscodeRecentlyWatched': ActivityKind.transcode,
      'app.ister.server.PodcastFound': ActivityKind.podcast,
      'app.ister.server.PodcastEpisodeFound': ActivityKind.podcast,
      'app.ister.server.PodcastRefreshRequested': ActivityKind.podcast,
      'app.ister.server.PodcastEpisodeDownloadRequested': ActivityKind.podcast,
      'app.ister.server.ContinueWatchingRebuildRequested':
          ActivityKind.continueWatching,
      'app.ister.server.DetectSegments': ActivityKind.segments,
      'app.ister.server.SearchIndexRequested': ActivityKind.searchIndex,
      'app.ister.server.SearchReindexRequested': ActivityKind.searchIndex,
    };

    test('maps every known queue name', () {
      expectations.forEach((queue, kind) {
        expect(ServerActivityPresentation.kindFor(queue), kind,
            reason: queue);
      });
    });

    test('strips the per-directory suffix', () {
      expect(
          ServerActivityPresentation.kindFor(
              'app.ister.server.MediaFileFound.disk1'),
          ActivityKind.analyzeFile);
      expect(
          ServerActivityPresentation.kindFor(
              'app.ister.server.DetectSegments.disk1'),
          ActivityKind.segments);
    });

    test('unknown queues fall back to other', () {
      expect(ServerActivityPresentation.kindFor('app.ister.server.BrandNewThing'),
          ActivityKind.other);
      expect(ServerActivityPresentation.kindFor('some.exotic.queue'),
          ActivityKind.other);
    });
  });

  group('time formatting', () {
    final now = DateTime.utc(2026, 8, 16, 12, 0, 0);

    test('formatElapsed', () {
      expect(
          ServerActivityPresentation.formatElapsed(
              now.subtract(const Duration(seconds: 42)), now),
          '42s');
      expect(
          ServerActivityPresentation.formatElapsed(
              now.subtract(const Duration(minutes: 3, seconds: 5)), now),
          '3m 05s');
      expect(
          ServerActivityPresentation.formatElapsed(
              now.subtract(const Duration(hours: 1, minutes: 3)), now),
          '1h 03m');
      // A client clock slightly ahead of the server must not render negative.
      expect(
          ServerActivityPresentation.formatElapsed(
              now.add(const Duration(seconds: 5)), now),
          '0s');
    });

    test('isStale flips after three minutes', () {
      expect(
          ServerActivityPresentation.isStale(
              now.subtract(const Duration(minutes: 2, seconds: 59)), now),
          isFalse);
      expect(
          ServerActivityPresentation.isStale(
              now.subtract(const Duration(minutes: 3, seconds: 1)), now),
          isTrue);
    });

    test('parseInstant handles the server format and garbage', () {
      expect(ServerActivityPresentation.parseInstant('2026-08-16T11:59:00Z'),
          DateTime.utc(2026, 8, 16, 11, 59));
      expect(ServerActivityPresentation.parseInstant('not-a-date'), isNull);
      expect(ServerActivityPresentation.parseInstant(null), isNull);
    });
  });

  test('qualityLabel replaces underscores', () {
    expect(ServerActivityPresentation.qualityLabel('video_720p'), 'video 720p');
    expect(ServerActivityPresentation.qualityLabel('audio_0_128k'),
        'audio 0 128k');
  });

  group('groupActivity', () {
    late AppLocalizations loc;
    setUp(() async {
      loc = await AppLocalizations.delegate.load(const Locale('en'));
    });

    Fragment$fragmentServerActivityEvent node(String name,
            List<Fragment$fragmentServerActivityEvent$processing> items) =>
        Fragment$fragmentServerActivityEvent(
          type: Enum$ServerActivityEventType.NODE_ACTIVITY,
          nodeName: name,
          timestamp: '2026-09-06T10:00:00Z',
          processing: items,
        );

    test('keys on contextType + contextId, merges transcodes in and sorts oldest first',
        () {
      final groups = ServerActivityPresentation.groupActivity(loc, [
        node('a', [
          Fragment$fragmentServerActivityEvent$processing(
            queue: 'app.ister.server.MediaFileFound.disk1',
            eventType: 'x',
            startedAt: '2026-09-06T10:00:05Z',
            subject: 'S06E23 · s06e23.mkv',
            step: 'crop',
            context: 'Seinfeld',
            contextType: 'show',
            contextId: 'show-1',
            directory: 'disk1',
            $library: 'Series',
          ),
          Fragment$fragmentServerActivityEvent$processing(
            queue: 'app.ister.server.MovieFound',
            eventType: 'x',
            startedAt: '2026-09-06T10:00:01Z',
            subject: 'Die Hard',
            context: 'Die Hard (1988)',
            contextType: 'movie',
            contextId: 'movie-1',
          ),
        ]),
      ], [
        Fragment$fragmentTranscodePass(
          nodeName: 'b',
          mediaFileId: 'f',
          title: 's06e22.mkv',
          quality: 'video_720p',
          background: true,
          startedAt: '2026-09-06T10:00:00Z',
          context: 'Seinfeld',
          contextType: 'show',
          contextId: 'show-1',
        ),
      ]);

      expect(groups.map((g) => g.key), ['show:show-1', 'movie:movie-1']);
      final show = groups.first;
      expect(show.title, 'Seinfeld');
      expect(show.contextType, 'show');
      expect(show.directories, {'disk1'});
      expect(show.libraries, {'Series'});
      expect(show.entries.map((e) => e.subject), ['s06e22.mkv', 'S06E23 · s06e23.mkv']);
      expect(show.entries.first.detail, 'Transcoding · video 720p');
      expect(show.entries.first.background, isTrue);
      expect(show.entries.last.detail, 'Detecting black bars');
      expect(show.isKindFallback, isFalse);
    });

    test('work without any context is collected per kind', () {
      final groups = ServerActivityPresentation.groupActivity(loc, [
        node('a', [
          Fragment$fragmentServerActivityEvent$processing(
            queue: 'app.ister.server.SearchIndexRequested',
            eventType: 'x',
            startedAt: '2026-09-06T10:00:00Z',
          ),
          Fragment$fragmentServerActivityEvent$processing(
            queue: 'app.ister.server.SearchReindexRequested',
            eventType: 'x',
            startedAt: '2026-09-06T10:00:00Z',
          ),
        ]),
      ], const []);

      expect(groups, hasLength(1));
      expect(groups.single.key, 'kind:searchIndex');
      expect(groups.single.title, 'Updating search index');
      expect(groups.single.isKindFallback, isTrue);
      expect(groups.single.entries, hasLength(2));
      expect(groups.single.entries.first.queue,
          'app.ister.server.SearchIndexRequested');
    });

    test('a context title without an id still groups on the title', () {
      final groups = ServerActivityPresentation.groupActivity(loc, [
        node('a', [
          Fragment$fragmentServerActivityEvent$processing(
            queue: 'app.ister.server.NfoFileFound.disk1',
            eventType: 'x',
            startedAt: '2026-09-06T10:00:00Z',
            subject: 'movie.nfo',
            context: 'Movies',
          ),
        ]),
      ], const []);

      expect(groups.single.key, 'context:Movies');
      expect(groups.single.contextType, isNull);
    });
  });

  test('kindFor knows subtitle extraction', () {
    expect(
        ServerActivityPresentation.kindFor(
            'app.ister.server.SubtitleExtractRequested.disk1'),
        ActivityKind.subtitles);
  });

  test('formatBytes uses decimal units', () {
    expect(ServerActivityPresentation.formatBytes(0), '0 B');
    expect(ServerActivityPresentation.formatBytes(999), '999 B');
    expect(ServerActivityPresentation.formatBytes(1500), '1.5 kB');
    expect(ServerActivityPresentation.formatBytes(512e9), '512 GB');
    expect(ServerActivityPresentation.formatBytes(1.2e12), '1.2 TB');
  });

  test('formatUptime is coarse', () {
    final now = DateTime.utc(2026, 9, 6, 12);
    expect(
        ServerActivityPresentation.formatUptime(
            now.subtract(const Duration(minutes: 42)), now),
        '42m');
    expect(
        ServerActivityPresentation.formatUptime(
            now.subtract(const Duration(hours: 5, minutes: 12)), now),
        '5h 12m');
    expect(
        ServerActivityPresentation.formatUptime(
            now.subtract(const Duration(days: 3, hours: 4)), now),
        '3d 4h');
  });
}
