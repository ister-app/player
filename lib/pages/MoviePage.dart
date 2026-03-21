import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/movieById.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/IsterPlayer.dart';
import '../graphql/fragmentMovie.graphql.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/MetadataUtil.dart';

@RoutePage()
class MoviePage extends StatefulWidget {
  const MoviePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('movieId') required this.movieId,
    @QueryParam('playQueueId') this.playQueueId,
  });

  final String serverName;
  final String movieId;
  final String? playQueueId;

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  bool loadComplete = false;
  Fragment$fragmentMovie? movie;
  bool _playQueueStarted = false;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQuerymovieById,
        onComplete: (data) {
          setState(() {
            loadComplete = true;
            movie = Query$movieById.fromJson(data!).movieById;
          });
        },
        variables: Map.of({"id": widget.movieId}),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(result.exception.toString())),
          );
        } else if (result.data == null && result.isLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Skeletonizer(
                enabled: true,
                child: _buildContent(false, null, BoneMock.name, BoneMock.words(15), context),
              ),
            ),
          );
        } else {
          final MediaPlayerHandler handler = MediaPlayerHandler.instance;
          if (movie != null && !_playQueueStarted) {
            _playQueueStarted = true;
            handler.startPlayQueueForMovie(
              GraphQLProvider.of(context).value,
              widget.playQueueId,
              movie!,
              widget.serverName,
            );
          }
          final title = movie?.name ?? MetadataUtil.getTitle(movie?.metadata) ?? '';
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: SingleChildScrollView(
              child: _buildContent(
                loadComplete,
                movie,
                title,
                MetadataUtil.getDescription(movie?.metadata) ?? '',
                context,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildContent(bool loadComplete, Fragment$fragmentMovie? movie,
      String title, String description, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
            height: constraints.maxWidth < 800 ? 300 : 500,
            child: movie != null && loadComplete
                ? kIsWeb ||
                        movie.mediaFile == null ||
                        movie.mediaFile!.isEmpty
                    ? LayoutBuilder(builder: (context, constraints) {
                        var imageByType = ImageUtil.getImageByType(
                            movie.images, ImageTypes.background);
                        return Container(
                          height: constraints.maxWidth < 800 ? 300 : 500,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                          child: imageByType != null
                              ? Image.network(
                                  ImageUtil.buildUrl(imageByType)!,
                                  fit: BoxFit.cover,
                                )
                              : Container(),
                        );
                      })
                    : IsterPlayer()
                : Container(),
          );
        },
      ),
      Container(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(description),
          ])),
    ]);
  }
}
