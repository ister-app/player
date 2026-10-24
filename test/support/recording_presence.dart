import 'dart:convert';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/activity/ActivityPresenceService.dart';

/// One GraphQL operation the fake server received from the presence service.
class PresenceCall {
  PresenceCall(this.operation, this.variables);

  /// `reportActivity` or `endActivity`.
  final String operation;
  final Map<String, dynamic> variables;

  @override
  String toString() => '$operation $variables';
}

/// An [ActivityPresenceService] whose GraphQL client is a fake server that
/// records every heartbeat and end, for widget and service tests. The server
/// answers with the mutation's `true`, or with [errorsFor] when set.
class RecordingPresence {
  RecordingPresence({
    DateTime Function()? clock,
    Duration heartbeatInterval = ActivityPresenceService.defaultHeartbeatInterval,
    this.errorsFor,
  }) {
    service = ActivityPresenceService.forTest(
      clientFor: (_) => GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: _client()),
        cache: GraphQLCache(),
      ),
      deviceId: () async => 'device-1',
      registerDevice: (server) => registrations.add(server),
      newSessionId: () => 'session-${++_sessions}',
      clock: clock,
      heartbeatInterval: heartbeatInterval,
    );
  }

  late final ActivityPresenceService service;
  final List<PresenceCall> calls = [];
  final List<String> registrations = [];
  int _sessions = 0;

  /// GraphQL errors the fake server answers every operation with, when set.
  List<Map<String, dynamic>>? errorsFor;

  Iterable<PresenceCall> get reports => calls.where((c) => c.operation == 'reportActivity');
  Iterable<PresenceCall> get ends => calls.where((c) => c.operation == 'endActivity');

  MockClient _client() => MockClient((request) async {
        final body = json.decode(request.body) as Map<String, dynamic>;
        final query = body['query'] as String? ?? '';
        final variables = (body['variables'] as Map<String, dynamic>?) ?? const {};
        final operation = query.contains('endActivity') ? 'endActivity' : 'reportActivity';
        calls.add(PresenceCall(operation, variables));
        final errors = errorsFor;
        final payload = errors != null
            ? {'errors': errors}
            : {
                'data': {'__typename': 'Mutation', operation: true}
              };
        return http.Response(json.encode(payload), 200,
            headers: {'content-type': 'application/json'});
      });
}
