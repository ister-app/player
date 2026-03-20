import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/showById.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../utils/LoginManager.dart';

@RoutePage()
class ShowOverviewContentPage extends StatelessWidget {
  const ShowOverviewContentPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('showId') required this.showId,
  });

  final String serverName;
  final String showId;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          // document: gql(getEpisodesRecentWatched),
          document: documentNodeQueryshowById,
          variables: Map.of({"id": showId})),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        Widget body = Text("Body");

        if (result.hasException) {
          body = Text(result.exception.toString());
        } else if (result.data == null && result.isLoading) {
          body = Skeletonizer(
              enabled: true,
              child: _buildContent(
                  null, null, BoneMock.name, BoneMock.words(15), context, null));
          // Skeletonizer(enabled: true, child: Text(BoneMock.name));
        } else {
          final parsedData = Query$showById.fromJson(result.data!);

          Query$showById$showById? show = parsedData.showById;

          if (show == null) {
            body = const Text('No show found');
          } else {
            var imageByType =
                ImageUtil.getImageByType(show.images, ImageTypes.background);
            body = _buildContent(
                ImageUtil.buildUrl(imageByType),
                imageByType?.blurHash,
                MetadataUtil.getTitle(show.metadata) ?? "",
                MetadataUtil.getDescription(show.metadata) ?? "",
                context,
                show.toJson().toString());
          }
        }

        return body;
      },
    );
  }

  SingleChildScrollView _buildContent(String? imageUrl, String? blurHash,
      String title, String description, BuildContext context, String? rawJson) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth < 800 ? 300 : 500,
          width: constraints.maxWidth,
          decoration: BoxDecoration(color: Colors.grey),
          child: (imageUrl != null && imageUrl != '')
              ? CachedNetworkImage(
                  placeholder: (context, url) => blurHash != null
                      ? BlurHash(
                          hash: blurHash,
                          optimizationMode: BlurHashOptimizationMode.standard,
                          color: Colors.grey,
                          duration: Duration.zero,
                        )
                      : Container(),
                  fit: BoxFit.cover,
                  httpHeaders: LoginManager.getHeaders(serverName),
                  imageUrl: imageUrl!,
                  fadeOutDuration: Duration.zero,
                  fadeInDuration: Duration.zero,
                )
              : Container(),
        );
      }),
      Container(
          padding: EdgeInsetsGeometry.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.headlineSmall)),
                if (rawJson != null)
                  MenuAnchor(
                    menuChildren: <Widget>[
                      MenuItemButton(
                        onPressed: () {
                          _dialogBuilder(context, rawJson);
                        },
                        child: ListTile(
                          leading: const Icon(Icons.info),
                          title: Text(AppLocalizations.of(context)!.rawData),
                        ),
                      ),
                    ],
                    builder: (_, MenuController controller, Widget? child) {
                      return IconButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: const Icon(Icons.more_vert),
                      );
                    },
                  ),
              ],
            ),
            Text(description),
          ])),
    ]));
  }

  Future<void> _dialogBuilder(BuildContext context, String json) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.json),
          content: SelectableText(json),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: Text(AppLocalizations.of(context)!.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
