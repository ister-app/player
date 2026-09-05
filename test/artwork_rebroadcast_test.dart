import 'dart:convert';

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:file/file.dart' as f;
import 'package:file/memory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/ArtworkImage.dart';
import 'package:player/components/RelatedShowsRow.dart';
import 'package:player/graphql/showById.graphql.dart';
import 'package:player/l10n/app_localizations.dart';

// A tile's artwork must not blink to the placeholder when the GraphQL cache
// rebroadcasts the row after another query wrote the same Show entity. The
// server returns image lists without an ORDER BY, so a second query can hand
// back the same images in another order; the pick has to stay the same, and
// when the image genuinely changes the old picture stays up until the new
// one is decoded.

final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

/// A cache manager that serves every url as a 1×1 png from memory — the
/// artwork widgets never touch path_provider or the network.
class _MemImageCache implements BaseCacheManager {
  final _fs = MemoryFileSystem();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
  }) async* {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final file = _fs.file('/c/${(key ?? url).hashCode}.png')
      ..parent.createSync(recursive: true)
      ..writeAsBytesSync(_png);
    yield FileInfo(
      file,
      FileSource.Online,
      DateTime.now().add(const Duration(days: 1)),
      url,
    );
  }

  @override
  Future<void> removeFile(String key) async {}
  @override
  Future<void> emptyCache() async {}
  @override
  Future<void> dispose() async {}
  @override
  Future<FileInfo?> getFileFromCache(String key, {bool ignoreMemCache = false}) async =>
      null;
  @override
  Future<f.File> putFile(
    String url,
    List<int> fileBytes, {
    String? key,
    String? eTag,
    Duration maxAge = const Duration(days: 30),
    String fileExtension = 'file',
  }) async => _fs.file('/unused');
}

Map<String, dynamic> _image(String id) => {
  '__typename': 'Image',
  'type': 'BACKGROUND',
  'id': id,
  'language': null,
  'source': 'TMDB',
  'blurHash': null,
  'directory': {
    '__typename': 'Directory',
    'node': {'__typename': 'Node', 'url': 'http://srv'},
  },
};

Map<String, dynamic> _show(String id, List<String> images) => {
  '__typename': 'Show',
  'id': id,
  'name': 'Show $id',
  'releaseYear': 2020,
  'images': [for (final i in images) _image(i)],
  'metadata': <dynamic>[],
};

/// The images each show carries, per query, in the order the "server" lists
/// them. Tests swap this between requests.
late List<String> Function(String showId) imagesFor;

http.Client _fakeGraphQL() => MockClient((request) async {
  final body = json.decode(request.body) as Map<String, dynamic>;
  final query = body['query'] as String;
  final Map<String, dynamic> data;
  if (query.contains('relatedShows')) {
    data = {
      '__typename': 'Query',
      'showById': {
        '__typename': 'Show',
        'id': 'main',
        'related': [for (final s in ['a', 'b', 'c']) _show(s, imagesFor(s))],
      },
    };
  } else {
    final id = (body['variables'] as Map)['id'] as String;
    data = {
      '__typename': 'Query',
      'showById': {
        ..._show(id, imagesFor(id)),
        'seasons': <dynamic>[],
        'cast': <dynamic>[],
        for (final k in [
          'rating', 'tmdbId', 'imdbId', 'voteAverage', 'voteCount',
          'contentRating', 'status', 'homepage', 'trailerKey', 'trailerSite',
        ])
          k: null,
        for (final k in ['networks', 'studios', 'originCountry', 'keywords'])
          k: <dynamic>[],
      },
    };
  }
  return http.Response(
    json.encode({'data': data}),
    200,
    headers: {'content-type': 'application/json'},
  );
});

Widget _app(ValueNotifier<GraphQLClient> client) => GraphQLProvider(
  client: client,
  child: const MaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [Locale('en')],
    home: Scaffold(body: RelatedShowsRow(serverName: 'srv', showId: 'main')),
  ),
);

int _painted(WidgetTester tester) => tester
    .widgetList<RawImage>(find.byType(RawImage))
    .where((r) => r.image != null)
    .length;

List<String?> _imageIds(WidgetTester tester) => tester
    .widgetList<ArtworkImage>(find.byType(ArtworkImage))
    .map((w) => w.url?.split('/images/').last.split('/').first)
    .toList();

/// Pumps real frames (image decoding needs real async) and returns the lowest
/// number of painted tiles seen in any of them.
Future<int> _minPaintedOver(WidgetTester tester, int frames) async {
  var min = 1 << 30;
  await tester.runAsync(() async {
    for (var i = 0; i < frames; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await tester.pump();
      final n = _painted(tester);
      if (n < min) min = n;
    }
  });
  return min;
}

void main() {
  late ValueNotifier<GraphQLClient> client;

  setUp(() {
    imagesFor = (id) => ['$id-bg-1', '$id-bg-2'];
    CachedNetworkImageProvider.defaultCacheManager = _MemImageCache();
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
    client = ValueNotifier(
      GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: _fakeGraphQL()),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );
  });

  Future<void> loadRow(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(_app(client));
      for (var i = 0; i < 40 && _painted(tester) < 3; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await tester.pump();
      }
    });
    expect(_painted(tester), 3, reason: 'row did not load');
    expect(_imageIds(tester), ['a-bg-1', 'b-bg-1', 'c-bg-1']);
  }

  Future<void> writeShowFromAnotherQuery(WidgetTester tester, String id) =>
      tester.runAsync(() async {
        final result = await client.value.query(
          QueryOptions(
            document: documentNodeQueryshowById,
            variables: {'id': id},
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        );
        expect(result.exception, isNull);
      });

  testWidgets('a reordered image list from another query keeps the same pick', (
    tester,
  ) async {
    await loadRow(tester);

    imagesFor = (id) => ['$id-bg-2', '$id-bg-1'];
    await writeShowFromAnotherQuery(tester, 'b');

    expect(await _minPaintedOver(tester, 8), 3);
    expect(_imageIds(tester), ['a-bg-1', 'b-bg-1', 'c-bg-1']);
  });

  testWidgets('a genuinely changed image keeps the old picture up while loading', (
    tester,
  ) async {
    await loadRow(tester);

    imagesFor = (id) => id == 'b' ? ['b-other'] : ['$id-bg-1', '$id-bg-2'];
    await writeShowFromAnotherQuery(tester, 'b');

    // Before the fix this dipped to 2: the tile showed the placeholder until
    // the new image had decoded.
    expect(await _minPaintedOver(tester, 8), 3);
    expect(_imageIds(tester), ['a-bg-1', 'b-other', 'c-bg-1']);
  });
}
