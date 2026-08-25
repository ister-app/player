import 'package:flutter/material.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// One muted, wrapping metadata line under a movie/show/episode title:
/// `12 Jun 2024 • 2h 18m • [16] • Science Fiction, Action • HBO • Ended`.
/// Every part is optional; the certification renders as a small outlined badge.
/// A `Wrap` (not a `Row`) so narrow phones wrap instead of ellipsizing — same
/// choice as the album page's meta row.
class MediaMetaLine extends StatelessWidget {
  const MediaMetaLine({
    super.key,
    this.released,
    this.runtime,
    this.contentRating,
    this.genres,
    this.networks,
    this.status,
  });

  /// Release/first-air date string, as stored in the metadata rows.
  final String? released;

  /// Runtime in minutes.
  final int? runtime;
  final String? contentRating;
  final String? genres;
  final String? networks;
  final String? status;

  static String formatRuntime(BuildContext context, int minutes) {
    final loc = AppLocalizations.of(context)!;
    return minutes >= 60
        ? loc.runtimeHoursMinutes(minutes ~/ 60, minutes % 60)
        : loc.runtimeMinutes(minutes);
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    final texts = <String?>[
      released,
      runtime == null ? null : formatRuntime(context, runtime!),
    ];
    final trailingTexts = <String?>[genres, networks, status];

    final parts = <Widget>[
      for (final text in texts)
        if ((text ?? '').isNotEmpty) Text(text!, style: muted),
      if ((contentRating ?? '').isNotEmpty) _badge(context, contentRating!),
      for (final text in trailingTexts)
        if ((text ?? '').isNotEmpty) Text(text!, style: muted),
    ];
    if (parts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 2,
      children: [
        for (var i = 0; i < parts.length; i++) ...[
          if (i > 0) Text(' • ', style: muted),
          parts[i],
        ],
      ],
    );
  }

  Widget _badge(BuildContext context, String rating) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: muted),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        rating,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: muted, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Read-only TMDB community rating: `★ 7.8 (1234)`. Deliberately not a second
/// star row — that would fight with the user's own RatingStars next to it.
class CommunityRating extends StatelessWidget {
  const CommunityRating({super.key, this.voteAverage, this.voteCount});

  final double? voteAverage;
  final int? voteCount;

  @override
  Widget build(BuildContext context) {
    if (voteAverage == null) return const SizedBox.shrink();
    final muted = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    final votes = voteCount == null ? '' : ' ($voteCount)';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: 14, color: Colors.amber.shade600),
        const SizedBox(width: 2),
        Text('${voteAverage!.toStringAsFixed(1)}$votes', style: muted),
      ],
    );
  }
}

/// Outlined "Trailer" button; only build it when a YouTube trailer key exists.
class TrailerButton extends StatelessWidget {
  const TrailerButton({super.key, required this.trailerKey});

  final String trailerKey;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      icon: const Icon(Icons.play_arrow),
      label: Text(loc.trailer),
      onPressed: () async {
        final url = Uri.parse('https://www.youtube.com/watch?v=$trailerKey');
        try {
          final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
          if (!ok) throw Exception('launchUrl returned false');
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(loc.trailerOpenFailed)));
          }
        }
      },
    );
  }
}
