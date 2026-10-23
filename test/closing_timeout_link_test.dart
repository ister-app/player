import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/utils/ClosingTimeoutLink.dart';

void main() {
  final request = Request(operation: Operation(document: gql('query { x }')));

  test('a response within the timeout passes through', () async {
    final link = ClosingTimeoutLink(const Duration(milliseconds: 200))
        .concat(Link.function((req, [fwd]) => Stream.value(const Response(data: {'x': 1}, response: {}))));
    expect((await link.request(request).first).data, {'x': 1});
  });

  test('a late response is dropped after the timeout error, the stream is closed', () async {
    final late = Completer<Response>();
    final link = ClosingTimeoutLink(const Duration(milliseconds: 50))
        .concat(Link.function((req, [fwd]) => Stream.fromFuture(late.future)));
    final events = <Object>[];
    final done = Completer<void>();
    link.request(request).listen(events.add, onError: events.add, onDone: done.complete);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(done.isCompleted, isTrue, reason: 'closed by the timeout');
    late.complete(const Response(data: {'x': 2}, response: {}));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(events, hasLength(1));
    expect(events.single, isA<TimeoutException>());
  });
}
