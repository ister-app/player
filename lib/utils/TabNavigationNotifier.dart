import 'package:flutter/foundation.dart';

/// Indexes of the server shell's main tabs, in the order
/// `ServerHomeOverviewPage` lists their routes.
abstract final class ServerTab {
  static const home = 0;
  static const search = 1;
  static const library = 2;
  static const settings = 3;
}

final tabNavigationNotifier = ValueNotifier<int>(ServerTab.home);
