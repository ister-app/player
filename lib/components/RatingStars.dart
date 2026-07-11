import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/setRating.graphql.dart';
import 'package:player/utils/LoggerService.dart';

import '../l10n/app_localizations.dart';

/// Interactive 1-10 rating rendered as five half-step stars.
///
/// A rating is stored per (user, item) on the server; the 1-10 value maps to
/// 0.5-5.0 stars (odd = half star). Tapping the left/right half of a star sets
/// the corresponding value; tapping the value that is already set clears it
/// (`setRating(rating: null)`). The change is applied optimistically and
/// reverted if the mutation fails.
class RatingStars extends StatefulWidget {
  const RatingStars({
    super.key,
    required this.mediaType,
    required this.mediaId,
    required this.rating,
    this.size = 30,
    this.showValue = true,
    this.onChanged,
    this.client,
  });

  final Enum$RatingMediaType mediaType;
  final String mediaId;

  /// GraphQL client to mutate through. Falls back to the ambient
  /// [GraphQLProvider] when null — pass it explicitly from a dialog, whose
  /// (root-navigator) context sits above the per-server provider.
  final GraphQLClient? client;

  /// Current rating (1-10), or null when unrated.
  final int? rating;

  /// Star icon size.
  final double size;

  /// Whether to show the numeric `x/10` next to the stars.
  final bool showValue;

  /// Called with the new value after a successful save (e.g. so a list row can
  /// update a compact badge). Not called on failure.
  final ValueChanged<int?>? onChanged;

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  int? _rating;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
  }

  @override
  void didUpdateWidget(RatingStars oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Adopt a fresh server value (e.g. after a refetch), but don't clobber an
    // in-flight optimistic change of our own.
    if (widget.rating != oldWidget.rating && !_saving) {
      _rating = widget.rating;
    }
  }

  Future<void> _apply(int? value) async {
    if (_saving) return;
    final previous = _rating;
    setState(() {
      _rating = value;
      _saving = true;
    });

    final client = widget.client ?? GraphQLProvider.of(context).value;
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationsetRating,
      variables: Variables$Mutation$setRating(
        mediaType: widget.mediaType,
        mediaId: widget.mediaId,
        rating: value,
      ).toJson(),
    ));

    if (!mounted) return;
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      setState(() {
        _rating = previous;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.ratingFailed)),
      );
    } else {
      setState(() => _saving = false);
      widget.onChanged?.call(value);
    }
  }

  void _onTap(int starIndex, bool leftHalf) {
    // Star i covers value (2i+1) on its left half and (2i+2) on its right half.
    final value = starIndex * 2 + (leftHalf ? 1 : 2);
    _apply(value == _rating ? null : value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final rating = _rating ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          _StarIcon(
            size: widget.size,
            filled: theme.colorScheme.primary,
            empty: theme.colorScheme.onSurfaceVariant,
            // 0 = empty, 1 = half, 2 = full
            fill: rating >= (i + 1) * 2
                ? 2
                : rating == i * 2 + 1
                    ? 1
                    : 0,
            onTapHalf: _saving ? null : (leftHalf) => _onTap(i, leftHalf),
          ),
        if (widget.showValue && _rating != null) ...[
          SizedBox(width: widget.size * 0.25),
          Text(
            loc.ratingValue(_rating!),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Non-interactive rendering of a 1-10 rating as five half-step stars, for
/// surfaces that display a rating without editing it (e.g. a track list row
/// next to the duration). Sized to sit inline with small body text.
class RatingStarsDisplay extends StatelessWidget {
  const RatingStarsDisplay({
    super.key,
    required this.rating,
    this.size = 14,
    this.color,
    this.emptyColor,
  });

  /// Current rating (1-10), or null when unrated.
  final int? rating;

  /// Star icon size.
  final double size;

  /// Filled-star colour (defaults to the theme primary).
  final Color? color;

  /// Empty-star colour (defaults to onSurfaceVariant).
  final Color? emptyColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = rating ?? 0;
    final filled = color ?? theme.colorScheme.primary;
    final empty = emptyColor ?? theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          _StarIcon(
            size: size,
            filled: filled,
            empty: empty,
            // 0 = empty, 1 = half, 2 = full
            fill: value >= (i + 1) * 2
                ? 2
                : value == i * 2 + 1
                    ? 1
                    : 0,
            onTapHalf: null,
          ),
      ],
    );
  }
}

class _StarIcon extends StatelessWidget {
  const _StarIcon({
    required this.size,
    required this.fill,
    required this.filled,
    required this.empty,
    required this.onTapHalf,
  });

  final double size;

  /// 0 = empty, 1 = half, 2 = full.
  final int fill;
  final Color filled;
  final Color empty;

  /// Called with `true` for the left half, `false` for the right half.
  final void Function(bool leftHalf)? onTapHalf;

  @override
  Widget build(BuildContext context) {
    final IconData icon = switch (fill) {
      2 => Icons.star_rounded,
      1 => Icons.star_half_rounded,
      _ => Icons.star_outline_rounded,
    };
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: onTapHalf == null
          ? null
          : (details) => onTapHalf!(details.localPosition.dx < size / 2),
      child: Icon(
        icon,
        size: size,
        color: fill == 0 ? empty : filled,
      ),
    );
  }
}

/// Opens a dialog holding a [RatingStars] control, for surfaces too dense to
/// embed the stars inline (e.g. a track list row). Resolves after the dialog
/// closes; the star taps themselves save immediately.
Future<void> showRatingDialog(
  BuildContext context, {
  required Enum$RatingMediaType mediaType,
  required String mediaId,
  required int? rating,
  required String title,
  ValueChanged<int?>? onChanged,
}) {
  final loc = AppLocalizations.of(context)!;
  // Capture the client here: the dialog's builder context lives on the root
  // navigator, above the per-server GraphQLProvider, so it can't be read there.
  final client = GraphQLProvider.of(context).value;
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingStars(
            mediaType: mediaType,
            mediaId: mediaId,
            rating: rating,
            size: 40,
            showValue: false,
            onChanged: onChanged,
            client: client,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.close),
        ),
      ],
    ),
  );
}
