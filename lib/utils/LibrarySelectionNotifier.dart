import 'package:flutter/foundation.dart';
import 'package:player/graphql/schema.graphql.dart';

/// A library the user picked outside the library tab (a home-page row header).
///
/// The home page only *announces* the choice here and switches the tab; the
/// library tab consumes it and owns the persistence, whether it is freshly
/// built or already alive behind the tab bar.
class PendingLibrarySelection {
  const PendingLibrarySelection({
    required this.serverName,
    required this.libraryId,
    required this.libraryType,
  });

  final String serverName;
  final String libraryId;
  final Enum$LibraryType libraryType;
}

final pendingLibrarySelection = ValueNotifier<PendingLibrarySelection?>(null);
