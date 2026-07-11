import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/utils/LoggerService.dart';

/// Keeps a GraphQL subscription alive across terminal frames.
///
/// `graphql`'s socket client only re-subscribes after the *socket* drops. When
/// the server ends a single subscription — a `complete` or `error` frame — the
/// Dart stream is closed for good while the socket happily stays open, so no
/// further data ever arrives. Subscribers would silently freeze on whatever
/// they last rendered until the widget is rebuilt.
///
/// This re-opens the subscription after such a terminal frame, backing off so a
/// server that rejects the operation outright isn't hammered.
class ResilientSubscription {
  ResilientSubscription({
    required GraphQLClient client,
    required DocumentNode document,
    Map<String, dynamic>? variables,
    required void Function(QueryResult result) onData,
    required void Function(Object error) onFailure,
    this.retryDelay = const Duration(seconds: 5),
  })  : _client = client,
        _document = document,
        _variables = variables,
        _onData = onData,
        _onFailure = onFailure {
    _connect();
  }

  final GraphQLClient _client;
  final DocumentNode _document;
  final Map<String, dynamic>? _variables;
  final void Function(QueryResult result) _onData;
  final void Function(Object error) _onFailure;
  final Duration retryDelay;

  StreamSubscription<QueryResult>? _subscription;
  Timer? _retryTimer;
  bool _disposed = false;

  void _connect() {
    if (_disposed) return;
    _subscription?.cancel();
    _subscription = _client
        .subscribe(SubscriptionOptions(
            document: _document, variables: _variables ?? const {}))
        .listen(
          _handleResult,
          // A transport failure surfaces as an error rather than a result.
          onError: _handleFailure,
          // The server ended this subscription; nothing more will arrive on it.
          onDone: _scheduleRetry,
        );
  }

  void _handleResult(QueryResult result) {
    if (_disposed) return;
    if (result.hasException) {
      _handleFailure(result.exception!);
      return;
    }
    if (result.data == null) return;
    _onData(result);
  }

  void _handleFailure(Object error) {
    if (_disposed) return;
    LoggerService().logger.e(error);
    _onFailure(error);
    _scheduleRetry();
  }

  void _scheduleRetry() {
    if (_disposed || _retryTimer != null) return;
    _retryTimer = Timer(retryDelay, () {
      _retryTimer = null;
      _connect();
    });
  }

  Future<void> dispose() async {
    _disposed = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    await _subscription?.cancel();
    _subscription = null;
  }
}
