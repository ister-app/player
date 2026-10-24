import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:file/file.dart' as f;
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ArtworkPickerPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:player/utils/artwork/ArtworkAdminApi.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

/// Serves every artwork url as a 1×1 png from memory: no network, no path_provider.
class _MemImageCache implements BaseCacheManager {
  final _fs = MemoryFileSystem();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
  }) async* {
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
  Future<FileInfo?> getFileFromCache(
    String key, {
    bool ignoreMemCache = false,
  }) async => null;
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

Map<String, dynamic> _image(
  String id,
  String type, {
  String? source,
  String? sourceUri,
  bool selected = false,
}) => {
  '__typename': 'Image',
  'type': type,
  'id': id,
  'language': null,
  'source': source,
  'sourceUri': sourceUri,
  'selected': selected,
  'blurHash': null,
  'directory': {
    '__typename': 'Directory',
    'servingNode': {'__typename': 'Node', 'url': 'http://node'},
  },
};

Map<String, dynamic> _remote(String path, {String? language}) => {
  '__typename': 'RemoteImageCandidate',
  'previewUrl': 'https://image.tmdb.org/t/p/w500$path',
  'sourceUri': 'TMDB://https://image.tmdb.org/t/p/original$path',
  'source': 'TMDB',
  'width': 2000,
  'height': 3000,
  'language': language,
  'score': 5.5,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Every GraphQL operation the page sent: (name, variables).
  final operations = <(String, Map<String, dynamic>)>[];
  late List<Map<String, dynamic>> current;
  late List<Map<String, dynamic>> remote;

  http.Response jsonResponse(Map<String, dynamic> data) => http.Response(
    json.encode({'data': data}),
    200,
    headers: {'content-type': 'application/json'},
  );

  MockClient fakeGraphQL() => MockClient((request) async {
    final body = json.decode(request.body) as Map<String, dynamic>;
    final query = body['query'] as String;
    final name = RegExp(r'(query|mutation)\s+(\w+)')
        .firstMatch(query)!
        .group(2)!;
    operations.add((name, (body['variables'] as Map).cast<String, dynamic>()));
    switch (name) {
      case 'imageCandidates':
        return jsonResponse({
          '__typename': 'Query',
          'imageCandidates': {
            '__typename': 'ImageCandidates',
            'current': current,
            'remote': remote,
          },
        });
      case 'selectImage':
        return jsonResponse({
          '__typename': 'Mutation',
          'selectImage': {...current.first, 'selected': true},
        });
      case 'selectRemoteImage':
        return jsonResponse({
          '__typename': 'Mutation',
          'selectRemoteImage': _image(
            'img-new',
            'COVER',
            source: 'TMDB',
            selected: true,
          ),
        });
      case 'selectVideoFrame':
        return jsonResponse({
          '__typename': 'Mutation',
          'selectVideoFrame': _image(
            'img-frame',
            'BACKGROUND',
            source: 'USER',
            selected: true,
          ),
        });
      case 'clearSelectedImage':
        return jsonResponse({
          '__typename': 'Mutation',
          'clearSelectedImage': true,
        });
      case 'deleteImage':
        return jsonResponse({'__typename': 'Mutation', 'deleteImage': true});
    }
    return http.Response(
      json.encode({
        'errors': [
          {'message': 'unexpected $name'},
        ],
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  });

  GraphQLClient client() => GraphQLClient(
    link: HttpLink('https://api.example/graphql', httpClient: fakeGraphQL()),
    cache: GraphQLCache(),
  );

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    CachedNetworkImageProvider.defaultCacheManager = _MemImageCache();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => client();
    WellKnownService.resetForTest();
    WellKnownService.cacheForTest(
      _server,
      WellKnownInfo(
        name: 'Test',
        oidcUrl: 'https://oidc',
        serverUrl: 'https://api.example',
      ),
    );
    operations.clear();
    current = [
      _image(
        'img-local',
        'COVER',
        source: 'LOCAL_FILE',
        sourceUri: 'file:///m/poster.jpg',
      ),
      _image(
        'img-tmdb',
        'COVER',
        source: 'TMDB',
        sourceUri: 'TMDB://https://image.tmdb.org/t/p/original/a.jpg',
        selected: true,
      ),
      _image('img-upload', 'COVER', source: 'USER', sourceUri: 'upload://u/1'),
    ];
    remote = [_remote('/a.jpg', language: 'eng'), _remote('/b.jpg')];
  });

  Future<void> pump(
    WidgetTester tester, {
    String kind = 'movie',
    String? frameMediaFileId,
    int? frameDurationMs,
    int? frameStartMs,
    ArtworkAdminApi? api,
    Future<PickedArtwork?> Function()? pickImage,
  }) async {
    tester.view.physicalSize = const Size(1000, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('en')],
        home: ArtworkPickerPage(
          serverName: _server,
          kind: kind,
          id: 'item-1',
          title: 'The Item',
          frameMediaFileId: frameMediaFileId,
          frameDurationMs: frameDurationMs,
          frameStartMs: frameStartMs,
          api: api,
          pickImage: pickImage,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'lists the stored images with the selection and the provider alternatives',
    (tester) async {
      await pump(tester);

      expect(operations.first.$1, 'imageCandidates');
      expect(operations.first.$2['type'], 'COVER');
      expect(operations.first.$2['target'], {'movieId': 'item-1'});
      for (final id in ['img-local', 'img-tmdb', 'img-upload']) {
        expect(find.byKey(ArtworkPickerPage.tileKey(id)), findsOneWidget);
      }
      // the candidate the server already has is labelled as such; the other shows its size
      expect(
        find.byKey(
          ArtworkPickerPage.remoteKey(
            'TMDB://https://image.tmdb.org/t/p/original/b.jpg',
          ),
        ),
        findsOneWidget,
      );
      expect(find.text('Already on the server · ENG'), findsOneWidget);
      expect(find.text('2000×3000'), findsOneWidget);
      // the chosen image is marked and offers the way back; only the upload can be deleted
      expect(find.byKey(ArtworkPickerPage.resetKey), findsOneWidget);
      expect(
        find.byKey(ArtworkPickerPage.deleteKey('img-upload')),
        findsOneWidget,
      );
      expect(find.byKey(ArtworkPickerPage.deleteKey('img-tmdb')), findsNothing);
      // no video file passed: no frame action
      expect(find.byKey(ArtworkPickerPage.frameKey), findsNothing);
    },
  );

  testWidgets('switching to background queries that type', (tester) async {
    await pump(tester);
    await tester.tap(
      find.byKey(ArtworkPickerPage.typeKey(ImageTypes.background)),
    );
    await tester.pumpAndSettle();
    expect(
      operations.map((o) => o.$2['type']),
      containsAllInOrder(['COVER', 'BACKGROUND']),
    );
  });

  testWidgets('tapping a stored image selects it and refetches', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(ArtworkPickerPage.tileKey('img-local')));
    await tester.pumpAndSettle();

    final select = operations.firstWhere((o) => o.$1 == 'selectImage');
    expect(select.$2, {'imageId': 'img-local'});
    expect(
      operations.where((o) => o.$1 == 'imageCandidates').length,
      2,
      reason: 'refetched after the change',
    );
    expect(find.text('Artwork updated'), findsOneWidget);
  });

  testWidgets(
    'a provider candidate the server lacks is downloaded; one it has is only selected',
    (tester) async {
      await pump(tester);
      await tester.tap(
        find.byKey(
          ArtworkPickerPage.remoteKey(
            'TMDB://https://image.tmdb.org/t/p/original/b.jpg',
          ),
        ),
      );
      await tester.pumpAndSettle();
      final download = operations.firstWhere(
        (o) => o.$1 == 'selectRemoteImage',
      );
      expect(
        download.$2['sourceUri'],
        'TMDB://https://image.tmdb.org/t/p/original/b.jpg',
      );
      expect(download.$2['type'], 'COVER');
      expect(download.$2['target'], {'movieId': 'item-1'});

      operations.clear();
      await tester.tap(
        find.byKey(
          ArtworkPickerPage.remoteKey(
            'TMDB://https://image.tmdb.org/t/p/original/a.jpg',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(operations.where((o) => o.$1 == 'selectRemoteImage'), isEmpty);
      expect(operations.firstWhere((o) => o.$1 == 'selectImage').$2, {
        'imageId': 'img-tmdb',
      });
    },
  );

  testWidgets(
    'back to automatic clears the choice; deleting an upload asks first',
    (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(ArtworkPickerPage.resetKey));
      await tester.pumpAndSettle();
      expect(operations.firstWhere((o) => o.$1 == 'clearSelectedImage').$2, {
        'target': {'movieId': 'item-1'},
        'type': 'COVER',
      });

      await tester.tap(find.byKey(ArtworkPickerPage.deleteKey('img-upload')));
      await tester.pumpAndSettle();
      expect(
        operations.where((o) => o.$1 == 'deleteImage'),
        isEmpty,
        reason: 'confirmation first',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Delete image'));
      await tester.pumpAndSettle();
      expect(operations.firstWhere((o) => o.$1 == 'deleteImage').$2, {
        'imageId': 'img-upload',
      });
    },
  );

  testWidgets(
    'a frame from the video sends the file position (episode slice offset included)',
    (tester) async {
      await pump(
        tester,
        kind: 'episode',
        frameMediaFileId: 'mf-7',
        frameDurationMs: 100000,
        frameStartMs: 600000,
      );
      await tester.tap(find.byKey(ArtworkPickerPage.frameKey));
      await tester.pumpAndSettle();
      // the slider starts in the middle of the episode: 50 s into a slice that starts at 600 s
      await tester.tap(find.byKey(ArtworkPickerPage.frameUseKey));
      await tester.pumpAndSettle();
      final frame = operations.firstWhere((o) => o.$1 == 'selectVideoFrame');
      expect(frame.$2['mediaFileId'], 'mf-7');
      expect(frame.$2['positionMs'], 650000);
      expect(frame.$2['target'], {'episodeId': 'item-1'});
    },
  );

  testWidgets('upload posts the picked file and refetches', (tester) async {
    http.Request? seen;
    final api = ArtworkAdminApi(
      _server,
      httpClient: MockClient((request) async {
        seen = request;
        return http.Response(
          json.encode({'imageId': 'img-up'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
      bearer: (_) async => 'Bearer t',
    );
    await pump(
      tester,
      api: api,
      pickImage: () async => PickedArtwork(
        bytes: Uint8List.fromList([9, 9]),
        contentType: 'image/png',
        name: 'p.png',
      ),
    );
    await tester.tap(find.byKey(ArtworkPickerPage.uploadKey));
    await tester.pumpAndSettle();

    expect(seen, isNotNull);
    expect(
      seen!.url.toString(),
      'https://api.example/artwork/upload?type=COVER&movieId=item-1',
    );
    expect(seen!.bodyBytes, [9, 9]);
    expect(operations.where((o) => o.$1 == 'imageCandidates').length, 2);
  });

  testWidgets('a server without the API says so instead of an error dump', (
    tester,
  ) async {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
      link: HttpLink(
        'https://api.example/graphql',
        httpClient: MockClient(
          (_) async => http.Response(
            json.encode({
              'errors': [
                {
                  'message': "Validation error: Field 'imageCandidates' in type 'Query' is undefined",
                },
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          ),
        ),
      ),
      cache: GraphQLCache(),
    );
    await pump(tester);
    expect(
      find.text('This server does not support changing artwork yet.'),
      findsOneWidget,
    );
  });
}
