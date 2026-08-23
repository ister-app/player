import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/IsterPlayer.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// Hosts the video surface for a downloaded movie/episode played from the
/// local queue. The regular movie/episode pages query the server for their
/// metadata; this one shows only what the handler publishes.
@RoutePage()
class LocalVideoPage extends StatefulWidget {
  const LocalVideoPage({
    super.key,
    @PathParam('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<LocalVideoPage> createState() => _LocalVideoPageState();
}

class _LocalVideoPageState extends State<LocalVideoPage> {
  // The mini player's video bar is hidden by IsterPlayer itself while mounted.
  @override
  Widget build(BuildContext context) {
    final handler = MediaPlayerHandler.instance;
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<bool>(
          valueListenable: handler.mediaLoading,
          builder: (context, loading, _) => loading
              ? const SizedBox.shrink()
              : StreamBuilder(
                  stream: handler.mediaItem,
                  builder: (context, snapshot) => Text(
                      snapshot.data?.title ?? handler.mediaItem.value?.title ?? ''),
                ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => Container(
              color: Colors.black,
              height: constraints.maxWidth < 800 ? 300 : 500,
              child: const IsterPlayer(),
            ),
          ),
          StreamBuilder(
            stream: handler.mediaItem,
            builder: (context, snapshot) {
              final item = snapshot.data ?? handler.mediaItem.value;
              if (item == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: Theme.of(context).textTheme.headlineSmall),
                    if (item.album != null)
                      Text(item.album!,
                          style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
