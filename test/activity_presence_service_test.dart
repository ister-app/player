import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/activity/ActivityPresenceService.dart';

import 'support/recording_presence.dart';

/// Lets the queued HTTP round trips of the fake server complete.
Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  late DateTime now;
  late RecordingPresence presence;

  setUp(() {
    now = DateTime.utc(2026, 10, 24, 12);
    presence = RecordingPresence(
        clock: () => now, heartbeatInterval: const Duration(milliseconds: 150));
  });

  test('begin reports the session at once with its device and position', () async {
    final handle = presence.service.begin(
      serverName: 'srv',
      mediaType: Enum$MediaType.BOOK,
      mediaId: 'book-1',
      mediaFileId: 'file-1',
      progressFraction: 0.25,
      progressLabel: 'Chapter 2',
    );
    await settle();

    expect(presence.registrations, ['srv']);
    expect(presence.reports, hasLength(1));
    final report = presence.reports.single.variables;
    expect(report['sessionId'], 'session-1');
    expect(report['mediaType'], 'BOOK');
    expect(report['mediaId'], 'book-1');
    expect(report['mediaFileId'], 'file-1');
    expect(report['progressFraction'], 0.25);
    expect(report['progressLabel'], 'Chapter 2');
    expect(report['playState'], 'PLAYING');
    expect(report['deviceId'], 'device-1');
    expect(handle.ended, isFalse);
    await handle.end();
  });

  test('the heartbeat repeats with the latest state and stops on end', () async {
    final handle = presence.service.begin(
        serverName: 'srv', mediaType: Enum$MediaType.GAME, mediaId: 'game-1');
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final beats = presence.reports.length;
    expect(beats, greaterThanOrEqualTo(3), reason: 'first send plus periodic ticks');

    await handle.end();
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(presence.ends, hasLength(1));
    expect(presence.ends.single.variables['sessionId'], 'session-1');
    expect(presence.reports.length, beats, reason: 'no heartbeat after end');
    expect(presence.calls.last.operation, 'endActivity');
    expect(handle.ended, isTrue);
  });

  test('a changed play state is sent at once, a position change waits for the gap', () async {
    final handle = presence.service.begin(
        serverName: 'srv',
        mediaType: Enum$MediaType.COMIC,
        mediaId: 'vol-1',
        progressFraction: 0.1,
        progressLabel: 'Page 1 of 10');
    await settle();
    expect(presence.reports, hasLength(1));

    // Two seconds later: a page turn is too soon to send on its own.
    now = now.add(const Duration(seconds: 2));
    handle.update(progressFraction: 0.2, progressLabel: 'Page 2 of 10');
    await settle();
    expect(presence.reports, hasLength(1));
    expect(handle.progressLabel, 'Page 2 of 10', reason: 'kept for the next heartbeat');

    // Backgrounding the app pauses the card immediately.
    handle.update(playState: Enum$PlayState.PAUSED);
    await settle();
    expect(presence.reports, hasLength(2));
    expect(presence.reports.last.variables['playState'], 'PAUSED');
    expect(presence.reports.last.variables['progressLabel'], 'Page 2 of 10');

    // After the gap a position change goes out by itself.
    now = now.add(const Duration(seconds: 6));
    handle.update(progressFraction: 0.3, progressLabel: 'Page 3 of 10');
    await settle();
    expect(presence.reports, hasLength(3));
    expect(presence.reports.last.variables['progressFraction'], 0.3);
    await handle.end();
  });

  test('a server without reportActivity is left alone after the first validation error',
      () async {
    presence.errorsFor = [
      {
        'message': "Validation error (FieldUndefined@[reportActivity]) : Field 'reportActivity' in type 'Mutation' is undefined",
        'extensions': {'classification': 'ValidationError'},
      }
    ];
    final handle = presence.service.begin(
        serverName: 'old', mediaType: Enum$MediaType.GAME, mediaId: 'game-1');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(presence.reports, hasLength(1), reason: 'no retries against an old server');
    expect(presence.service.isSupported('old'), isFalse);
    await handle.end();
    await settle();
    expect(presence.ends, isEmpty, reason: 'the server never knew the session');

    final second = presence.service.begin(
        serverName: 'old', mediaType: Enum$MediaType.BOOK, mediaId: 'book-1');
    await settle();
    expect(second.ended, isTrue);
    expect(presence.reports, hasLength(1));
  });

  test('a transient failure keeps the heartbeat going', () async {
    presence.errorsFor = [
      {'message': 'Unauthorized', 'extensions': {'classification': 'UNAUTHORIZED'}}
    ];
    final handle = presence.service.begin(
        serverName: 'srv', mediaType: Enum$MediaType.GAME, mediaId: 'game-1');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(presence.reports.length, greaterThanOrEqualTo(2));
    expect(presence.service.isSupported('srv'), isTrue);
    await handle.end();
  });

  test('isSchemaMismatch tells validation errors from transport failures', () {
    expect(
        ActivityPresenceService.isSchemaMismatch(OperationException(graphqlErrors: [
          const GraphQLError(message: 'x', extensions: {'classification': 'ValidationError'})
        ])),
        isTrue);
    expect(
        ActivityPresenceService.isSchemaMismatch(OperationException(graphqlErrors: [
          const GraphQLError(message: "Unknown argument 'progressLabel'")
        ])),
        isTrue);
    expect(
        ActivityPresenceService.isSchemaMismatch(OperationException(
            linkException: ServerException(originalException: Exception('down')))),
        isFalse);
    expect(
        ActivityPresenceService.isSchemaMismatch(OperationException(graphqlErrors: [
          const GraphQLError(message: 'Forbidden', extensions: {'classification': 'FORBIDDEN'})
        ])),
        isFalse);
  });

  test('randomSessionId is a v4 uuid', () {
    final id = ActivityPresenceService.randomSessionId();
    expect(id, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
    expect(ActivityPresenceService.randomSessionId(), isNot(id));
  });
}
