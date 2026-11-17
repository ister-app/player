import 'package:material_ui/material_ui.dart';
import 'package:player/components/SettingsSection.dart';
import 'package:player/l10n/app_localizations.dart';

/// What a page or a row shows when its query failed and there is nothing
/// cached to show instead: a plain "could not load" with a retry, and the
/// raw exception folded away for a bug report. These surfaces used to print
/// `exception.toString()` as their whole content, with no way forward but
/// leaving the page.
class QueryErrorView extends StatelessWidget {
  const QueryErrorView({super.key, this.exception, this.onRetry})
    : compact = false;

  /// One line with a retry button, for a row inside a page (a carousel, a
  /// season's episode list) where the full hero would dwarf the content.
  const QueryErrorView.compact({super.key, this.exception, this.onRetry})
    : compact = true;

  static const retryKey = ValueKey('query-error-retry');

  final Object? exception;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final message = loc?.couldNotLoad ?? 'Could not load this page';
    final retry = loc?.retry ?? 'Try again';
    if (!compact) {
      // The same widget sits in full pages and in fixed-height shelves; the
      // hero needs room, so a short slot gets the one-line form instead of
      // an overflow.
      return LayoutBuilder(
        builder: (context, constraints) => constraints.maxHeight < 360
            ? Center(
                child: QueryErrorView.compact(
                  exception: exception,
                  onRetry: onRetry,
                ),
              )
            : SettingsErrorState(
                message: message,
                detailsLabel: loc?.errorDetails ?? 'Details',
                details: exception?.toString(),
                action: onRetry == null
                    ? null
                    : FilledButton.tonalIcon(
                        key: retryKey,
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh),
                        label: Text(retry),
                      ),
              ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 20,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(width: 8),
          Flexible(child: Text(message)),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(key: retryKey, onPressed: onRetry, child: Text(retry)),
          ],
        ],
      ),
    );
  }
}
