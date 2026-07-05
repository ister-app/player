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
/// Each avatar taps through to that person's page (reusing [ArtistRoute],
/// which is backed by `personById`). Sorted by [Credit.castOrder] with
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

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                loc.cast,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: sorted.length,
                itemBuilder: (context, index) =>
                    _CastMemberTile(serverName: serverName, credit: sorted[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CastMemberTile extends StatelessWidget {
  const _CastMemberTile({required this.serverName, required this.credit});

  final String serverName;
  final Fragment$fragmentCastMember credit;

  @override
  Widget build(BuildContext context) {
    final person = credit.person;
    final img = ImageUtil.getImageByType(person.images, ImageTypes.cover);
    final imageUrl =
        ImageUtil.buildUrl(img, token: StreamTokenService.getToken(serverName));
    final placeholder = Icon(
      Icons.person,
      size: 40,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return SizedBox(
      width: 96,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            AutoRouter.of(context).push(ArtistRoute(artistId: person.id)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            children: [
              ClipOval(
                child: Container(
                  width: 72,
                  height: 72,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
              const SizedBox(height: 6),
              Text(
                person.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if ((credit.characterName ?? '').isNotEmpty)
                Text(
                  credit.characterName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
