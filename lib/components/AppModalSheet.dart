import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Shows a modal bottom sheet anchored to the whole window.
///
/// `showModalBottomSheet` attaches to the *nearest* [Navigator]. Inside the
/// server shell that is the nested `AutoRouter` filling the content area, so a
/// sheet opened from a page — or from the video overlay on it — slides up
/// inside that area instead of from the bottom of the window, and is clipped
/// by it. The root navigator spans the window (it is also where media_kit
/// pushes its fullscreen route, so the sheet still lands on top in
/// fullscreen).
///
/// The per-server [GraphQLProvider] lives *below* the root navigator, so a
/// sheet that queries must be handed the client again: pass
/// `client: GraphQLProvider.of(context)` at the call site — it cannot be read
/// from inside the sheet's own context.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  ValueNotifier<GraphQLClient>? client,
  bool isScrollControlled = true,
  bool showDragHandle = true,
  bool useSafeArea = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: isScrollControlled,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    builder: client == null
        ? builder
        : (sheetContext) =>
            GraphQLProvider(client: client, child: Builder(builder: builder)),
  );
}
