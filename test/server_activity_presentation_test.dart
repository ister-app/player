import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/ServerActivityPresentation.dart';

void main() {
  group('kindFor', () {
    // Every MessageQueue name the server defines must map to a non-other kind,
    // so the screen never shows a raw queue name for known work.
    const expectations = <String, ActivityKind>{
      'app.ister.server.MediaFileFound': ActivityKind.analyzeFile,
      'app.ister.server.FileScanRequested': ActivityKind.scan,
      'app.ister.server.NewDirectoriesScanRequested': ActivityKind.scan,
      'app.ister.server.AnalyzeLibraryRequested': ActivityKind.analyzeLibrary,
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
}
