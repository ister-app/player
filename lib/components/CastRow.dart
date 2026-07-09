import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:player/graphql/fragmentCredit.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../l10n/app_localizations.dart';

/// Horizontal strip of the people credited on a movie, show or episode.
/// Each avatar taps through to that person's page ([PersonRoute], which is
/// backed by `personById`). Sorted by [Credit.castOrder] with
/// unordered entries pushed to the end.
class CastRow extends StatelessWidget {
  const CastRow({
    super.key,
    required this.serverName,
    required this.cast,
  });

  final String serverName;
  final List<Fragment$fragmentCastMember> cast;

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    final loc = AppLocalizations.of(context)!;
    final sorted = [...cast]..sort((a, b) {
        final ao = a.castOrder;
        final bo = b.castOrder;
        if (ao == null && bo == null) return 0;
        if (ao == null) return 1;
        if (bo == null) return -1;
        return ao.compareTo(bo);
      });

    // A person can be credited more than once (several characters, or one
    // character across several episodes). Show them once, listing every
    // character they play.
    final merged = <String, _CastEntry>{};
    for (final credit in sorted) {
      final entry = merged.putIfAbsent(
        credit.person.id,
        () => _CastEntry(credit.person),
      );
      final character = (credit.characterName ?? '').trim();
      if (character.isNotEmpty && !entry.characters.contains(character)) {
        entry.characters.add(character);
      }
    }

    final entries = merged.values.toList();

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                loc.cast,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final entry in entries)
                    _CastMemberTile(serverName: serverName, entry: entry),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CastEntry {
  _CastEntry(this.person);

  final Fragment$fragmentCastMember$person person;
  final List<String> characters = [];
}

class _CastMemberTile extends StatelessWidget {
  const _CastMemberTile({required this.serverName, required this.entry});

  final String serverName;
  final _CastEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final person = entry.person;
    final img = ImageUtil.getImageByType(person.images, ImageTypes.cover);
    final imageUrl =
        ImageUtil.buildUrl(img, token: StreamTokenService.getToken(serverName));
    final placeholder = Icon(
      Icons.person,
      size: 40,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return SizedBox(
      width: 104,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            AutoRouter.of(context).push(PersonRoute(personId: person.id)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Container(
                  width: 76,
                  height: 76,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: (imageUrl != null && imageUrl != '')
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          errorBuilder: (_, __, ___) => Center(child: placeholder),
                        )
                      : Center(child: placeholder),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                person.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              if (entry.characters.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  entry.characters.join(' · '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
