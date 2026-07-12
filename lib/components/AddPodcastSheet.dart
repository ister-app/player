import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/searchPodcastDirectory.graphql.dart';
import 'package:player/graphql/subscribePodcast.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/LoggerService.dart';

import '../l10n/app_localizations.dart';

/// Bottom sheet to add a podcast: type a search term (iTunes directory) or
/// paste an RSS feed URL directly.
Future<void> showAddPodcastSheet(BuildContext context,
    {required VoidCallback onSubscribed}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => GraphQLProvider(
      client: GraphQLProvider.of(context),
      child: _AddPodcastSheet(onSubscribed: onSubscribed),
    ),
  );
}

class _AddPodcastSheet extends StatefulWidget {
  const _AddPodcastSheet({required this.onSubscribed});

  final VoidCallback onSubscribed;

  @override
  State<_AddPodcastSheet> createState() => _AddPodcastSheetState();
}

class _AddPodcastSheetState extends State<_AddPodcastSheet> {
  final TextEditingController _controller = TextEditingController();
  List<Query$searchPodcastDirectory$searchPodcastDirectory> _results = [];
  bool _busy = false;

  bool get _inputIsUrl {
    final text = _controller.text.trim();
    return text.startsWith('http://') || text.startsWith('https://');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_inputIsUrl) {
      await _subscribe(_controller.text.trim());
    } else {
      await _search();
    }
  }

  Future<void> _search() async {
    final term = _controller.text.trim();
    if (term.isEmpty) return;
    setState(() => _busy = true);
    final client = GraphQLProvider.of(context).value;
    final result = await client.query(QueryOptions(
      document: documentNodeQuerysearchPodcastDirectory,
      variables: {'term': term},
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (!mounted) return;
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      setState(() => _busy = false);
      return;
    }
    setState(() {
      _results = Query$searchPodcastDirectory.fromJson(result.data!)
          .searchPodcastDirectory;
      _busy = false;
    });
  }

  Future<void> _subscribe(String feedUrl) async {
    setState(() => _busy = true);
    final client = GraphQLProvider.of(context).value;
    final router = AutoRouter.of(context);
    final navigator = Navigator.of(context);
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationsubscribePodcast,
      variables: {'feedUrl': feedUrl},
    ));
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.subscribeFailed)));
      return;
    }
    final podcast =
        Mutation$subscribePodcast.fromJson(result.data!).subscribePodcast;
    widget.onSubscribed();
    navigator.pop();
    router.push(PodcastRoute(podcastId: podcast.id));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(loc.addPodcast, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: loc.addPodcastHint,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_inputIsUrl ? Icons.rss_feed : Icons.search),
                onPressed: _busy ? null : _submit,
              ),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 8),
          if (_busy) const LinearProgressIndicator(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                return ListTile(
                  leading: result.artworkUrl == null
                      ? const Icon(Icons.podcasts)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(result.artworkUrl!,
                              width: 44, height: 44, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.podcasts)),
                        ),
                  title: Text(result.name ?? result.feedUrl),
                  subtitle:
                      result.author == null ? null : Text(result.author!),
                  onTap: _busy ? null : () => _subscribe(result.feedUrl),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
