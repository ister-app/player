import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../l10n/app_localizations.dart';
import 'LoggerService.dart';

/// Fires an admin mutation and reports the outcome with a snackbar
/// ("Started: {label}" / "Failed: {label}") — every maintenance action goes
/// through here so none of them fails silently.
Future<void> runServerTask(
  BuildContext context,
  DocumentNode document,
  String label, {
  Map<String, dynamic>? variables,
}) async {
  final loc = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final client = GraphQLProvider.of(context).value;

  final result = await client.mutate(MutationOptions(
    document: document,
    variables: variables ?? const {},
  ));

  if (result.hasException) {
    LoggerService().logger.e(result.exception);
    messenger.showSnackBar(
      SnackBar(content: Text(loc.taskFailed(label))),
    );
    return;
  }
  messenger.showSnackBar(
    SnackBar(content: Text(loc.taskStarted(label))),
  );
}
