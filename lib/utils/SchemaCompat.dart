import 'package:graphql_flutter/graphql_flutter.dart';

/// Whether the failure is the server rejecting a field its schema does not have — an older
/// server, not a broken one. Callers use it to hide a feature instead of showing an error.
bool isUnknownFieldError(OperationException exception) {
  return exception.graphqlErrors.any((error) {
    final message = error.message.toLowerCase();
    return message.contains('validation') ||
        message.contains('undefined') ||
        message.contains('fielddefinition');
  });
}
