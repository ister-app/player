import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';

/// A request timeout that *closes* the response stream when it fires.
///
/// `graphql`'s own `queryRequestTimeout` wraps the link stream in
/// `Stream.timeout`, whose default handler adds a `TimeoutException` but keeps
/// forwarding: when the real response arrives later it still reaches the
/// query manager's one-shot completer, which has already failed — and Dart
/// throws "Bad state: Future already completed" as an uncaught error (seen
/// after every slow server moment, e.g. a restart during a game session).
/// Closing the sink here means a late response is simply dropped.
class ClosingTimeoutLink extends Link {
  ClosingTimeoutLink(this.timeout);

  final Duration timeout;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (forward == null) throw StateError('ClosingTimeoutLink needs a next link');
    return forward(request).timeout(timeout, onTimeout: (sink) {
      sink.addError(TimeoutException('GraphQL request timed out after ${timeout.inSeconds} s'));
      sink.close();
    });
  }
}
